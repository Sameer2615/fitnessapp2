import 'package:fitnessapp/screens/foods/favorite_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'food_details.dart';
import '../foods/controller.dart';

import 'food_list.dart';

class BreakFast extends StatefulWidget {
  const BreakFast({super.key});

  @override
  State<BreakFast> createState() => _BreakFastState();
}

class _BreakFastState extends State<BreakFast> {
  int _selectedindex = 0;
  List<Food> searchResults = foodList;

  // List<Food> foods = foodList;
  final FavoritesController favoritesController =
      Get.put(FavoritesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate Calories'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //////////SEARCH///////////////
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 60,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                        ),
                        onChanged: searchedItem,
                      ),
                    ),
                    const Icon(Icons.filter_list, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          //////////////////RECENT AND FAVORITES///////////
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: _selectedindex == 0
                                  ? Colors.grey
                                  : Theme.of(context).primaryColorLight),
                          onPressed: () {
                            setState(() {
                              _selectedindex = 0;
                            });
                          },
                          child: const Text(
                            'Recent',
                            style: TextStyle(color: Colors.black),
                          ))),
                ),
                Expanded(
                  child: Center(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedindex = 1;
                          });
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: _selectedindex == 1
                                ? Colors.grey
                                : Theme.of(context).primaryColorLight),
                        child: const Text('Favorites',
                            style: TextStyle(
                              color: Colors.black,
                            ))),
                  ),
                ),
              ],
            ),
          ),
          /////////////RECENT FOOD ITEMS////////////
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final food = searchResults[index];
                return Obx(() {
                  // Check if the food item is a favorite
                  final isFavorite =
                      favoritesController.favoriteFoods.contains(food);

                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 119, 170, 144),
                          border: Border.all(
                            color: const Color.fromARGB(255, 66, 31, 31),
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(10), // Add this line
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(30), // Add this line
                              ),
                              child: Image.asset(
                                food.image1,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            title: Text(food.name),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              onPressed: () {
                                // Toggle the favorite status
                                if (isFavorite) {
                                  favoritesController.removeFromFavorites(food);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Removed from favorites !!"),
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
                            ),
                            onTap: () => Get.to(() => FoodDetail(food: food)),
                          ),
                        ),
                      ));
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.favorite),
          onPressed: () {
            Get.to(FavoritesPage());
          }),
    );
  }

  //food search///////////
  void searchedItem(String query) {
    final suggestions = foodList.where((food) {
      // Ensure the query is not empty
      if (query.isEmpty) return true;

      final foodName = food.name.toLowerCase();
      final input = query.toLowerCase();

      return foodName.isNotEmpty && foodName[0] == input[0];
    }).toList();

    setState(() {
      searchResults = suggestions; // Update the search results list
    });
  }
}
