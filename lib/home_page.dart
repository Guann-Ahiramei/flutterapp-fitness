import 'package:flutter/material.dart';
import 'package:gemini_in_flutter/quickstartworkout.dart';
import 'package:gemini_in_flutter/settings_screen.dart';
import 'generate_workout_plan_screen.dart';
import 'login.dart';
import 'running_track_screen.dart'; // 导入运行轨迹页面

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Coach App'),
      ),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Fitness Coach App',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Personalized workouts at your fingertips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),
                _buildFeatureCard(
                  context,
                  'Generate Workout Plan',
                  'Create a personalized workout plan tailored to your goals and experience level.',
                  Icons.fitness_center,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const GenerateWorkoutPlanScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildFeatureCard(
                  context,
                  'Running Track',
                  'Track your running route using GPS and Google Maps.',
                  Icons.map,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RunningTrackScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                QuickStartWorkout(),
              ],
            ),
          ),
        ),
      ),
    );
  }
// 构建侧边栏
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // 关闭侧边栏
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // 关闭侧边栏
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context); // 关闭侧边栏
              // 这里可以实现退出功能
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out!")),
              );
            },
          ),
        ],
      ),
    );
  }
  Widget _buildFeatureCard(BuildContext context, String title,
      String description, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(height: 15),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 5),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
