import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Entry point
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // 1. Create Channel in Main Isolate (Prevents "Bad Notification" crash)
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'bus_tracker_v2', 
    'Bus Tracker Service', 
    description: 'This channel is used for bus tracking.',
    importance: Importance.low, 
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // 2. Configure Service
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false, 
      isForegroundMode: true, 
      
      notificationChannelId: 'bus_tracker_v2',
      initialNotificationTitle: 'Bus Tracker Active',
      initialNotificationContent: 'Waiting for GPS...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase already initialized
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  service.on('stopService').listen((event) async {
    // 1. Tell Firebase we are offline BEFORE quitting
    await FirebaseFirestore.instance.collection('buses').doc('bus_001').update({
      'is_active': false,
    });

    // 2. Stop the service
    service.stopSelf();
  });

  // --- KICKSTART: Force an immediate update (Fixes "Waiting for GPS") ---
  try {
    Position startPos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print("KICKSTART LOCATION: ${startPos.latitude}"); 
    
    if (service is AndroidServiceInstance) {
      flutterLocalNotificationsPlugin.show(
        888,
        'Bus Tracker Running',
        'Lat: ${startPos.latitude}, Lng: ${startPos.longitude}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'bus_tracker_v2',
            'Bus Tracker Service',
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );
    }
  } catch (e) {
    print("Kickstart failed (GPS might be warming up): $e");
  }
  // ---------------------------------------------------------------------

  // 3. Start Location Stream
  Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0, // <--- CHANGED TO 0 FOR TESTING (Updates while sitting)
    ),
  ).listen((Position position) async { // <--- Added 'async' here
    
    // A. Update Notification
    if (service is AndroidServiceInstance) {
      // Fixed: Added 'await' because isForegroundService returns a Future
      if (await service.isForegroundService()) { 
        flutterLocalNotificationsPlugin.show(
          888,
          'Bus Tracker Running',
          'Lat: ${position.latitude}, Lng: ${position.longitude}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'bus_tracker_v2',
              'Bus Tracker Service',
              icon: 'ic_bg_service_small', 
              ongoing: true,
            ),
          ),
        );
      }
    }

    // B. Update Firebase
    print("UPDATING FIREBASE: ${position.latitude}, ${position.longitude}"); 
    
    FirebaseFirestore.instance.collection('buses').doc('bus_001').set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'last_updated': FieldValue.serverTimestamp(),
      'is_active': true,
    }, SetOptions(merge: true)); 

  }, onError: (e) {
    print("Location Stream Error: $e");
  });
}