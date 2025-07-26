import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/core/presentation/main_screen.dart';
// import 'package:fitnessapp/login_signup/front_page.dart';
// import 'package:fitnessapp/front_page.dart';
import 'package:fitnessapp/login_signup/signup_page.dart';
import 'package:fitnessapp/firebase_services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/main.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Theme.of(context).primaryColorLight,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(
        'assets/img/logo1.png',
        width: 900,
        height: 100,
        fit: BoxFit.cover,
      ),
      const SizedBox(height: 50),

      //email textfield
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: TextField(
          controller: _email,
          decoration: InputDecoration(
            hintText: 'Enter email ',
            filled: true,
            // fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(width: 2),
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Password TextField
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextField(
          controller: _password,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                )),
            filled: true,
            // fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(width: 2),
            ),
          ),
        ),
      ),

      const SizedBox(height: 24),
      // Login Button////////////////////////////////
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            final message = await AuthService()
                .login(email: _email.text, password: _password.text);
            if (message!.contains('Success')) {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.setString('email', _email.text);
                navigatorKey.currentState?.pushReplacement(
                    MaterialPageRoute(builder: (_) => const MainScreen()));
              } else {
                scaffoldKey.currentState?.showSnackBar(const SnackBar(
                    content: Text('User not found in Firebase')));
              }
            } else if (message == 'Wrong password provided for that user.') {
              print('wrong password');
            } else {
              Get.snackbar('Sorry', ' login failed',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: const Color.fromARGB(255, 146, 125, 61));
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Colors.black,
          ),
          child: Text('Log In',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
      ),

      const SizedBox(height: 16),
      // Forgot Password////////////////////////////////////////////

      const SizedBox(height: 40),
      // Login with Facebook
    ]));
  }
}
