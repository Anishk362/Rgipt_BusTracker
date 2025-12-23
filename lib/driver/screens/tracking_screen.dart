import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';


class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  bool _isTracking = false;
  String _statusText = "Offline";

  @override
  void initState() {
    super.initState();
    // Check status immediately when screen opens
    _checkServiceStatus();
  }

  void _checkServiceStatus() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      setState(() {
        _isTracking = true;
        _statusText = "Broadcasting Location 📡";
      });
    } else {
      setState(() {
        _isTracking = false;
        _statusText = "Offline";
      });
    }
  }

  void _toggleTracking() async {
    final service = FlutterBackgroundService();

    if (_isTracking) {
      // --- STOP LOGIC ---
      service.invoke("stopService");
      
      setState(() {
        _isTracking = false;
        _statusText = "Offline 🛑";
      });
    } else {
      // --- START LOGIC ---
      // We do NOT call initializeService() here anymore. It's in main.dart.
      
      service.startService(); // <--- This wakes up the service

      setState(() {
        _isTracking = true;
        _statusText = "Broadcasting Location 📡";
      });
    }
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
              child: AnimatedContainer( // Added animation for smoother feel
                duration: const Duration(milliseconds: 300),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: _isTracking ? Colors.red : Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10, 
                      color: _isTracking ? Colors.redAccent.withOpacity(0.4) : Colors.greenAccent.withOpacity(0.4),
                      spreadRadius: 5,
                    )
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
            Text(
              _isTracking ? "Tap to Stop Trip" : "Tap to Start Trip",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}