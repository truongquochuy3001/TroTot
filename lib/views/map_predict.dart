import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class MapPredict extends StatefulWidget {
  const MapPredict({Key? key}) : super(key: key);

  @override
  State<MapPredict> createState() => _MapPredictState();
}

class _MapPredictState extends State<MapPredict> {
  TextEditingController place = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = "";
  List<dynamic> _placeList =[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    place.addListener(() {
      onChange();
    });
  }

  void onChange(){
    if (_sessionToken == null ){
      _sessionToken = uuid.v4();
    }
    getSuggestion(place.text);

  }

  void getSuggestion(String input) async{
    String kPLACES_API_KEY = "AIzaSyDc7PnOq3Hxzq6dxeUVaY8WGLHIePl0swY";
    String baseURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print(data);
    if (response.statusCode == 200){
      _placeList = jsonDecode(response.body.toString())['predictions'];
    }
    else {throw Exception("failed");}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap( initialCameraPosition: CameraPosition(target: LatLng(37.4219999, -122.0862462),)),
      ),
    );
  }
}
