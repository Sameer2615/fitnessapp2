///declaration section/
library;

class Food {
  final String name;
  final String image1;
  final String image2;
  final double proteinvalue;
  final double carbsvalue;
  final double fatsvalue;
  final String description;
  final String calorie;
  final String protein;
  final String carbs;
  final String tfat;
  final String sfat;
  final String ufat;

  /// constructor declaration
  const Food({
    //parameters
    required this.name,
    required this.image1,
    required this.image2,
    required this.proteinvalue,
    required this.carbsvalue,
    required this.fatsvalue,
    required this.description,
    required this.calorie,
    required this.protein,
    required this.carbs,
    required this.tfat,
    required this.sfat,
    required this.ufat,
  });
}

////////secton 3//////
//yo list ma cha Food class ko object banauna milxa
List<Food> foodList = [
  //objects of food class
  const Food(
    name: 'Chickpeas',
    image1: 'assets/img/chickpeas.jpg',
    image2: 'assets/img/chckps.jpg',
    proteinvalue: 8.6, //+
    carbsvalue: 27, //+
    fatsvalue: 2.6, //+
    description:
        'Garbanzo beans, another name for chickpeas, have been cultivated and consumed for thousands of years in Middle Eastern nations.Rich in vitamins, minerals, and fiber, chickpeas may help you control your weight, improve your digestion, and lower your risk of illness, among other health advantages.',
    calorie: '164 Kcal',
    protein: '8.6g',
    carbs: '27g',
    tfat: '2.6g',
    sfat: '0.27g',
    ufat: '1.58g',
  ),
  const Food(
    name: 'Milk',
    image1: 'assets/img/milk1.jpg',
    image2: 'assets/img/milk2.jpg',
    proteinvalue: 3.4,
    carbsvalue: 4.6,
    fatsvalue: 3.6,
    description:
        'Garbanzo milk, another name for chickpeas, have been cultivated and consumed for thousands of years in Middle Eastern nations.Rich in vitamins, minerals, and fiber, chickpeas may help you control your weight, improve your digestion, and lower your risk of illness, among other health advantages.',
    calorie: '64 Kcal',
    protein: '3.4g',
    carbs: '4.6g',
    tfat: '3.6g',
    sfat: '1.87g',
    ufat: '1.1g',
  ),
  const Food(
    name: 'Almond',
    image1: 'assets/img/almond1.jpg',
    image2: 'assets/img/almond2.jpg',
    proteinvalue: 21.2,
    carbsvalue: 21.6,
    fatsvalue: 49.9,
    description:
        'Garbanzo milk, another name for chickpeas, have been cultivated and consumed for thousands of years in Middle Eastern nations.Rich in vitamins, minerals, and fiber, chickpeas may help you control your weight, improve your digestion, and lower your risk of illness, among other health advantages.',
    calorie: '579 Kcal',
    protein: '21.2g',
    carbs: '21.6g',
    tfat: '49.9g',
    sfat: '3.8g',
    ufat: '43.1g',
  ),
  const Food(
    name: 'Chicken Breast',
    image1: 'assets/img/chicken1.jpeg',
    image2: 'assets/img/chicken2.jpg',
    proteinvalue: 31.0,
    carbsvalue: 0.0,
    fatsvalue: 3.6,
    description:
        'Lean protein source rich in niacin, vitamin B6, and selenium. Helps build muscle, supports immune function, and promotes heart health. Best consumed grilled or baked.',
    calorie: '165 Kcal',
    protein: '31.0g',
    carbs: '0.0g',
    tfat: '3.6g',
    sfat: '1.0g',
    ufat: '2.6g',
  ),
  const Food(
    name: 'Avocado',
    image1: 'assets/img/avocado1.jpg',
    image2: 'assets/img/avocado2.jpg',
    proteinvalue: 2.0,
    carbsvalue: 8.5,
    fatsvalue: 14.7,
    description:
        'Creamy fruit packed with heart-healthy monounsaturated fats. Rich in potassium, fiber, and vitamins C/E/K. Supports skin health and nutrient absorption.',
    calorie: '160 Kcal',
    protein: '2.0g',
    carbs: '8.5g',
    tfat: '14.7g',
    sfat: '2.1g',
    ufat: '12.6g',
  ),
  const Food(
    name: 'Sweet Potato',
    image1: 'assets/img/sweetpotato1.jpg',
    image2: 'assets/img/sweetpotato2.jpg',
    proteinvalue: 2.0,
    carbsvalue: 20.7,
    fatsvalue: 0.2,
    description:
        'Nutrient-dense root vegetable high in beta-carotene, vitamin A, and fiber. Supports eye health, immune function, and provides sustained energy.',
    calorie: '90 Kcal',
    protein: '2.0g',
    carbs: '20.7g',
    tfat: '0.2g',
    sfat: '0.1g',
    ufat: '0.1g',
  ),
  const Food(
    name: 'Egg',
    image1: 'assets/img/egg1.jpeg',
    image2: 'assets/img/egg2.jpg',
    proteinvalue: 12.6,
    carbsvalue: 1.1,
    fatsvalue: 9.5,
    description:
        'Complete protein source containing all essential amino acids. Rich in choline for brain health and lutein for eye protection. Versatile cooking ingredient.',
    calorie: '143 Kcal',
    protein: '12.6g',
    carbs: '1.1g',
    tfat: '9.5g',
    sfat: '3.1g',
    ufat: '6.4g',
  ),
  const Food(
    name: 'Oatmeal',
    image1: 'assets/img/oatmeal1.jpeg',
    image2: 'assets/img/oatmeal2.jpg',
    proteinvalue: 2.4,
    carbsvalue: 12.0,
    fatsvalue: 1.4,
    description:
        'Whole grain packed with soluble fiber (beta-glucan) that helps lower cholesterol. Provides sustained energy and supports gut health.',
    calorie: '68 Kcal',
    protein: '2.4g',
    carbs: '12.0g',
    tfat: '1.4g',
    sfat: '0.2g',
    ufat: '1.2g',
  ),
  const Food(
    name: 'Broccoli',
    image1: 'assets/img/broccoli1.png',
    image2: 'assets/img/broccoli2.jpg',
    proteinvalue: 2.8,
    carbsvalue: 6.6,
    fatsvalue: 0.4,
    description:
        'Cruciferous vegetable loaded with vitamins C/K, folate, and sulforaphane. Has potent anti-cancer properties and supports detoxification.',
    calorie: '34 Kcal',
    protein: '2.8g',
    carbs: '6.6g',
    tfat: '0.4g',
    sfat: '0.1g',
    ufat: '0.3g',
  ),
  const Food(
    name: 'Peanut Butter',
    image1: 'assets/img/pb1.webp',
    image2: 'assets/img/pb2.jpg',
    proteinvalue: 25.0,
    carbsvalue: 20.0,
    fatsvalue: 50.0,
    description:
        'Plant-based protein source rich in healthy fats. Contains resveratrol and CoQ10. Choose natural varieties without added sugars or hydrogenated oils.',
    calorie: '588 Kcal',
    protein: '25.0g',
    carbs: '20.0g',
    tfat: '50.0g',
    sfat: '10.0g',
    ufat: '40.0g',
  ),
  const Food(
    name: 'Blueberries',
    image1: 'assets/img/blueberry1.webp',
    image2: 'assets/img/blueberry2.jpeg',
    proteinvalue: 0.7,
    carbsvalue: 14.5,
    fatsvalue: 0.3,
    description:
        'Antioxidant powerhouse with anthocyanins that support brain health and reduce oxidative stress. Low glycemic index despite natural sweetness.',
    calorie: '57 Kcal',
    protein: '0.7g',
    carbs: '14.5g',
    tfat: '0.3g',
    sfat: '0.0g',
    ufat: '0.3g',
  ),
  const Food(
    name: 'Brown Rice',
    image1: 'assets/img/rice1.jpg',
    image2: 'assets/img/rice2.jpg',
    proteinvalue: 2.6,
    carbsvalue: 23.0,
    fatsvalue: 0.9,
    description:
        'Whole grain containing the bran and germ. Provides manganese, selenium, and fiber. Slower digesting than white rice for better blood sugar control.',
    calorie: '111 Kcal',
    protein: '2.6g',
    carbs: '23.0g',
    tfat: '0.9g',
    sfat: '0.2g',
    ufat: '0.7g',
  ),
  const Food(
    name: 'Spinach',
    image1: 'assets/img/spinach1.avif',
    image2: 'assets/img/spinach2.jpg',
    proteinvalue: 2.9,
    carbsvalue: 3.6,
    fatsvalue: 0.4,
    description:
        'Leafy green loaded with iron, vitamin K, and nitrates. Supports blood health, bone strength, and may improve athletic performance.',
    calorie: '23 Kcal',
    protein: '2.9g',
    carbs: '3.6g',
    tfat: '0.4g',
    sfat: '0.1g',
    ufat: '0.3g',
  ),
  const Food(
    name: 'Walnuts',
    image1: 'assets/img/walnut1.webp',
    image2: 'assets/img/walnut2.jpg',
    proteinvalue: 15.2,
    carbsvalue: 13.7,
    fatsvalue: 65.2,
    description:
        'Tree nuts with the highest omega-3 ALA content. Supports brain health and reduces inflammation. Contains melatonin for better sleep regulation.',
    calorie: '654 Kcal',
    protein: '15.2g',
    carbs: '13.7g',
    tfat: '65.2g',
    sfat: '6.1g',
    ufat: '59.1g',
  ),
  const Food(
    name: 'Chia Seeds',
    image1: 'assets/img/chia1.jpg',
    image2: 'assets/img/chia2.webp',
    proteinvalue: 16.5,
    carbsvalue: 42.1,
    fatsvalue: 30.7,
    description:
        'Tiny seeds packed with omega-3s, fiber, and calcium. Form gel-like consistency when soaked. Supports hydration and digestive health.',
    calorie: '486 Kcal',
    protein: '16.5g',
    carbs: '42.1g',
    tfat: '30.7g',
    sfat: '3.3g',
    ufat: '27.4g',
  ),
  const Food(
    name: 'Green Tea',
    image1: 'assets/img/tea1.jpg',
    image2: 'assets/img/tea2.webp',
    proteinvalue: 0.0,
    carbsvalue: 0.0,
    fatsvalue: 0.0,
    description:
        'Contains catechins like EGCG with powerful antioxidant effects. May boost metabolism and support brain function. Brew fresh for maximum benefits.',
    calorie: '0 Kcal',
    protein: '0.0g',
    carbs: '0.0g',
    tfat: '0.0g',
    sfat: '0.0g',
    ufat: '0.0g',
  ),
  const Food(
    name: 'Lentils',
    image1: 'assets/img/lentil1.jpg',
    image2: 'assets/img/lentil2.jpeg',
    proteinvalue: 9.0,
    carbsvalue: 20.0,
    fatsvalue: 0.4,
    description:
        'Plant-based protein and iron source. High in fiber and folate. Supports heart health and helps regulate blood sugar levels.',
    calorie: '116 Kcal',
    protein: '9.0g',
    carbs: '20.0g',
    tfat: '0.4g',
    sfat: '0.1g',
    ufat: '0.3g',
  ),
  const Food(
    name: 'Dragon Fruit',
    image1: 'assets/img/dragonfruit1.avif',
    image2: 'assets/img/dragonfruit2.jpg',
    proteinvalue: 1.2,
    carbsvalue: 13.0,
    fatsvalue: 0.4,
    description:
        'Tropical fruit with prebiotic fiber and betalain antioxidants. Supports gut microbiome diversity. Mildly sweet with striking appearance.',
    calorie: '60 Kcal',
    protein: '1.2g',
    carbs: '13.0g',
    tfat: '0.4g',
    sfat: '0.0g',
    ufat: '0.4g',
  ),
];
