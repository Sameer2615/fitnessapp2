// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// void main() {
//   runApp(GetMaterialApp(home: ReminderScreen()));
// }

// class ReminderController extends GetxController {
//   var reminders = <Reminder>[].obs;

//   void addReminder(String title, String category) {
//     reminders.add(Reminder(title: title, category: category));
//   }

//   void toggleReminder(int index) {
//     reminders[index].isOn = !reminders[index].isOn;
//     reminders.refresh();
//   }

//   void deleteReminder(int index) {
//     reminders.removeAt(index);
//   }
// }

// class Reminder {
//   String title;
//   String category;
//   bool isOn;

//   Reminder({required this.title, required this.category, this.isOn = true});
// }

// class ReminderScreen extends StatelessWidget {
//   final ReminderController controller = Get.put(ReminderController());

//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController categoryController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Reminders')),
//       body: Obx(
//         () => ListView.builder(
//           padding: const EdgeInsets.all(12),
//           itemCount: controller.reminders.length,
//           itemBuilder: (context, index) {
//             final reminder = controller.reminders[index];
//             return Dismissible(
//               key: Key(reminder.title + index.toString()),
//               direction: DismissDirection.endToStart,
//               onDismissed: (_) => controller.deleteReminder(index),
//               background: Container(
//                 alignment: Alignment.centerRight,
//                 padding: EdgeInsets.only(right: 20),
//                 color: Colors.red,
//                 child: Icon(Icons.delete, color: Colors.white),
//               ),
//               child: Container(
//                 margin: const EdgeInsets.symmetric(vertical: 6),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       blurRadius: 6,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.notifications, color: Colors.teal),
//                         SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(reminder.title,
//                                 style: TextStyle(fontWeight: FontWeight.bold)),
//                             Text('Category: ${reminder.category}',
//                                 style: TextStyle(color: Colors.grey)),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Switch(
//                       value: reminder.isOn,
//                       onChanged: (_) => controller.toggleReminder(index),
//                       activeColor: Colors.teal,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.teal,
//         child: Icon(Icons.add),
//         onPressed: () {
//           Get.bottomSheet(
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: titleController,
//                     decoration: InputDecoration(labelText: 'Title'),
//                   ),
//                   TextField(
//                     controller: categoryController,
//                     decoration: InputDecoration(labelText: 'Category'),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//                     onPressed: () {
//                       controller.addReminder(
//                         titleController.text,
//                         categoryController.text,
//                       );
//                       titleController.clear();
//                       categoryController.clear();
//                       Get.back();
//                     },
//                     child: Text('Add Reminder'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
