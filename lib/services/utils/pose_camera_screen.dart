import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:path_provider/path_provider.dart';

class PoseCameraScreen extends StatefulWidget {
  const PoseCameraScreen({super.key});

  @override
  State<PoseCameraScreen> createState() => _PoseCameraScreenState();
}

class _PoseCameraScreenState extends State<PoseCameraScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isDetecting = false;
  CustomPaint? _customPaint;
  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );
  Future<void> _switchCamera() async {
    await _cameraController.stopImageStream();
    await _cameraController.dispose();

    final currentDirection = _cameraController.description.lensDirection;
    final newDirection = currentDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    final newCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == newDirection,
      orElse: () => _cameras.first,
    );

    _cameraController = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController.initialize();
    if (!mounted) return;

    _cameraController.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      _processCameraImage(image);
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController.initialize();
    if (!mounted) return;

    _cameraController.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      _processCameraImage(image);
    });

    setState(() {});
  }

  Future<void> _processCameraImage(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (var plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      // Write image bytes to file
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/temp.jpg';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Create InputImage
      final inputImage = InputImage.fromFilePath(filePath);

      // Process image
      final poses = await _poseDetector.processImage(inputImage);
      if (poses.isEmpty) {
        print("❌ No pose detected in image.");
        return;
      }

      // Delete temporary file
      await file.delete();

      if (poses.isNotEmpty) {
        final pose = poses.first;
        final imageSize = _cameraController.value.previewSize!;
        final isFront = _cameraController.description.lensDirection ==
            CameraLensDirection.front;

        setState(() {
          _customPaint = CustomPaint(
            painter: PosePainter(pose, imageSize, isFrontCamera: isFront),
          );
        });
      }
    } catch (e) {
      debugPrint('Pose processing error: $e');
    } finally {
      _isDetecting = false;
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized = _cameraController.value.isInitialized;
    final size =
        isInitialized ? _cameraController.value.previewSize! : const Size(1, 1);
    final aspectRatio = size.height / size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pose Detector'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: isInitialized ? _switchCamera : null,
          ),
        ],
      ),
      body: Center(
        child: isInitialized
            ? AspectRatio(
                aspectRatio: aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(_cameraController),
                    if (_customPaint != null) _customPaint!,
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;
  final bool isFrontCamera;

  PosePainter(this.pose, this.imageSize, {this.isFrontCamera = false});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0;

    final double scaleX =
        size.width / imageSize.height; // Note: width <-> height
    final double scaleY = size.height / imageSize.width;

    Offset translate(PoseLandmark landmark) {
      double x = landmark.y * scaleX;
      double y = landmark.x * scaleY;

      if (isFrontCamera) x = size.width - x;

      return Offset(x, y);
    }

    for (final landmark in pose.landmarks.values) {
      canvas.drawCircle(translate(landmark), 5, dotPaint);
    }

    void drawLine(PoseLandmarkType type1, PoseLandmarkType type2) {
      final l1 = pose.landmarks[type1];
      final l2 = pose.landmarks[type2];
      if (l1 != null && l2 != null) {
        canvas.drawLine(translate(l1), translate(l2), linePaint);
      }
    }

    // Skeleton connections
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    drawLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    drawLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
    drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    drawLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    drawLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
    drawLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
