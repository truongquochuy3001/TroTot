import 'package:cloud_firestore/cloud_firestore.dart';
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
    final snapshot =
        await FirebaseFirestore.instance.collection('ChatRoom').where('roomId', isEqualTo: roomId).get();

    return RoomChat.fromJson(snapshot.docs.first.data());
  }

  @override
  Future<List<Message>> getAllMessage(String id) async{

    final snapshot =
    await FirebaseFirestore.instance.collection('ChatRoom').doc(id).collection('Message').orderBy('time', descending: false).get();
    final List<Message> messages =
    snapshot.docs.map((e) => Message.fromJson(e.data())).toList();
    return messages;
  }
}
