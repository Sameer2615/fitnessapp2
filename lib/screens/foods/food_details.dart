import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:fitnessapp/screens/foods/controller.dart';
import 'package:fitnessapp/screens/foods/food_list.dart';
import 'package:flutter/material.dart';
// import 'package:fitnessapp/screens/home.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:get/get.dart';

class FoodDetail extends StatelessWidget {
  final Food food;
  final FavoritesController favoritesController = Get.find();
  FoodDetail({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: const Text('Food Details'),
        centerTitle: true,
        actions: [
          Obx(() {
            final isFavorite = favoritesController.favoriteFoods.contains(food);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                if (isFavorite) {
                  favoritesController.removeFromFavorites(food);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Removed from favorites !!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  favoritesController.addToFavorites(food);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Added to favorites !!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            color: Theme.of(context).primaryColorDark,
            width: double.infinity,
            child: Column(
              children: [
                /////////CAROUSEL SECTON//////////
                Container(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    width: 400,
                    height: 260,
                    child: AnotherCarousel(
                      images: [
                        AssetImage(food.image1),
                        AssetImage(food.image2),
                      ],
                      showIndicator: false,
                    )),
                Text(
                  food.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 28,
                ),

                ///circular percentage indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMacroIndicator(
                        label: 'Protein',
                        value: food.proteinvalue,
                        maxValue: 100,
                        color: const Color.fromARGB(255, 99, 142, 49)),
                    _buildMacroIndicator(
                      label: 'Carbs',
                      value: food.carbsvalue,
                      maxValue: 100,
                      color: const Color.fromARGB(255, 64, 18, 129),
                    ),
                    _buildMacroIndicator(
                        label: 'Fats',
                        value: food.fatsvalue,
                        maxValue: 100,
                        color: const Color.fromARGB(255, 170, 58, 153))
                  ],
                ),
                const SizedBox(
                  height: 28,
                ),
                Card(
                  color: Theme.of(context).primaryColorLight,
                  shadowColor: const Color.fromARGB(255, 90, 42, 42),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      food.description,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ////////NUTRITONAL TABLE///////
                const Text(
                  'Nutritional Information',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FractionColumnWidth(0.5),
                      1: FractionColumnWidth(0.5),
                    },
                    children: [
                      buildRow(['Nutrients', 'Contain per 100g'],
                          isHeader: true),
                      buildRow(['Calories', food.calorie]),
                      buildRow(['Protein', food.protein]),
                      buildRow(['Total fat :', food.tfat]),
                      buildRow(['- Saturated', food.sfat]),
                      buildRow(['- Unsaturated', food.ufat]),
                      buildRow(['Carbohydrates', food.carbs]),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
          children: cells.map((cell) {
        final style = TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 16);
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isHeader
                ? const Color.fromARGB(255, 123, 127, 172)
                : Colors.white,
          ),
          child: Center(
              child: Text(
            cell,
            style: style,
          )),
        );
      }).toList());
  Widget _buildMacroIndicator({
    required String label,
    required double value,
    required double maxValue,
    required Color color,
  }) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 10.0,
          percent: value / maxValue,
          center: Text(
            '$value/$maxValue',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.2),
        ),
        const SizedBox(height: 14),
        Text(
          label,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
