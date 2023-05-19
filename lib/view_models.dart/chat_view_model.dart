import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:tro_tot_app/models/chat_model.dart';
import 'package:tro_tot_app/services/chat_services.dart';

class ChatViewModel extends ChangeNotifier{
  StreamController<List<Message>> messageController = StreamController<List<Message>>.broadcast();
  List<Message> listMessage = [];

  RoomChat? _roomChat;

  RoomChat? get getRoomChat => _roomChat;

  final ChatServices _chatServices = ChatServices();

  Future<void> addMessage(Message message , String userId, String roomOwnerId, String roomId, String chatRoomId) async{
    await _chatServices.addMessage(message, userId, roomOwnerId, roomId, chatRoomId);

    listMessage.add(message);
    messageController.sink.add(listMessage);


  }

  Future<void> addRoomChat(RoomChat roomChat) async{

    await _chatServices.addRoomChat(roomChat);


    notifyListeners();
  }

  Future<RoomChat?> getRoomChatFromId(String roomId) async{
    _roomChat = await _chatServices.getRoomChat(roomId);
    return _roomChat;
  }

  Future<void> getListMessage(String id ) async {
    listMessage = await _chatServices.getAllMessage(id);
    print(listMessage.length);
    messageController.sink.add(listMessage);
    // print(messageController.stream.length.toString());
  }
}