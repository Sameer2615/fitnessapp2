// import 'package:fitnessapp/profile/profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fitnessapp/screens/activity/activity_tracker.dart';
import 'package:fitnessapp/screens/profile/profile_view.dart';

import 'package:fitnessapp/screens/foods/breakfast_page.dart';
import 'package:fitnessapp/screens/login_signup/login_page.dart';
import 'package:fitnessapp/screens/profile/set_goals.dart';

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
  List<Widget> _buildScreens() {
    return [
      const ActivityTracker(),
      SetGoal(),
      const BreakFast(),
      const ProfileView(),
      // EditPersonalinfo(),
      // Profile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: "Home",
          inactiveColorPrimary: Colors.grey.shade600,
          activeColorPrimary: Colors.purple),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.menu_book_sharp),
          title: "Activity",
          inactiveColorPrimary: Colors.grey.shade600,
          activeColorPrimary: Colors.purple),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.food_bank),
          inactiveColorPrimary: Colors.grey,
          title: "Meal",
          activeColorPrimary: Colors.purple),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.more_horiz),
          title: "Profile",
          inactiveColorPrimary: Colors.grey.shade600,
          activeColorPrimary: Colors.purple),
    ];
  }

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
    return PersistentTabView(
      backgroundColor: const Color.fromARGB(255, 184, 216, 201), context,
      screens: _buildScreens(),
      controller: _controller,
      items: _navBarItems(),
      confineToSafeArea: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(borderRadius: BorderRadius.circular(0.5)),
      navBarStyle: NavBarStyle.simple,

      // stores the current index of navbaritems
      onItemSelected: (int selectedIndex) {
        _handleSelectedIndex(selectedIndex);
      },
    );
  }
}
