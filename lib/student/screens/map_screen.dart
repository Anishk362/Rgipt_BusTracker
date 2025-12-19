import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/bus_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final BusService _busService = BusService();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  // RGIPT Location
  static const LatLng _rgiptLocation = LatLng(26.2303, 81.2335);

  @override
  void initState() {
    super.initState();
    _listenToBus();
  }

  void _listenToBus() {
    _busService.getBusStream('bus_001').listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;

        // 1. Get Location
        double lat = data['latitude'];
        double lng = data['longitude'];
        bool isActive = data['is_active'];

        // 2. Get The New "Who is Driving" Details
        // (We use 'Unknown' as a fallback if the data is missing)
        String driverName = data['driver_name'] ?? "Unknown Driver";
        String conductorName = data['conductor_name'] ?? "Unknown Conductor";
        String busNumber = data['bus_number'] ?? "Bus ???";
        String phone = data['conductor_phone'] ?? "";

        setState(() {
          _markers.clear();
          if (isActive) {
            _markers.add(
              Marker(
                markerId: const MarkerId('bus_001'),
                position: LatLng(lat, lng),
                // Instead of a simple text bubble, we make it clickable!
                onTap: () {
                  _showBusDetails(context, driverName, conductorName, busNumber, phone);
                },
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              ),
            );

            _mapController?.animateCamera(
              CameraUpdate.newLatLng(LatLng(lat, lng)),
            );
          }
        });
      }
    });
  }

  // --- THE NEW "WHO IS DRIVING" CARD ---
  void _showBusDetails(BuildContext context, String driver, String conductor, String busNo, String phone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Transparent so we can see rounded corners
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Bus Number Plate (Big Header)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Bus Number", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(
                          busNo,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    const Icon(Icons.directions_bus, size: 40, color: Colors.blueAccent),
                  ],
                ),
                const Divider(height: 30),

                // 2. Driver Info
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(driver, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Driver"),
                ),

                // 3. Conductor Info
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.confirmation_number, color: Colors.white),
                  ),
                  title: Text(conductor, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Conductor"),
                  trailing: IconButton(
                    icon: const Icon(Icons.phone, color: Colors.green),
                    onPressed: () {
                      // This is where we would trigger the phone call
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text("Calling $conductor ($phone)...")),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Bus Map")),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _rgiptLocation,
          zoom: 15,
        ),
        markers: _markers,
        
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}