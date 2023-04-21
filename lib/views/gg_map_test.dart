import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTest extends StatefulWidget {
  MapTest({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  TextEditingController place = TextEditingController();
  LatLng? _latLng;


    // Future<void> _getLatLngFromAddress() async {
    //   List<Location> locations = await GeocodingPlatform.instance
    //       .locationFromAddress('Gronausestraat 710, Enschede');
    //   setState(() {
    //     _latLng = LatLng(
    //       locations.first.latitude!,
    //       locations.first.longitude!,
    //     );
    //   });
    // }
  void getAddressLocation(String address) async {
    try {
      List<Location> locations = await GeocodingPlatform.instance
          .locationFromAddress(address);
      if (locations != null && locations.isNotEmpty) {
        Location location = locations[0];
        print('Latitude: ${location.latitude}, Longitude: ${location.longitude}');
      } else {
        print('No location found for the given address.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<LatLng> getLatLngFromAddress(String address) async {
    // Get the location coordinates from the address
    List<Location> locations = await GeocodingPlatform.instance
        .locationFromAddress(address);

    // Extract the latitude and longitude from the location
    LatLng latLng = LatLng(locations.first.latitude, locations.first.longitude);
    print(latLng);
    return latLng;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: place,
            ),
            // if (_latLng != null) Text('Lat:   ${_latLng!.latitude}, Lng: ${_latLng!.longitude}'),
            ElevatedButton(
              onPressed: () {
                getLatLngFromAddress(place.value.toString());
              },
              child: Text('Get LatLng from Address'),
            ),
          ],
        ),
      ),
    );
  }
}
