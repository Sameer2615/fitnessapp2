import 'dart:ui' as ui;
import 'package:fitnessapp/utils/angels_utils.dart';
import 'package:fitnessapp/utils/label_loader.dart';
import 'package:fitnessapp/screens/activity/pose_camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PoseViewerPage extends StatefulWidget {
  const PoseViewerPage({Key? key}) : super(key: key);

  @override
  State<PoseViewerPage> createState() => _PoseViewerPageState();
}

class _PoseViewerPageState extends State<PoseViewerPage> {
  final ImagePicker _picker = ImagePicker();
  ui.Image? _uiImage;
  Pose? _detectedPose;
  String? _prediction;
  List<String> _labels = [];
  late Interpreter _interpreter;
  bool _isModelLoaded = false; // ✅ new flag

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset("assets/angle_pose_model.tflite");
      _labels = await LabelLoader.loadLabels("assets/label_map.json");
      setState(() {
        _isModelLoaded = true;
      });
      print(
          "✅ Model loaded with input: ${_interpreter.getInputTensor(0).shape}, "
          "output: ${_interpreter.getOutputTensor(0).shape}");
    } catch (e) {
      print("❌ Failed to load model: $e");
    }
  }

  Future<void> _pickAndDetectPose() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final inputImage = InputImage.fromFilePath(pickedFile.path);
    final detector = PoseDetector(options: PoseDetectorOptions());
    final data = await pickedFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frame = await codec.getNextFrame();
    final img = frame.image;

    final poses = await detector.processImage(inputImage);
    await detector.close();

    setState(() {
      _uiImage = img;
      _detectedPose = poses.isNotEmpty ? poses.first : null;
      _prediction = null;
    });
  }

  Future<void> _classifyPose() async {
    if (!_isModelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Model not loaded yet")),
      );
      return;
    }

    if (_detectedPose == null) {
      print("❌ No pose detected");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No pose detected. Try again.")),
      );
      return;
    }

    List<double> angles = extractPoseAngles(_detectedPose!);
    print("🧠 Extracted Angles (${angles.length}): $angles");
    if (angles.isEmpty ||
        angles.length != _interpreter.getInputTensor(0).shape[1]) {
      print(
          "❌ Invalid angles: got ${angles.length}, expected ${_interpreter.getInputTensor(0).shape[1]}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not extract valid pose angles")),
      );
      return;
    }

    try {
      final inputShape = _interpreter.getInputTensor(0).shape;
      final outputShape = _interpreter.getOutputTensor(0).shape;

      final input = angles.reshape([1, inputShape[1]]);
      final output =
          List.filled(outputShape[1], 0.0).reshape([1, outputShape[1]]);

      _interpreter.run(input, output);

      final predictionIndex = output[0].indexOf(
        (output[0] as List<double>)
            .reduce((double a, double b) => a > b ? a : b),
      );

      setState(() {
        _prediction = _labels[predictionIndex];
      });
    } catch (e) {
      print("❌ Classification error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Classification failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pose Viewer")),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: _pickAndDetectPose,
                    child: const Text("Pick Image")),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PoseCameraScreen(),
                      ),
                    );
                  },
                  child: const Text("Live Pose Detection"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_uiImage != null)
              AspectRatio(
                aspectRatio: _uiImage!.width / _uiImage!.height,
                child: CustomPaint(
                  painter: _detectedPose != null
                      ? PosePainter(_uiImage!, _detectedPose!)
                      : null,
                ),
              ),
            const SizedBox(height: 20),
            if (_uiImage != null)
              ElevatedButton(
                onPressed: _isModelLoaded ? _classifyPose : null,
                child:
                    Text(_isModelLoaded ? "Detect Pose" : "Loading model..."),
              ),
            if (_prediction != null)
              Text("Detected Pose: $_prediction",
                  style: const TextStyle(fontSize: 20)),
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
    final paint = Paint();
    final src =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, src, dst, paint);

    final landmarks = pose.landmarks;

    final landmarkPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;

    double scaleX = size.width / image.width;
    double scaleY = size.height / image.height;

    for (final lm in landmarks.values) {
      canvas.drawCircle(
        Offset(lm.x * scaleX, lm.y * scaleY),
        4,
        landmarkPaint,
      );
    }

    void connect(PoseLandmarkType a, PoseLandmarkType b) {
      final p1 = landmarks[a];
      final p2 = landmarks[b];
      if (p1 != null && p2 != null) {
        canvas.drawLine(
          Offset(p1.x * scaleX, p1.y * scaleY),
          Offset(p2.x * scaleX, p2.y * scaleY),
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
    connect(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
