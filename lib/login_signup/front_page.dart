// import 'package:fitnessapp/profile/profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/login_signup/login_page.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  int selectedIndex = 0;
  void _handleSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  String finalEmail = '';
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        // If Firebase user is null, redirect to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // If Firebase user exists, check SharedPreferences for saved email
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        var receivedEmail = sharedPreferences.getString('email');
        print("Received email: $receivedEmail");

        if (receivedEmail == null || receivedEmail.isEmpty) {
          // If no email in SharedPreferences, redirect to login page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          setState(() {
            finalEmail = receivedEmail;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
