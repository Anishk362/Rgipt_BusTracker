import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class TrackingService {
  // This variable keeps our connection to the GPS open
  StreamSubscription<Position>? _positionStream;

  // FUNCTION 1: Start tracking and sending data
  Future<void> startBroadcasting(String busId) async {
    // 1. Check if we have permission to use GPS
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // 2. Configure GPS settings (High accuracy)
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Only send update if we move 10 meters
    );

    // 3. Start listening to the movement
    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      
      // Print to console so you can see it working
      print("📍 UPDATING FIREBASE: ${position.latitude}, ${position.longitude}"); 

      // 4. Send the new numbers to Firebase
      FirebaseFirestore.instance.collection('buses').doc(busId).set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
        'is_active': true,
        'bus_id': busId,
      }, SetOptions(merge: true));
    });
  }

  // FUNCTION 2: Stop tracking
  void stopBroadcasting(String busId) {
    // 1. Close the GPS connection
    _positionStream?.cancel();

    // 2. Tell Firebase the bus has stopped
    FirebaseFirestore.instance.collection('buses').doc(busId).update({
      'is_active': false,
    });
    
    print("🛑 TRIP ENDED");
  }
}