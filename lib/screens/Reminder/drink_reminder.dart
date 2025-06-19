import 'package:fitnessapp/screens/profile/set_goals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../foods/controller.dart';

class DrinkReminder extends StatefulWidget {
  const DrinkReminder({super.key});

  @override
  State<DrinkReminder> createState() => _DrinkReminderState();
}

class _DrinkReminderState extends State<DrinkReminder> {
  String? selectedvalue;
  final TextEditingController _watercap = TextEditingController();
  final TextEditingController _timevalue = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _quantityhour = TextEditingController();
  final SetgoalsController controller = Get.put(SetgoalsController());

  // Method to show time picker and update the respective controller
  Future<void> _selectTime(BuildContext context, RxString target) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = picked.format(context);
      target.value = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: const Text('Drink Reminder'),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total quantity (in litre)',
                  )),
              const SizedBox(
                height: 8,
              ),
              DropdownMenu(
                controller: _watercap,
                width: double.infinity,
                dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                  DropdownMenuEntry(value: '3.5 L', label: '3.5 L'),
                  DropdownMenuEntry(value: ' 3 L', label: '3 L'),
                  DropdownMenuEntry(value: '2.5 L', label: '2.5 L '),
                ],
                onSelected: (value) {
                  if (value != null) {
                    controller.setWaterCap(value);
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Time interval for intake (in hours)',
                  )),
              const SizedBox(
                height: 8,
              ),
              DropdownMenu(
                controller: _timevalue,
                width: double.infinity,
                dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                  DropdownMenuEntry(value: ' 1hrs', label: '1 '),
                  DropdownMenuEntry(value: '2hrs', label: '2  '),
                  DropdownMenuEntry(value: '3hrs', label: '3 '),
                ],
                onSelected: (value) {
                  if (value != null) {
                    controller.setTimeInterval(value);
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quantity of water per interval',
                  )),
              const SizedBox(
                height: 8,
              ),
              DropdownMenu(
                controller: _quantityhour,
                width: double.infinity,
                dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                  DropdownMenuEntry(value: '300 mL', label: '300 mL'),
                  DropdownMenuEntry(value: '400 mL', label: '400 mL'),
                  DropdownMenuEntry(value: '500 mL', label: '500 mL '),
                ],
                onSelected: (value) {
                  if (value != null) {
                    controller.setQuantity(value);
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Time Duration',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "From" Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('From :'),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          controller: _fromTimeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'Select time',
                            suffixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () => _selectTime(
                              context, SetgoalsController().fromTime),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // "To" Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('To:'),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          controller: _toTimeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'Select time',
                            suffixIcon: Icon(Icons.access_time),
                            border: OutlineInputBorder(),
                          ),
                          onTap: () => _selectTime(
                              context, SetgoalsController().fromTime),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 120, // Set the desired width
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      controller.saveReminder();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reminder saved'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SetGoal()));
                    },
                    child: const Text('Add Reminder'),
                    // Set the desired color
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
