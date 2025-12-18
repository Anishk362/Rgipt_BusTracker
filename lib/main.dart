import 'package:flutter/material.dart';
// Importing your separate screens
import 'driver/driver_home.dart';
import 'student/student_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // We will uncomment this line later when we set up Firebase properly
  // await Firebase.initializeApp(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RGIPT Bus Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Role")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button for Driver
            ElevatedButton.icon(
              icon: const Icon(Icons.directions_bus, size: 32),
              label: const Text("I am a Driver", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DriverHome()),
                );
              },
            ),
            const SizedBox(height: 30), // Spacing
            // Button for Student
            ElevatedButton.icon(
              icon: const Icon(Icons.school, size: 32),
              label: const Text("I am a Student", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentHome()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}