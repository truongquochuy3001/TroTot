import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:tro_tot_app/models/room_model.dart';

import '../services/room_services.dart';

class RoomViewModel extends ChangeNotifier {
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

  void addRoom(Room room) async {
    _roomServices.addRoom(room);
    notifyListeners();
  }
}
