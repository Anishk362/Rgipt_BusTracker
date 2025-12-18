import 'package:flutter/material.dart';
import '../services/tracking_service.dart'; // Notice the ".." to go up one folder

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final TrackingService _trackingService = TrackingService();
  bool _isTracking = false;
  String _statusText = "Offline";

  void _toggleTracking() {
    setState(() {
      if (_isTracking) {
        _trackingService.stopBroadcasting('bus_001');
        _isTracking = false;
        _statusText = "Offline 🛑";
      } else {
        _trackingService.startBroadcasting('bus_001');
        _isTracking = true;
        _statusText = "Broadcasting Location 📡";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Tracking")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _statusText,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isTracking ? Colors.green : Colors.grey),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: _toggleTracking,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: _isTracking ? Colors.red : Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: 10, color: Colors.black26)
                  ],
                ),
                child: Icon(
                  _isTracking ? Icons.stop : Icons.play_arrow,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(_isTracking ? "Tap to Stop" : "Tap to Start"),
          ],
        ),
      ),
    );
  }
}