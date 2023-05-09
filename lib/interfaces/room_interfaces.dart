import 'package:tro_tot_app/models/room_model.dart';

abstract class IRoomServices {
  Future<List<Room>> getRooms();

  Future<Room?> getRoom(String id);

  Future<void> addRoom(Room room, String geohash);

  Future<void> updateRoom( String id,Room room, String geohash);

  Future<void> hideRoom(String id, bool hide);

  Future<List<Room>> searchRoom(String searchKey);

  Future<void> searchRoomLocal(String searchKey);

  Future<List<Room>> sortRoom(double startPrice, double endPrice, int? cityId, int? districtId, int? wardId, bool latestNew, bool lowPriceFirst);

  Future<List<Room>> getRoomsUser(String userId);

  Future<List<Room>> getRoomUserHide (String userId);

  Future<void> deleteRoom(String id);
}
