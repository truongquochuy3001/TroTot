import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get_connect/connect.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GGMapsPage extends StatefulWidget {
  const GGMapsPage({super.key});

  @override
  State<GGMapsPage> createState() => _GGMapsPageState();
}

class _GGMapsPageState extends State<GGMapsPage> {
  late GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              mapToolbarEnabled: true,
              compassEnabled: true,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {},
              initialCameraPosition: const CameraPosition(
                target: LatLng(16.4811017, 107.5732962),
              ),
            ),
          ),
        ));
  }
}
