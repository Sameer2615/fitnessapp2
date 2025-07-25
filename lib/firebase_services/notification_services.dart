// import 'dart:io';
// import 

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServices {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   //requesting user for notifications allowing
//   Future<void> requestNotificationPermissons() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true, //request permission  to show alerts
//       badge: true,
//       sound: true, //request to play sound
//       announcement: true,
//       carPlay: true,
//       provisional: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('user permission is granted');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('user granted provisional permission');
//     } else {
//       print('Sorry! user denied permission');
//     }
//   }

// //get the device token number
//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void firebaseInit() {
//     FirebaseMessaging.onMessage.listen((message) {
//       print(message.notification!.title.toString());
//       print(message.notification!.body.toString());
//     });
//   }
// }
// /////////
// ///  Widget ReusbaleRow({required String title, required String value}) {
   