// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
// import 'package:geolocator/geolocator.dart';
//
// final geo = Geoflutterfire();
// final CollectionReference placesRef = FirebaseFirestore.instance.collection('places');
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My App',
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<DocumentSnapshot> nearbyPlaces = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     final position = await Geolocator.getCurrentPosition();
//     final userLocation = geo.point(latitude: position.latitude, longitude: position.longitude);
//     final result = await _getNearbyPlaces(userLocation, 10.0);
//     setState(() {
//       nearbyPlaces = result;
//     });
//   }
//
//   Future<List<DocumentSnapshot>> _getNearbyPlaces(GeoFirePoint userLocation, double radius) async {
//     final field = 'position';
//     final stream = geo.collection(collectionRef: placesRef)
//         .within(center: userLocation, radius: radius, field: field);
//     final documentList = await stream.first;
//     return documentList;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Nearby Places'),
//       ),
//       body: nearbyPlaces.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: nearbyPlaces.length,
//         itemBuilder: (context, index) {
//           final place = nearbyPlaces[index].data();
//           return ListTile(
//             title: Text(place['name']),
//             subtitle: Text(place['address']),
//           );
//         },
//       ),
//     );
//   }
// }
