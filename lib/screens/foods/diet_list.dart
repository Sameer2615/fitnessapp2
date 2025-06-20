import 'package:fitnessapp/screens/foods/controller.dart';
import 'package:fitnessapp/screens/foods/diet_records.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitnessapp/screens/foods/food_list.dart';

class DietList extends StatefulWidget {
  const DietList({super.key});

  @override
  State<DietList> createState() => _DietListState();
}

class _DietListState extends State<DietList> {
  final FavoritesController controller = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Your Diet List')),
        body: Obx(() {
          if (controller.mealList.isEmpty) {
            return const Center(child: Text('No food items added yet.'));
          }

          return ListView.builder(
            itemCount: controller.mealList.length,
            itemBuilder: (context, index) {
              final item = controller.mealList[index];
              final String foodName = item['name']?.trim() ?? '';

              // Find match in predefined foodList
              final matchedFood = foodList.any(
                (food) => food.name.toLowerCase() == foodName.toLowerCase(),
              )
                  ? foodList.firstWhere(
                      (food) =>
                          food.name.toLowerCase() == foodName.toLowerCase(),
                    )
                  : null;

              final String proteinText = matchedFood != null
                  ? 'Protein : ${matchedFood.proteinvalue} gm '
                  : 'Food "$foodName" does not exist';
              final String carbsText = matchedFood != null
                  ? 'Carbs : ${matchedFood.carbsvalue} gm '
                  : 'Food "$foodName" does not exist';
              final String calorieText = matchedFood != null
                  ? 'Calorie : ${matchedFood.calorie} '
                  : 'Food "$foodName" does not exist';

              return GestureDetector(
                onTap: () => _showDeleteDialog(context, controller, index),
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Food: $foodName'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${item['quantity']} gm'),
                        Text(
                          proteinText,
                          style: TextStyle(
                            color:
                                matchedFood != null ? Colors.black : Colors.red,
                          ),
                        ),
                        Text(
                          carbsText,
                          style: TextStyle(
                            color:
                                matchedFood != null ? Colors.black : Colors.red,
                          ),
                        ),
                        Text(
                          calorieText,
                          style: TextStyle(
                            color:
                                matchedFood != null ? Colors.black : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: SizedBox(
          height: 60,
          width: 100,
          child: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColorLight,
              child: const Text('ADD MEAL'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DietRoutine()),
                );
              }),
        ));
  }
}

void _showDeleteDialog(
    BuildContext context, FavoritesController controller, int index) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remove Item'),
      content: const Text('Are you sure you want to remove this food item?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            controller.mealList.removeAt(index);
            Navigator.pop(context);
            Get.snackbar('Removed', 'Food item has been removed.',
                snackPosition: SnackPosition.BOTTOM);
          },
          child: const Text('Remove'),
        ),
      ],
    ),
  );
}
