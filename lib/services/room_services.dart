import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tro_tot_app/interfaces/room_interfaces.dart';
import 'package:tro_tot_app/models/room_model.dart';

class RoomServices implements IRoomServices {
  @override
  Future<Room?> getRoom(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Room').doc(id).get();
    if (!snapshot.exists) return null;
    return Room.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<List<Room>> getRooms() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Room')
        .orderBy('postingDate', descending: true)
        .get();
    final List<Room> rooms =
        snapshot.docs.map((e) => Room.fromJson(e.data())).toList();
    return rooms;
  }

  @override
  Future<void> addRoom(Room room, String geohash) async {
    // TODO: implement addRoom

    final snapshot =
        await FirebaseFirestore.instance.collection('Room').add(room.toJson());
    final roomId = snapshot.id;
    await snapshot.update({'id': roomId});
  }

  @override
  Future<List<Room>> searchRoom(String searchKey) async {
    // TODO: implement searchRoom
    // final searchKeys = searchKey.split(' ');
    print(searchKey);
    final snapshot = await FirebaseFirestore.instance
        .collection('Room')
        .where('name', isGreaterThanOrEqualTo: searchKey)
        .where('name', isLessThanOrEqualTo: searchKey + '\uf8ff')
        .get();
    final List<Room> rooms =
        snapshot.docs.map((e) => Room.fromJson(e.data())).toList();

    return rooms;
  }

  @override
  Future<void> searchRoomLocal(String searchKey) {
    // TODO: implement searchRoomLocal
    throw UnimplementedError();
  }

  @override
  Future<List<Room>> sortRoom(
      double startPrice,
      double endPrice,
      int? cityId,
      int? districtId,
      int? wardId,
      bool latestNew,
      bool lowPriceFirst,
      ) async {
    // TODO: implement sortRoom
    final collectionReference = FirebaseFirestore.instance.collection('Room');
    Query query = collectionReference;
    if (cityId != null && districtId != null && wardId != null) {
      query = query
          .where('cityId', isEqualTo: cityId)
          .where('districtId', isEqualTo: districtId)
          .where('wardId', isEqualTo: wardId);

      if (latestNew) {
        query = query.orderBy('postingDate', descending: true);
      }

      if (lowPriceFirst) {
        query = query.orderBy('price', descending: false);
      }


    }
    final QuerySnapshot querySnapshot = await query.get();
    final List<Room> rooms = querySnapshot.docs.map((doc) => Room.fromJson(doc.data() as Map<String, dynamic>)).toList();

    return rooms;
  }
}
