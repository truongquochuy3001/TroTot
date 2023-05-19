
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomChat {
  final String? id;
  final String? roomId;
  final String roomOwnerId;
  final String userId;
  final List<Message>? messages;

  RoomChat({
     this.id,
     this.roomId,
    required this.roomOwnerId,
    required this.userId,
     this.messages,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'roomOwnerId': roomOwnerId,
      'userId': userId,
      'messages': messages?.map((message) => message.toJson()).toList(),
    };
  }

  // factory RoomChat.fromJson(Map<String, dynamic> json) {
  //   return RoomChat(
  //     id: json['id'],
  //     roomId: json['roomId'],
  //     roomOwnerId: json['roomOwnerId'],
  //     userId: json['userId'],
  //     messages: List<Message>.from(json['messages'].map((messageJson) => Message.fromJson(messageJson))),
  //   );
  // }
  factory RoomChat.fromJson(Map<String, dynamic> json) {
    List<Message>? messages;

    if (json['messages'] != null) {
      messages = List<Message>.from(json['messages'].map((messageJson) => Message.fromJson(messageJson)));
    }

    return RoomChat(
      id: json['id'],
      roomId: json['roomId'],
      roomOwnerId: json['roomOwnerId'],
      userId: json['userId'],
      messages: messages,
    );
  }

}
class Message {
  final String? content;
  final String? image;
  final double? lat;
  final double? lng;
  final String senderId;
  DateTime time;

  Message({
    this.content,
    this.image,
    this.lat,
    this.lng,
    required this.senderId,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'image': image,
      'lat': lat,
      'lng': lng,
      'senderId': senderId,
      'time': Timestamp.fromDate(time)
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      image: json['image'],
      lat: json['lat'],
      lng: json['lng'],
      senderId: json['senderId'],
      time: (json['time'] as Timestamp).toDate(),
    );
  }
}