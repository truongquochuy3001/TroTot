import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tro_tot_app/models/room_model.dart';
import 'package:tro_tot_app/services/user_services.dart';

import '../services/room_services.dart';

class RoomViewModel extends ChangeNotifier {
  final CollectionReference _postCollection =
      FirebaseFirestore.instance.collection('Room');

  final RoomServices _roomServices = RoomServices();
  final UserSevices _userServices = UserSevices();
  List<Room> _rooms = [];
  List<Room> _searchRoom = [];
  List<Room> _sortRooms = [];
  List<Room> _searchRoomLocal = [];
  List<Room> _userRooms = [];
  List<Room> _userRoomsHide = [];
  List<String> _searchHistory = [];
  List<Room> _roomsNearby = [];

  List<Room> get roomsNearby => _roomsNearby;

  List<Room> get rooms => _rooms;

  List<Room> get searchRooms => _searchRoom;

  List<Room> get searchRoomsLocal => _searchRoomLocal;

  List<Room> get sortRooms => _sortRooms;

  List<Room> get userRooms => _userRooms;

  List<Room> get userRoomsHide => _userRoomsHide;

  List<String> get searchHistory => _searchHistory;

  StreamController<List<Room>> roomUserDisplayController =
      StreamController<List<Room>>.broadcast();
  StreamController<List<Room>> roomUserHideController =
      StreamController<List<Room>>.broadcast();


  Future<Room?> getRoom(String id) async {
    Room? room = await _roomServices.getRoom(id);
    return room;
  }

  Future<void> getAllRoom() async {
    _rooms = await _roomServices.getRooms();
    // _userRooms = await _roomServices.getRooms();
    notifyListeners();
  }

  Future<void> addRoom(Room room, String geohash) async {
    await _roomServices.addRoom(room, geohash);
    _rooms = await _roomServices.getRooms();
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

    notifyListeners();
  }

  Future<void> sortRoom(
    double startPrice,
    double endPrice,
    int? cityId,
    int? districtId,
    int? wardId,
    bool latestNew,
    bool lowPriceFirst,
  ) async {
    _sortRooms = await _roomServices.sortRoom(startPrice, endPrice, cityId,
        districtId, wardId, latestNew, lowPriceFirst);
    notifyListeners();
  }

  Future<void> getRoomsUser(String userId) async {
    _userRooms = await _roomServices.getRoomsUser(userId);

    roomUserDisplayController.add(_userRooms);
    notifyListeners();
  }

  Future<void> getRoomUserHide(String userId) async {
    _userRoomsHide = await _roomServices.getRoomUserHide(userId);

    roomUserHideController.add(_userRoomsHide);
    notifyListeners();
  }

  Future<void> updateRoom(String id, Room room, String geohash) async {
    await _roomServices.updateRoom(id, room, geohash);
    _rooms = await _roomServices.getRooms();
    _userRooms = await _roomServices.getRooms();
    notifyListeners();
  }

  Future<void> hideRoom(String id, bool hide) async {
    await _roomServices.hideRoom(id, hide);
    _userRoomsHide.add(_userRooms.where((element) => element.id == id).first);
    _userRooms.removeWhere((element) => element.id == id);
    _rooms.removeWhere((element) => element.id == id);

    notifyListeners();
  }

  Future<void> displayRoom(String id) async {
    await _roomServices.hideRoom(id, false);
    _userRooms.add(_userRoomsHide.where((element) => element.id == id).first);
    _rooms.add(_userRoomsHide.where((element) => element.id == id).first);
    _userRoomsHide.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> deleteRoom(String id) async {
    await _roomServices.deleteRoom(id);
    _userRooms.removeWhere((element) => element.id == id);
    _rooms.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void getRoomNearby(Position position) {
    _roomServices.getRoomNearLocation(position).listen((rooms) {
      _roomsNearby = rooms;
      notifyListeners();
    });
  }
}
