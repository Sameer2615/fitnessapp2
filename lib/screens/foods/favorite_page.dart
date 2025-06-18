import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../foods/controller.dart';
import 'food_details.dart';

class FavoritesPage extends StatelessWidget {
  final FavoritesController favoritesController = Get.find();

  FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: const Text(
          'Your Favorites',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (favoritesController.favoriteFoods.isEmpty) {
          return const Center(child: Text('No favorites added.'));
        }
        return ListView.builder(
          itemCount: favoritesController.favoriteFoods.length,
          itemBuilder: (context, index) {
            final food = favoritesController.favoriteFoods[index];
            return ListTile(
              tileColor: Theme.of(context).primaryColorLight,
              leading: Image.asset(food.image1, width: 50, height: 50),
              title: Text(food.name),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  favoritesController.removeFromFavorites(food);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Removed from favorites !!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              onTap: () => Get.to(() => FoodDetail(food: food)),
            );
          },
        );
      }),
    );
  }
}
