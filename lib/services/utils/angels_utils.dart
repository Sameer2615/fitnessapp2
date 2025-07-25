import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

double _angleBetween(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
  final baX = a.x - b.x;
  final baY = a.y - b.y;
  final bcX = c.x - b.x;
  final bcY = c.y - b.y;

  final dotProduct = baX * bcX + baY * bcY;
  final magA = sqrt(baX * baX + baY * baY);
  final magB = sqrt(bcX * bcX + bcY * bcY);

  final angle = acos(dotProduct / (magA * magB));
  return angle * (180 / pi);
}

List<double> extractPoseAngles(Pose pose) {
  final landmarks = pose.landmarks;
  if (landmarks.length < 15) {
    print(
        "⚠️ Only ${landmarks.length} landmarks detected — expected at least 15.");
    return [];
  }

  List<double> angles = [];

  void tryAddAngle(List<PoseLandmarkType> types, String angleName) {
    final a = landmarks[types[0]];
    final b = landmarks[types[1]];
    final c = landmarks[types[2]];

    if (a != null && b != null && c != null) {
      final angle = _angleBetween(a, b, c);
      angles.add(angle);
      print("$angleName angle: ${angle.toStringAsFixed(2)}°");
    } else {
      angles.add(0.0); // Padding with 0.0 if landmarks are missing
      print("❌ $angleName: Missing landmarks");
    }
  }

  // === Define 7 angles matching your model's expected features ===
  tryAddAngle([
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.leftElbow,
    PoseLandmarkType.leftWrist
  ], "Left Arm");

  tryAddAngle([
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.rightWrist
  ], "Right Arm");

  tryAddAngle([
    PoseLandmarkType.leftElbow,
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.leftHip
  ], "Left Shoulder-Hip");

  tryAddAngle([
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightHip
  ], "Right Shoulder-Hip");

  tryAddAngle([
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.leftHip,
    PoseLandmarkType.leftKnee
  ], "Left Torso-Leg");

  tryAddAngle([
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightHip,
    PoseLandmarkType.rightKnee
  ], "Right Torso-Leg");

  tryAddAngle([
    PoseLandmarkType.leftHip,
    PoseLandmarkType.leftKnee,
    PoseLandmarkType.leftAnkle
  ], "Left Leg");

  // Optional 8th angle:
  // tryAddAngle([
  //   PoseLandmarkType.rightHip,
  //   PoseLandmarkType.rightKnee,
  //   PoseLandmarkType.rightAnkle
  // ], "Right Leg");

  print("🧠 Final angle vector (${angles.length}): $angles");
  return angles;
}
