import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tro_tot_app/models/room_model.dart';

import '../services/room_services.dart';

class RoomData extends ChangeNotifier {
  final CollectionReference _postCollection =
      FirebaseFirestore.instance.collection('Room');

  final RoomServices _roomServices = RoomServices();
  List<Room> _rooms = [];
  List<Room> get rooms => _rooms;

  Future<Room?> getRoom(String id) async {
    return await _roomServices.getRoom(id);
  }

  Future<void> getAllRoom() async {
    _rooms = await _roomServices.getRooms();
    notifyListeners();
  }

  // Future<Map<String, dynamic>> getRoomData(String roomId) async {
  //   DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
  //       await FirebaseFirestore.instance.collection('Room').doc(roomId).get();
  //   Map<String, dynamic> data = documentSnapshot.data()!;
  //   return data;
  // }

  Future<void> addRoom(
      String name,
      String address,
      int price,
      String roomType,
      int size,
      List<String> images,
      String image,
      String postingDate,
      bool status,
      String description,
      bool furniture,
      String id) async {
    DocumentReference docRef = _postCollection.doc();
    String rID = docRef.id;
    docRef.set({
      'RoomId': rID,
      'RoomAddr': address,
      'RoomDecribe': description,
      'RoomFurniture': furniture,
      'RoomImages': images,
      'RoomImage': image,
      'RoomPostDate': postingDate,
      'RoomPrice': price,
      'RoomSize': size,
      'RoomStatus': status,
      'RoomTitle': name,
      'Roomtype': roomType,
      'UserID': id,
    });
  }
}
