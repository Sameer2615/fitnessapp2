import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ReminderController extends GetxController {
  var reminders = <Reminder>[].obs;

  void addReminder(String title, String category) {
    reminders.add(Reminder(title: title, category: category));
  }

  void toggleReminder(int index) {
    reminders[index].isOn = !reminders[index].isOn;
    reminders.refresh();
  }
}

class Reminder {
  String title;
  String category;
  bool isOn;

  Reminder({required this.title, required this.category, this.isOn = true});
}
