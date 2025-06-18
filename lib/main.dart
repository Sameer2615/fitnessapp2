import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/local_notification/awesome_notification.dart';
import 'package:fitnessapp/screens/front_page.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:fitnessapp/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  tz.initializeTimeZones();
  //connecting project with firebase
  WidgetsFlutterBinding.ensureInitialized();
  // await LocalNotification.init();
  // Get.lazyPut(() => FavoritesController());
  await Firebase.initializeApp();
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('HELLO');
  // print(fcmToken);
  await AwesomeNotifications().initialize(
    null, // icon for your app notification
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.teal,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled notifications',
        channelDescription: 'Notification channel for schedule tests',
        defaultColor: Colors.teal,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      ),
    ],
    debug: true,
  );

  // Check if user has granted notification permission globally
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  // Listen to notification taps/actions globally
  // AwesomeNotifications().actionStream.listen((receivedNotification) {
  //   print('Notification tapped: ${receivedNotification.payload}');
  //   // Navigate or perform actions based on notification
  // });
  // setupNotificationListeners();
  AwesomeNotification notification = AwesomeNotification();
  notification.setupNotificationActionListeners();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldKey,
        title: 'Flutter Demo',
        home: const FrontPage(),
        theme: ThemeData(
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
            titleLarge: TextStyle(
                color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
            titleSmall: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              // letterSpacing: 1.0,
              color: Color.fromARGB(255, 32, 30, 30),
            ),
            displaySmall: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              // letterSpacing: 1.0,
              color: Color.fromARGB(255, 32, 30, 30),
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, primary: Colors.black),
          // primary: const Color.fromARGB(255, 252, 227, 138)),
          primaryColorDark:
              const Color.fromARGB(255, 184, 216, 201), //soft green color,
          primaryColorLight: const Color.fromARGB(255, 237, 234, 215),

          useMaterial3: true,
        ));
  }
}
