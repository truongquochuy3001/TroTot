import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tro_tot_app/interfaces/chat_interfaces.dart';
import 'package:tro_tot_app/models/chat_model.dart';

class ChatServices implements IChatServices {
  @override
  Future<void> addMessage(Message message, String userId, String roomOwnerId,
      String roomId, String chatRoomId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('Message')
        .add(message.toJson());
  }

  @override
  Future<void> addRoomChat(RoomChat roomChat) async {
    final data = FirebaseFirestore.instance.collection('ChatRoom');
    final snapshot = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .add(roomChat.toJson());
    final chatRoomId = snapshot.id;
    await snapshot.update({'id': chatRoomId});
  }

  @override
  Future<RoomChat?> getRoomChat(String roomId) async {
    final data = FirebaseFirestore.instance.collection('ChatRoom');
    final snapshot = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('roomId', isEqualTo: roomId)
        .get();
    RoomChat? roomChat = RoomChat.fromJson(snapshot.docs.last.data());

    return roomChat;
  }

  @override
  Future<List<Message>> getAllMessage(String id) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(id)
        .collection('Message')
        .orderBy('time', descending: false)
        .get();
    final List<Message> messages =
        snapshot.docs.map((e) => Message.fromJson(e.data())).toList();
    return messages;
  }

  @override
  Future<bool> checkChatRoomExist(
      String roomId, String roomOwnerId, String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('roomId', isEqualTo: roomId)
        .where('roomOwnerId', isEqualTo: roomOwnerId)
        .where('userId', isEqualTo: userId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Future<List<RoomChat>> getAllRoomChat() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('ChatRoom').get();

    final List<RoomChat> roomChats =
        snapshot.docs.map((e) => RoomChat.fromJson(e.data())).toList();
    return roomChats;
  }

  @override
  Future<List<RoomChat>> getRoomChatYouHire(String id) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('userId', isEqualTo: id)
        .get();

    final List<RoomChat> roomChats =
        snapshot.docs.map((e) => RoomChat.fromJson(e.data())).toList();
    return roomChats;
  }

  @override
  Future<List<RoomChat>> getRoomChatYouOwn(String id) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('roomOwnerId', isEqualTo: id)
        .get();

    final List<RoomChat> roomChats =
        snapshot.docs.map((e) => RoomChat.fromJson(e.data())).toList();
    return roomChats;
  }

  @override
  Future<RoomChat?> getRoomChatFromId(String id) async{
    final data = FirebaseFirestore.instance.collection('ChatRoom');
    final snapshot = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(id)
        .get();
    RoomChat? roomChat = RoomChat.fromJson(snapshot.data()!);

    return roomChat;
  }
}
