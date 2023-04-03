import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tro_tot_app/models/room_model.dart';

class RoomData with ChangeNotifier {
  Future<QuerySnapshot<Map<String, dynamic>>> getRoom() async {
    final collection =
        await FirebaseFirestore.instance.collection('Room').get();

    return collection;
  }
}
