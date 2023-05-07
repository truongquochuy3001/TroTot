import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:tro_tot_app/models/room_model.dart';


import '../services/room_services.dart';

class RoomViewModel extends ChangeNotifier {
  final CollectionReference _postCollection =
      FirebaseFirestore.instance.collection('Room');

  final RoomServices _roomServices = RoomServices();
  List<Room> _rooms = [];
  List<Room> _searchRoom = [];
  List<Room> _sortRooms =[];
  List<Room> _searchRoomLocal = [];
  List<Room> _userRooms = [];
  List<String> _searchHistory = [];

  List<Room> get rooms => _rooms;

  List<Room> get searchRooms => _searchRoom;

  List<Room> get searchRoomsLocal => _searchRoomLocal;

  List<Room> get sortRooms => _sortRooms;

  List<Room> get userRooms => _userRooms;

  List<String> get searchHistory => _searchHistory;


  Future<Room?> getRoom(String id) async {
    return await _roomServices.getRoom(id);
  }

  Future<void> getAllRoom() async {
    _rooms = await _roomServices.getRooms();
    notifyListeners();
  }

  Future<void> addRoom(Room room, String geohash) async {
    await _roomServices.addRoom(room, geohash);
    notifyListeners();
  }


  // Lấy tất cả dữ liệu phòng trọ về rồi so sánh local
  Future<void> searchRoomLocal(String searchKey) async {
    _searchRoomLocal.clear();
    _rooms = await _roomServices.getRooms();
    var formatSearchKey = Set.from(utf8.encode(searchKey.toLowerCase()));
    for (int i = 0; i < _rooms.length; i++) {
      if (Set.from(utf8.encode(_rooms[i].name.toLowerCase()))
          .containsAll(Set.from(utf8.encode(searchKey.toLowerCase())))) {
        _searchRoomLocal.add(_rooms[i]);
      }
    }

    if (_searchHistory.isNotEmpty) {
      for (int i = 0; i < _searchHistory.length; i++) {
        if (_searchHistory[i] == searchKey) {
          _searchHistory.removeAt(i);
        }
      }
    }
    _searchHistory.add(searchKey);

    print(_searchRoomLocal.length);
    print(_searchHistory);
    notifyListeners();
  }

  Future<void> sortRoom( double startPrice,
      double endPrice,
      int? cityId,
      int? districtId,
      int? wardId,
      bool latestNew,
      bool lowPriceFirst,
      ) async{
    _sortRooms = await _roomServices.sortRoom(startPrice, endPrice, cityId, districtId, wardId, latestNew, lowPriceFirst);
    notifyListeners();
  }

  Future<void> getRoomsUser(String userId) async{
    _userRooms = await _roomServices.getRoomsUser(userId);
    notifyListeners();
  }

  Future<void> updateRoom(String id, Room room, String geohash) async{
    await _roomServices.updateRoom(id, room, geohash);
    notifyListeners();
  }
}
