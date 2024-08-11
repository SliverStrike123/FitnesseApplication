import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final int calories;
  final double protein;

  FoodItem({required this.name, required this.calories, required this.protein});
}

final List<FoodItem> availableFoods = [
  FoodItem(name: "Chicken Breast (100g)", calories: 165, protein: 31),
  FoodItem(name: "Turkey Breast (100g)", calories: 135, protein: 30),
  FoodItem(name: "Salmon (100g)", calories: 206, protein: 22),
  FoodItem(name: "Beef (100g)", calories: 250, protein: 26),
  FoodItem(name: "Tuna (100g)", calories: 132, protein: 29),
  FoodItem(name: "Chicken Breast (100g)", calories: 165, protein: 31),
  FoodItem(name: "Broccoli (100g)", calories: 34, protein: 2.8),
  FoodItem(name: "Spinach (100g)", calories: 23, protein: 2.9),
  FoodItem(name: "Peas (100g)", calories: 81, protein: 5.4),
  FoodItem(name: "Asparagus (100g)", calories: 20, protein: 2.2),
  FoodItem(name: "Brussels Sprouts (100g)", calories: 43, protein: 3.4),
  FoodItem(name: "Banana (100g)", calories: 89, protein: 1.1),
  FoodItem(name: "Apple (100g)", calories: 52, protein: 0.3),
  FoodItem(name: "Strawberries (100g)", calories: 32, protein: 0.7),
  FoodItem(name: "Oranges (100g)", calories: 47, protein: 0.9),
  FoodItem(name: "Kiwi (100g)", calories: 61, protein: 1.1),
  FoodItem(name: "Almonds (100g)", calories: 579, protein: 21),
  FoodItem(name: "Walnuts (100g)", calories: 654, protein: 15),
  FoodItem(name: "Cashews (100g)", calories: 553, protein: 18),
  FoodItem(name: "Pistachios (100g)", calories: 562, protein: 20),
  FoodItem(name: "Hazelnuts (100g)", calories: 628, protein: 15),
  FoodItem(name: "Peanuts (100g)", calories: 567, protein: 25.8)
];

class NutritionScreen extends StatefulWidget {
  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  int totalCalories = 3520;
  int caloriesConsumed = 0;
  Map<String, List<FoodItem>> meals = {
    'Breakfast': [],
    'Lunch': [],
    'Dinner': []
  };

  void addFoodToMeal(String meal, FoodItem food) {
    setState(() {
      meals[meal]?.add(food);
      caloriesConsumed += food.calories;
    });
  }

  void adjustTotalCalories() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _controller =
            TextEditingController(text: totalCalories.toString());
        return AlertDialog(
          title: Text("Adjust Calorie Goal"),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(labelText: "Enter your daily calorie goal"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                setState(() {
                  totalCalories = int.parse(_controller.text);
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Calories Remaining: ${totalCalories - caloriesConsumed}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: adjustTotalCalories,
                        child: Icon(Icons.edit,
                            color: const Color.fromARGB(255, 32, 32, 32)),
                      ),
                    ]),
              ),
            ),
            MealSection(
                title: 'Breakfast',
                meals: meals['Breakfast']!,
                addFoodToMeal: addFoodToMeal),
            MealSection(
                title: 'Lunch',
                meals: meals['Lunch']!,
                addFoodToMeal: addFoodToMeal),
            MealSection(
                title: 'Dinner',
                meals: meals['Dinner']!,
                addFoodToMeal: addFoodToMeal),
          ],
        ),
      ),
    );
  }
}

class MealSection extends StatelessWidget {
  final String title;
  final List<FoodItem> meals;
  final Function(String, FoodItem) addFoodToMeal;

  MealSection(
      {required this.title, required this.meals, required this.addFoodToMeal});

  void showFoodSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Food for $title"),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableFoods.length,
              itemBuilder: (context, index) {
                final food = availableFoods[index];
                return ListTile(
                  title: Text(food.name),
                  subtitle: Text(
                      "${food.calories} calories - ${food.protein} protein"),
                  onTap: () {
                    addFoodToMeal(title, food);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      children: meals
          .map((food) => ListTile(
                title: Text(food.name),
                subtitle:
                    Text("${food.calories} calories - ${food.protein} protein"),
              ))
          .toList()
        ..add(ListTile(
          title: Text("Add Food"),
          leading: Icon(Icons.add),
          onTap: () => showFoodSelection(context),
        )),
    );
  }
}
