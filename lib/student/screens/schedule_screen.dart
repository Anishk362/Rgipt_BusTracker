import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Schedule"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            const Text(
              "Daily Time Table",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Route: Raebareli ↔ RGIPT (Jais)",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // The Schedule List
            Expanded(
              child: ListView(
                children: const [
                  ScheduleCard(
                    time: "08:00 AM",
                    route: "Raebareli ➔ RGIPT",
                    busNumber: "Bus UP-33-AT-1234",
                    isNext: false,
                  ),
                  ScheduleCard(
                    time: "10:30 AM",
                    route: "Raebareli ➔ RGIPT",
                    busNumber: "Bus UP-33-AT-5678",
                    isNext: true, // Highlight this one!
                  ),
                  ScheduleCard(
                    time: "02:00 PM",
                    route: "RGIPT ➔ Raebareli",
                    busNumber: "Bus UP-33-AT-1234",
                    isNext: false,
                  ),
                  ScheduleCard(
                    time: "05:30 PM",
                    route: "RGIPT ➔ Raebareli",
                    busNumber: "Bus UP-33-AT-5678",
                    isNext: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A Custom Widget to make the list items look nice
class ScheduleCard extends StatelessWidget {
  final String time;
  final String route;
  final String busNumber;
  final bool isNext;

  const ScheduleCard({
    super.key,
    required this.time,
    required this.route,
    required this.busNumber,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isNext ? Colors.blue.shade50 : Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: isNext ? const BorderSide(color: Colors.blue, width: 2) : BorderSide.none,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isNext ? Colors.blue : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.access_time_filled,
            color: isNext ? Colors.white : Colors.grey,
          ),
        ),
        title: Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isNext ? Colors.blue.shade900 : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(route, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(busNumber, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: isNext
            ? const Chip(
                label: Text("NEXT", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              )
            : null,
      ),
    );
  }
}