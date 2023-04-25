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
    final snapshot = await FirebaseFirestore.instance.collection('Room').get();
    final List<Room> rooms =
        snapshot.docs.map((e) => Room.fromJson(e.data())).toList();
    return rooms;
  }

  @override
  void addRoom(Room room) async {
    // TODO: implement addRoom

    final snapshot = await FirebaseFirestore.instance.collection('Room').add(room.toJson());
    final roomId = snapshot.id;
    await snapshot.update({'id' : roomId});
  }

  @override
  Future<List<Room>> searchRoom(String searchKey) async{
    // TODO: implement searchRoom
    // final searchKeys = searchKey.split(' ');
    print(searchKey);
    final snapshot = await FirebaseFirestore.instance.collection('Room').where('name', isGreaterThanOrEqualTo: searchKey)
        .where('name', isLessThan: searchKey + 'z').get();
    final List<Room> rooms =
    snapshot.docs.map((e) => Room.fromJson(e.data())).toList();
    print(rooms.first.name);
    print(rooms.first.address);
    return rooms;
  }
}
