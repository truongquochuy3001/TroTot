import 'package:tro_tot_app/models/room_model.dart';

abstract class IRoomServices {
  Future<List<Room>> getRooms();

  Future<Room?> getRoom(String id);
}
