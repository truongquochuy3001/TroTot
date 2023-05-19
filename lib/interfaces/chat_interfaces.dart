import 'package:tro_tot_app/models/chat_model.dart';

abstract class IChatServices{
  Future<void> addMessage(Message message, String userId, String roomOwnerId, String roomId, String chatRoomId);
  Future<void> addRoomChat (RoomChat roomChat);
  Future<RoomChat?> getRoomChat(String roomId);
  Future<List<Message>> getAllMessage(String id);
}