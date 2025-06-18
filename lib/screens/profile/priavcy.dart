import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
          title: const Text("Privacy Policy"),
          backgroundColor: Theme.of(context)
              .primaryColorDark // Customize to match your theme
          ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Your Privacy Matters",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "1. Information We Collect",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "• Name and email (optional)\n• Workout and activity data\n• Preferences you provide",
              ),
              SizedBox(height: 16),
              Text(
                "2. How We Use Your Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "We use your data to personalize workouts, track progress, and improve features. No spam. No selling.",
              ),
              SizedBox(height: 16),
              Text(
                "3. Data Security",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "We securely store your data and do not share it with third parties without consent.",
              ),
              SizedBox(height: 16),
              Text(
                "4. Your Rights",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "You can update or delete your data anytime. Just reach out to us.",
              ),
              SizedBox(height: 16),
              Text(
                "5. Contact Us",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "If you have questions, contact us at:\nhello@yourfitnessapp.com",
              ),
              SizedBox(height: 24),
              Text(
                "Last Updated: June 18, 2025",
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
