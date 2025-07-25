import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/firebase_services/firebase_auth.dart';
import 'package:fitnessapp/login_signup/home.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPersonalinfo extends StatefulWidget {
  const EditPersonalinfo({super.key});

  @override
  State<EditPersonalinfo> createState() => _EditPersonalinfoState();
}

class _EditPersonalinfoState extends State<EditPersonalinfo> {
  User? user;
  late String userId;
  DocumentReference<Map<String, dynamic>>? userDoc;
  final TextEditingController _editphone = TextEditingController();
  final TextEditingController _editage = TextEditingController();
  final TextEditingController _editheight = TextEditingController();
  final TextEditingController _editweight = TextEditingController();
  final AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
    //authenticated user linxa
    user = FirebaseAuth.instance.currentUser;
    //now take user uid and  document of authenticated user
    if (user != null) {
      userDoc =
          FirebaseFirestore.instance.collection('user_info').doc(user!.uid);
      print(userDoc);
    } else {
      print('user is not logged in');
    }

    // userId = userDoc!.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        // Last Name
        const Text("Legal last name"),
        const SizedBox(height: 5),
        const Text("Phone Number"),
        const SizedBox(height: 5),
        _buildfield(_editphone, Icons.lock_outline, 'Enter ', false),
        const SizedBox(height: 15),
        // age
        const Text("Your Age"),
        const SizedBox(height: 5),
        _buildfield(_editage, Icons.lock_outline, 'Enter age', false),
        const SizedBox(height: 15),
        //height
        const Text("Your Height"),
        const SizedBox(height: 5),
        _buildfield(_editheight, Icons.lock_outline, 'Enter height', false),
        const SizedBox(height: 15),
        //weight
        const Text("Your weight"),
        const SizedBox(height: 5),
        _buildfield(_editweight, Icons.lock_outline, 'Enter weight', false),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity, // Full-width button
            child: ElevatedButton(
              onPressed: () async {
                _auth.updateUserData(
                    phone: _editphone.text,
                    age: _editage.text,
                    height: _editheight.text,
                    weight: _editweight.text,
                    userDoc: userDoc);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text('Confirm ',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(color: Colors.white)),
            ),
          ),
        ),
      ]),
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
