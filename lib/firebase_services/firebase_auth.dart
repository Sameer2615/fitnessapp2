import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String? uid;
String? emaill;

class AuthService {
/////////////////LOGOUT USER//////////
  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('Sucessfully logged out');
    } catch (e) {
      print('An error occurred while logging out: $e');
    }
  }

  /////////////////REGISTRATION////////////////
  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emaill = email;

      // Get the user ID from Firebase Authentication and use same for frestore uid
      uid = userCredential.user!.uid;

      // Create a user document in Firestore with the same uid

      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return 'An error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  Future<String?> userInform({
    required String firstName,
    required String lastName,
    required String age,
    required String height,
    required String weight,
    required String gender,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('user_info').doc(uid).set({
        'name': firstName,
        'last_name': lastName,
        'age': age,
        'height': height,
        'weight': weight,
        'email': emaill,
        'gender': gender,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
    return null;
  }

  ///////////LOGIN///////////////

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      print('error coder: ${e.code}');
      //handles firebase authentication exceptioms
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return 'please try again!';
      }
    } catch (e) {
      //handles unexpected errors such as network issues
      return e.toString();
    }
  }

  ///////////ACCOUNT DELETE from authentication//////////
  Future<void> deleteUserAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.delete();
        print("User account deleted successfully.");
      } catch (e) {
        print("Failed to delete user: $e");
      }
    } else {
      print("No user is currently logged in.");
    }
  }

  ///delete document from firestore

  Future<void> deleteUserData(userDoc) async {
    if (userDoc != null) {
      try {
        await userDoc.delete();
        print('Document deleted successfully of userdata: ${userDoc.uid}');
      } catch (e) {
        print('Shrijana Error deleting document: $e');
      }
    } else {
      print('user not found in firestore');
    }
  }

  ///fetching data
  Future<Map<String, dynamic>?> fetchUserData(userDoc) async {
    if (userDoc != null) {
      try {
        //take snapshot of data
        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            await userDoc!.get();
        //snaShot checks whether it has data
        if (docSnapshot.exists) {
          return docSnapshot.data();
        } else {
          print('Document does not exist');
        }
      } catch (e) {
        print('manage Error fetching document: $e');
      }
    }
    return null;
  }

  ///updating data to firestore
  Future<void> updateUserData({
    required String phone,
    required String age,
    required String height,
    required String weight,
    userDoc,
  }) async {
    try {
      await userDoc.update({
        'phone': phone,
        'age': age,
        'height': height,
        'weight': weight,
        'updated_at': FieldValue.serverTimestamp(),
      });
      print('document edited sucessfully');
    } catch (e) {
      print('Shrijana Error updating document: $e');
    }
  }
}
