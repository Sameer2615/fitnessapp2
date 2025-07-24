import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:path_provider/path_provider.dart';

class PoseCameraScreen extends StatefulWidget {
  const PoseCameraScreen({Key? key}) : super(key: key);

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
    final WriteBuffer allBytes = WriteBuffer();
    for (var plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = _cameras[0];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    // For version 0.5.0, we need to save the image to a temporary file first
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/temp_camera_image.jpg';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    // Create InputImage from file path
    final inputImage = InputImage.fromFilePath(filePath);

    final poses = await _poseDetector.processImage(inputImage);

    // Clean up the temporary file
    await file.delete();

    if (poses.isNotEmpty) {
      final painter = PosePainter(poses.first, imageSize);
      setState(() {
        _customPaint = CustomPaint(painter: painter);
      });
    }

    _isDetecting = false;
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
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Scale between actual camera image size and screen size
    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    Offset transform(PoseLandmark landmark) {
      double x = landmark.x * scaleX;
      double y = landmark.y * scaleY;

      // Flip horizontally for front camera
      if (isFrontCamera) {
        x = size.width - x;
      }

      return Offset(x, y);
    }

    // Draw keypoints
    for (final landmark in pose.landmarks.values) {
      final offset = transform(landmark);
      canvas.drawCircle(offset, 5, dotPaint);
    }

    // Helper to draw lines between joints
    void drawLine(PoseLandmarkType type1, PoseLandmarkType type2) {
      final landmark1 = pose.landmarks[type1];
      final landmark2 = pose.landmarks[type2];
      if (landmark1 != null && landmark2 != null) {
        canvas.drawLine(transform(landmark1), transform(landmark2), linePaint);
      }
    }

    // Draw common skeleton connections
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    drawLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    drawLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
    drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
    drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
    drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
    drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    drawLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    drawLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
    drawLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
  }

  @override
  bool shouldRepaint(PosePainter oldDelegate) => true;
}
