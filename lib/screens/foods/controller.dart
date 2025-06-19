import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'food_list.dart'; // Import your Food class and foodList

class FavoritesController extends GetxController {
  // Observable list of favorite items
  var favoriteFoods = <Food>[].obs;
  var mealList = <Map<String, String>>[].obs;

  final RxString selectedFoodName = ''.obs;
  final RxString selectedQuantity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    loadMealListFromPrefs();
  }

  void addToFavorites(Food food) async {
    if (!favoriteFoods.contains(food)) {
      favoriteFoods.add(food);
      await saveFavorites();
    }
  }

  void addFoodItem(String name, String quantity) {
    mealList.add({'name': name, 'quantity': quantity});
    saveMealListToPrefs();
  }

  void saveReminder() async {
    final String name = selectedFoodName.value;
    final String quantity = selectedQuantity.value;

    final exists =
        foodList.any((food) => food.name.toLowerCase() == name.toLowerCase());

    if (!exists) {
      Get.snackbar('Food Not Found', 'Food "$name" does not exist in database');
      return;
    }

    final alreadyExists = mealList
        .any((item) => item['name']?.toLowerCase() == name.toLowerCase());
    if (alreadyExists) {
      Get.snackbar('Duplicate Food', 'Food "$name" is already in your list');
      return;
    }

    addFoodItem(name, quantity);
    Get.snackbar('Added!', 'Food "$name" added successfully');
  }

  Future<void> saveMealListToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> mealJsonList =
        mealList.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('mealList', mealJsonList);
  }

  Future<void> loadMealListFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> mealJsonList = prefs.getStringList('mealList') ?? [];

    mealList.value = mealJsonList
        .map((jsonString) => Map<String, String>.from(jsonDecode(jsonString)))
        .toList();
  }

  // Optional: clear all meals
  Future<void> clearMealList() async {
    mealList.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mealList');
  }

  void removeFromFavorites(Food food) async {
    favoriteFoods.remove(food);
    await saveFavorites();
  }

  // Save favorites to SharedPreferences
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Save the names of favorite foods
    final favoriteNames = favoriteFoods.map((food) => food.name).toList();
    prefs.setStringList('favoriteFoods', favoriteNames);
  }

  // Load favorites from SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Get saved food names
    final favoriteNames = prefs.getStringList('favoriteFoods') ?? [];
    // Match saved names with the `foodList`
    favoriteFoods.value =
        foodList.where((food) => favoriteNames.contains(food.name)).toList();
  }
}

class SetgoalsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadReminder();
    loadWaterCon();
// Load favorites when the app starts
  }

  var selectedWaterCap = ''.obs;
  var selectedTimeValue = ''.obs;
  var fromTime = ''.obs;
  var toTime = ''.obs;
  var quantityInterval = ''.obs;
  var selectedWaterCon = '0 ml'.obs;

  void setWaterCap(String value) async {
    selectedWaterCap.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('waterCap', value);
  }

  void setTimeInterval(String value) async {
    selectedTimeValue.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('timeInterval', value);
  }

  void setFromTime(String time) async {
    fromTime.value = time;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fromTime', time);
  }

  void setToTime(String time) async {
    toTime.value = time;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('toTime', time);
  }

  void setQuantity(String value) async {
    quantityInterval.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('quantityInterval', value);
  }

  void setWatercon(String value) async {
    selectedWaterCon.value = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('waterCon', value);
  }

  void saveReminder() {
    // You could save this to a database or shared preferences instead
    print('Water Cap: ${selectedWaterCap.value}');
    print('Interval: ${selectedTimeValue.value}');
    print('From: ${fromTime.value}');
    print('To: ${toTime.value}');
  }

  void loadReminder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedWaterCap.value = prefs.getString('waterCap') ?? '';
    selectedTimeValue.value = prefs.getString('timeInterval') ?? '';
    fromTime.value = prefs.getString('fromTime') ?? '';
    toTime.value = prefs.getString('toTime') ?? '';
    quantityInterval.value = prefs.getString('quantityInterval') ?? '';
  }

  void loadWaterCon() async {
    final prefs = await SharedPreferences.getInstance();
    selectedWaterCon.value = prefs.getString('waterCon') ?? '0 ml';
  }
}
