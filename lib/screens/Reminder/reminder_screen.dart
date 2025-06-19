import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fitnessapp/screens/Reminder/reminder_controller_screen.dart';

class ReminderScreen extends StatelessWidget {
  final ReminderController controller = Get.put(ReminderController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: const Text('Reminders'),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.reminders.length,
          itemBuilder: (context, index) {
            final reminder = controller.reminders[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications, color: Colors.teal),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reminder.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Category: ${reminder.category}',
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: reminder.isOn,
                    onChanged: (_) => controller.toggleReminder(index),
                    activeColor: Colors.teal,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColorDark,
        child: const Icon(Icons.add),
        onPressed: () {
          Get.bottomSheet(
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    onPressed: () {
                      controller.addReminder(
                        titleController.text,
                        categoryController.text,
                      );
                      titleController.clear();
                      categoryController.clear();
                      Get.back();
                    },
                    child: const Text('Add Reminder'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
