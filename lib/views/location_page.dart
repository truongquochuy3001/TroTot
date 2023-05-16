import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';


class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late GoogleMapController mapController;
  Position? _position;
  String _address = '';


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check for permission to access location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Request permission to access location
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    // Get the user's current location
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get the address from the coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _position!.latitude, _position!.longitude);
    if (placemarks.isNotEmpty) {
      setState(() {
        Placemark place = placemarks[0];
        _address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        print(_address);
      });
    }

    // Move the camera to the user's current location
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(_position!.latitude, _position!.longitude),
        zoom: 16.0,
      ),
    ));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Consumer<RoomViewModel>(
            builder: (context, value, child) => ElevatedButton(onPressed: ()async{
              value.getRoomNearby(_position!);
             print(_position!.latitude);
             print(value.roomsNearby.length);
            }, child: Text("Tim")),
          )
        ],
        title: GestureDetector(

            child: Text(_address, maxLines: 2,softWrap: true, style: TextStyle(fontSize: 16.sp, overflow: TextOverflow.ellipsis),)),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 16.0,
        ),
        myLocationEnabled: true,
        compassEnabled: true,
        mapType: MapType.normal,
      ),
    );
  }
}
