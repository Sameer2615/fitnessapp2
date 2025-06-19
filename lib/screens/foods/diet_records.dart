import 'package:fitnessapp/screens/foods/controller.dart';
import 'package:fitnessapp/screens/foods/diet_list.dart';
import 'package:fitnessapp/screens/foods/food_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DietRoutine extends StatefulWidget {
  const DietRoutine({super.key});

  @override
  State<DietRoutine> createState() => _DietRoutineState();
}

class _DietRoutineState extends State<DietRoutine> {
  String? selectedvalue;
  final TextEditingController _foodname = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _quantityhour = TextEditingController();
  final FavoritesController controller = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: const Text('Diet Routine'),
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
                    'Food Name',
                  )),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: _foodname,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter food name',
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quantity (in grams)',
                  )),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: _quantity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter quantity',
                ),
              ),
              const SizedBox(
                height: 12,
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
                      final String foodName = _foodname.text.trim();
                      final String quantity = _quantity.text.trim();

                      final exists = foodList.any(
                        (food) =>
                            food.name.toLowerCase().trim() ==
                            foodName.toLowerCase().trim(),
                      );

                      if (!exists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Food does not exist in the database!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      controller.addFoodItem(
                          foodName, quantity); // ✅ Actually adds to list

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Food Item Added!'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DietList()),
                      );
                    },
                    child: const Text('Add Food'),
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
