
import 'package:fitnesseapplication/screens/BMI_screen.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'nutrition_screen.dart';
import 'workout_screen.dart';
import 'weight_screen.dart';
import '../widgets/info_card.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Set the height of the AppBar
        child: Container(
          color: Color(0xFFF84C4C), // Set the color of the Container
          child: AppBar(
            backgroundColor: Colors.transparent, // Make AppBar's background transparent
            elevation: 0, // Remove shadow from AppBar
            leading: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              ),
            ),
            title: Text('Fit-nesse', style: TextStyle(color: Colors.white)), // Ensure title text is white
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () => _showNotification(context),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: [
            InfoCard(
              title: 'Calories',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NutritionScreen())),
              color: Color(0xFFF84C4C),
            ),
            InfoCard(
              title: 'BMI',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BMIScreen())),
              color: Color(0xFFF84C4C),
            ),
            InfoCard(
              title: 'Exercise',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutScreen())),
              color: Color(0xFFF84C4C),
            ),
            InfoCard(
              title: 'Weight',
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => WeightScreen())),
              color: Color(0xFFF84C4C),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Notification'),
        content: Text('You have no new notifications.'),
      ),
    );
  }
}