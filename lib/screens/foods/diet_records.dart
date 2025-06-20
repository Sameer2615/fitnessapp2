import 'package:fitnessapp/screens/foods/controller.dart';
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
  final FocusNode _foodFocusNode = FocusNode();

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
                    'Food Name :',
                  )),
              const SizedBox(
                height: 8,
              ),
              RawAutocomplete<String>(
                textEditingController: _foodname,
                focusNode: _foodFocusNode,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return foodList
                      .map((f) => f.name)
                      .where((name) => name.toLowerCase().startsWith(
                            textEditingValue.text.toLowerCase(),
                          ));
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter food name',
                    ),
                  );
                },
                optionsViewBuilder:
                    (context, Function(String) onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(option),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quantity (in grams) :',
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

                      controller.addFoodItem(foodName, quantity);

                      Navigator.pop(context);
                      Get.snackbar('Item added', 'Food item has been added.',
                          snackPosition: SnackPosition.TOP);
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
