import 'dart:ui' as ui;
import 'package:fitnessapp/screens/activity/pose_camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseViewerPage extends StatefulWidget {
  const PoseViewerPage({Key? key}) : super(key: key);

  @override
  State<PoseViewerPage> createState() => _PoseViewerPageState();
}

class _PoseViewerPageState extends State<PoseViewerPage> {
  final ImagePicker _picker = ImagePicker();
  ui.Image? _uiImage;
  Pose? _detectedPose;

  Future<void> _pickAndDetectPose() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose image source"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text("Gallery"),
          ),
        ],
      ),
    );

    if (source == null) return;

    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    final inputImage = InputImage.fromFilePath(pickedFile.path);
    final detector = PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.single),
    );

    final data = await pickedFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frame = await codec.getNextFrame();
    final img = frame.image;

    final poses = await detector.processImage(inputImage);
    await detector.close();

    Pose? pose = poses.isNotEmpty ? poses.first : null;

    setState(() {
      _uiImage = img;
      _detectedPose = pose;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pose Viewer")),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickAndDetectPose,
              child: const Text("Pick Image & Show Pose"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PoseCameraScreen()),
                );
              },
              child: const Text("Live Pose Detection via Camera"),
            ),
            if (_uiImage != null)
              Expanded(
                child: AspectRatio(
                  aspectRatio: _uiImage!.width / _uiImage!.height,
                  child: CustomPaint(
                    painter: _detectedPose != null
                        ? PosePainter(_uiImage!, _detectedPose!)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  final ui.Image image;
  final Pose pose;

  PosePainter(this.image, this.pose);

  @override
  void paint(Canvas canvas, Size size) {
    final paintImage = Paint();
    final imageAspect = image.width / image.height;
    final canvasAspect = size.width / size.height;

    double drawWidth, drawHeight;
    if (canvasAspect > imageAspect) {
      drawHeight = size.height;
      drawWidth = imageAspect * drawHeight;
    } else {
      drawWidth = size.width;
      drawHeight = drawWidth / imageAspect;
    }

    final dx = (size.width - drawWidth) / 2;
    final dy = (size.height - drawHeight) / 2;

    final dst = Rect.fromLTWH(dx, dy, drawWidth, drawHeight);
    final src =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    canvas.drawImageRect(image, src, dst, paintImage);

    final landmarks = pose.landmarks;

    final landmarkPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;
    final scaleX = drawWidth / image.width;
    final scaleY = drawHeight / image.height;
    final offsetX = dx;
    final offsetY = dy;

    for (final lm in landmarks.values) {
      canvas.drawCircle(
        Offset(lm.x * scaleX + offsetX, lm.y * scaleY + offsetY),
        4,
        landmarkPaint,
      );
    }

    void connect(PoseLandmarkType a, PoseLandmarkType b) {
      final p1 = landmarks[a];
      final p2 = landmarks[b];
      if (p1 != null && p2 != null) {
        canvas.drawLine(
          Offset(p1.x * scaleX + offsetX, p1.y * scaleY + offsetY),
          Offset(p2.x * scaleX + offsetX, p2.y * scaleY + offsetY),
          linePaint,
        );
      }
    }

    connect(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    connect(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    connect(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    connect(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
    connect(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    connect(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    connect(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
    connect(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
    connect(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
    connect(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
    connect(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    connect(PoseLandmarkType.rightHip, PoseLandmarkType.leftHip);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
