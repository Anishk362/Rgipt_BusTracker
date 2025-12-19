import 'package:cloud_firestore/cloud_firestore.dart';

class BusService {
  
  // This function returns a stream of data directly from Firebase
  Stream<DocumentSnapshot> getBusStream(String busId) {
    return FirebaseFirestore.instance
        .collection('buses')
        .doc(busId)
        .snapshots();
  }
}