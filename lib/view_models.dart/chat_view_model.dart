import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:tro_tot_app/models/chat_model.dart';
import 'package:tro_tot_app/services/chat_services.dart';

class ChatViewModel extends ChangeNotifier {
  StreamController<List<Message>> messageController =
      StreamController<List<Message>>.broadcast();

  StreamController<Message> lastMessageController =
  StreamController<Message>.broadcast();
  List<Message> listMessage = [];

  RoomChat? _roomChat;

  List<RoomChat> _listRoomChat = [];

  List<RoomChat> _listRoomChatYouOwn = [];

  List<RoomChat> _listRoomChatHire = [];

  List<RoomChat> get getListRoomChat => _listRoomChat;

  List<RoomChat> get getListRoomChatYouOwn => _listRoomChatYouOwn;

  List<RoomChat> get getListRoomChatHire => _listRoomChatHire;

  RoomChat? get getRoomChat => _roomChat;

  final ChatServices _chatServices = ChatServices();

  Future<void> addMessage(Message message, String userId, String roomOwnerId,
      String roomId, String chatRoomId) async {
    await _chatServices.addMessage(
        message, userId, roomOwnerId, roomId, chatRoomId);

    listMessage.add(message);
    messageController.sink.add(listMessage);
    notifyListeners();
  }

  Future<void> addRoomChat(RoomChat roomChat) async {
    await _chatServices.addRoomChat(roomChat);
    _roomChat = roomChat;
    notifyListeners();
  }

  Future<RoomChat?> getRoomChatFromId(String roomId) async {
    _roomChat = await _chatServices.getRoomChat(roomId);
    return _roomChat;
  }

  Future<RoomChat?> getRoomChatFromRoomId(String id) async{
    return await _chatServices.getRoomChatFromId(id);
  }

  Future<void> getListMessage(String id) async {
    listMessage = await _chatServices.getAllMessage(id);

    messageController.sink.add(listMessage);

    notifyListeners();
    // print(messageController.stream.length.toString());
  }

  Future<bool> checkChatRoomExist(
      String roomId, String roomOwnerId, String userId) async {
    bool result =
        await _chatServices.checkChatRoomExist(roomId, roomOwnerId, userId);
    if (result == true) {
      _roomChat = await _chatServices.getRoomChat(roomId);
    }
    return result;
  }

  Future<List<RoomChat>> getAllRoomChat() async {
    _listRoomChat = await _chatServices.getAllRoomChat();
    print(_listRoomChat.length);
    notifyListeners();
    return _listRoomChat;
  }

  Future<List<RoomChat>> getRoomChatYouOwn(String id) async {
    _listRoomChatYouOwn = await _chatServices.getRoomChatYouOwn(id);

    notifyListeners();
    return _listRoomChatYouOwn;
  }

  Future<List<RoomChat>> getRoomChatHire(String id) async {
    _listRoomChatHire = await _chatServices.getRoomChatYouHire(id);

    notifyListeners();
    return _listRoomChatHire;
  }
}
