import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tro_tot_app/models/room_model.dart';

class RoomData with ChangeNotifier {
  final CollectionReference _postCollection =
      FirebaseFirestore.instance.collection('Room');

  Future<QuerySnapshot<Map<String, dynamic>>> getRoom() async {
    final collection =
        await FirebaseFirestore.instance.collection('Room').get();

    return collection;
  }

  Future<List<Room>> getAllRoom() async {
    List<Room> rooms = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Room').get();

    querySnapshot.docs.forEach((doc) {
      Room room = Room.fromJson(doc.data());
      rooms.add(room);
    });

    return rooms;
  }

  Future<Map<String, dynamic>> getRoomData(String roomId) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('Room').doc(roomId).get();
    Map<String, dynamic> data = documentSnapshot.data()!;
    return data;
  }

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
