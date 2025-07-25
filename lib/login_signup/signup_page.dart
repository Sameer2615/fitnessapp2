import 'package:fitnessapp/login_signup/login_page.dart';

import 'package:flutter/material.dart';
import 'package:fitnessapp/firebase_services/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:instagram_clone/data/firebase_service/firebase_auth.dart';
// import 'package:instagram_clone/screens/login_page.dart';
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthService _auth = AuthService();
  final _email = TextEditingController();
  final _usernamecontroller = TextEditingController();

  final _password = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  late final String inner;
  late final bool say;
  late String displayMessage;
  Future<void> _clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    _clearSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 120,
            ),

            Image.asset('assets/img/logo1.png',
                width: 1000, height: 100, fit: BoxFit.cover),
            const SizedBox(
              height: 10,
            ),
            //for circle avatar

            const SizedBox(
              height: 40,
            ),
            _buildfield(_email, Icons.email, 'Email', false),
            const SizedBox(
              height: 10,
            ),
            _buildfield(_usernamecontroller, Icons.man, 'Username', false),
            const SizedBox(
              height: 10,
            ),

            _buildfield(_password, Icons.lock, 'Password', true),
            const SizedBox(
              height: 10,
            ),
            _buildfield(_confirmpasswordcontroller, Icons.lock_outline,
                'Confirm Password', true),
            const SizedBox(
              height: 10,
            ),
            //######################SIGN UP BUTTON
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity, // Full-width button
                child: ElevatedButton(
                  onPressed: () async {
                    final message = await AuthService().registration(
                      email: _email.text,
                      password: _password.text,
                    );
                    if (message!.contains('Success')) {
                      displayMessage = 'sucessful';
                    } else {
                      if (message.contains('Password is too weak')) {
                        displayMessage = 'Password is too weak';
                      } else if (message.contains(
                          'The account already exists for this email')) {
                        displayMessage = 'Account already exists';
                      } else {
                        displayMessage = message;
                      }
                    }
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(displayMessage)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  child: Text('Sign me Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildfield(
      TextEditingController controller, IconData icon, String inner, bool say) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        obscureText: say,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey[600],
          ),
          hintText: inner,
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
