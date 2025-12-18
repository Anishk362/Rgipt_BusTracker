import 'package:flutter/material.dart';
import 'screens/tracking_screen.dart'; // CONNECTS TO THE NEW FILE

class DriverHome extends StatelessWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Driver Dashboard 🚌")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BUTTON 1: Go to the Tracking Screen
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text("Start GPS Tracking"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // This command opens the new tracking_screen.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrackingScreen()),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // BUTTON 2: Placeholder for next feature
            ElevatedButton.icon(
              icon: const Icon(Icons.event_seat),
              label: const Text("View Reservations (Coming Soon)"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}