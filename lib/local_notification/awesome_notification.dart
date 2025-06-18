import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fitnessapp/screens/foods/controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AwesomeNotification {
  Future<void> sendNotification() async {
    try {
      print("Attempting to send notification...");
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: 'Water Intake Reminder',
          body: 'Remember to drink 300ml of water!',
        ),
      );
      print("Notification sent successfully");
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  Future<void> sendScheduledNotification() async {
    try {
      print("Attempting to send scheduled notification...");

      DateTime scheduleTime =
          DateTime.now().add(const Duration(seconds: 30)); // Add 1 minute

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(), // Ensure unique ID
          channelKey: 'scheduled_channel',
          title: 'Water Intake Reminder',
          body: 'Remember to drink 300ml of water!',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar(
          year: scheduleTime.year,
          month: scheduleTime.month,
          day: scheduleTime.day,
          hour: scheduleTime.hour,
          minute: scheduleTime.minute,
          second: scheduleTime.second,
          preciseAlarm: true, // Ensures accuracy
          allowWhileIdle: true, // Works in Doze Mode
        ),
      );

      print("Scheduled notification successfully at: $scheduleTime");
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  Future<void> sendRepeatingNotification() async {
    try {
      print("Attempting to schedule repeating notification...");
      final SetgoalsController goalsController = Get.find<SetgoalsController>();
      String waterQuantity = goalsController.quantityInterval.value;
      String waterCapacity = goalsController.selectedWaterCap.value;
      String waterCon = goalsController.selectedWaterCon.value;
      String timeInterval = goalsController.selectedTimeValue.value;

      print(
          "Attempting to schedule repeating notification with $waterQuantity...");
      int wateramount = 0;
      int watercapacity = 0;
      int waterintake = 0;
      //For amount of water to be consumed in each interval
      if (timeInterval.toLowerCase().contains('ml')) {
        wateramount = int.tryParse(timeInterval.split(' ')[0]) ?? 0;
      }
      if (timeInterval.toLowerCase().contains('ml')) {
        watercapacity = int.tryParse(waterCapacity.split(' ')[0]) ?? 0;
      }

      // if (watercapacity >= wateramount) {
      // } else {
      //   waterintake = wateramount - watercapacity;
      //   waterQuantity = '$waterintake ml';
      // }

      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: createUniqueId(), // Unique ID for each schedule
            channelKey: 'scheduled_channel',
            title: 'Water Intake Reminder',
            body: 'Remember to drink $waterQuantity of water!',
            notificationLayout: NotificationLayout.Default,
          ),
          schedule: NotificationCalendar(
            second: 0,
            repeats: true,
            preciseAlarm: true, // More precise scheduling
            allowWhileIdle: true,
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'DRANK',
              label: 'Yes, I did',
              actionType:
                  ActionType.SilentAction, // This makes it a regular button
            ),
            NotificationActionButton(
              key: 'REMIND_LATER',
              label: 'Remind me later',
              actionType: ActionType.SilentAction,
            ),
          ]);

      print("Scheduled repeating notification every 2 hours.");
    } catch (e) {
      print("Error scheduling repeating notification: $e");
    }
  }

  void setupNotificationActionListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        print(
            '🔔 Notification action received: ${receivedAction.buttonKeyPressed}');

        if (receivedAction.buttonKeyPressed == 'DRANK') {
          print('✅ DRANK button pressed');
          _handleDrankAction();
        } else if (receivedAction.buttonKeyPressed == 'REMIND_LATER') {
          print('⏰ REMIND_LATER button pressed');
          _handleRemindLaterAction();
        } else {
          print('❓ Unknown action: ${receivedAction.buttonKeyPressed}');
        }
      },
    );
  }

// 4. Action handlers
  void _handleDrankAction() async {
    try {
      final goalsController = Get.find<SetgoalsController>();
      String quantityStr = goalsController.quantityInterval.value;
      String currentConsumed = goalsController.selectedWaterCon.value;

      int newIntake = int.tryParse(quantityStr.split(' ')[0]) ?? 0;
      int currentIntake = int.tryParse(currentConsumed.split(' ')[0]) ?? 0;

      int updatedIntake = newIntake + currentIntake;
      String updatedValue = '$updatedIntake ml';

      // Update controller
      goalsController.selectedWaterCon.value = updatedValue;

      // ✅ Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('waterCon', updatedValue);

      // Show confirmation
      Get.snackbar('Success', 'Water intake recorded! $updatedValue');
    } catch (e) {
      print('Error handling DRANK action: $e');
    }
  }

  void _handleRemindLaterAction() {
    // Reschedule for 30 minutes later
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'scheduled_channel',
          title: 'Water Reminder',
          body: 'Reminder to drink water!',
        ),
        schedule: NotificationCalendar.fromDate(
          date: DateTime.now().add(Duration(minutes: 30)),
        ));
  }

// Helper function to generate unique IDs
  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static Future<void> cancelAllNotifications() async {
    try {
      print("Cancelling all notifications...");
      await AwesomeNotifications().cancelAll();
      print("All notifications cancelled.");
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future<void> cancelScheduledNotifications() async {
    try {
      print("Cancelling scheduled notifications...");
      await AwesomeNotifications().cancelAllSchedules();
      print("Scheduled notifications cancelled.");
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future<void> cancelNotificationById(int id) async {
    try {
      print("Cancelling notification ID $id...");
      await AwesomeNotifications().cancel(id);
      print("Notification $id cancelled.");
    } catch (e) {
      print("Error: $e");
    }
  }
}

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(5);
}
