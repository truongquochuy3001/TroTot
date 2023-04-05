import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String? id;
  final String name;
  final String address;
  final int price;
  final String roomType;
  final int capacity;
  final List<String> images;
  final String image;
  final String postingDate;
  final bool status;
  final String description;
  final bool furniture;

  Room(
      {this.id,
      required this.name,
      required this.address,
      required this.price,
      required this.roomType,
      required this.capacity,
      required this.images,
      required this.image,
      required this.postingDate,
      required this.status,
      required this.description,
      required this.furniture});

  factory Room.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['RoomImages'] != null) {
      for (var image in json['RoomImages']) {
        images.add(image);
      }
    }

    return Room(
      id: json['RoomId'],
      name: json['RoomTitle'],
      address: json['RoomAddr'],
      price: json['RoomPrice'],
      roomType: json['RoomType'],
      capacity: json['RoomSize'],
      images: images,
      image: json['RoomImage'],
      postingDate: json['RoomPostDate'],
      status: json['RoomStatus'],
      description: json['RoomDecribe'],
      furniture: json['RoomFurniture'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'price': price,
      'roomType': roomType,
      'capacity': capacity,
      'images': images,
      'image': image,
      'postingDate': postingDate,
      'status': status,
      'description': description,
      'furniture': furniture,
    };
  }

  Future<void> addData() async {
    final collectionRef = FirebaseFirestore.instance.collection('Room');
    final docRef =
        collectionRef.doc(id); // sử dụng trường id để tạo DocumentReference
    await docRef.set(toMap());
  }

  Future<String> addDataAndGetId() async {
    final collectionRef = FirebaseFirestore.instance.collection('Room');
    final docRef = await collectionRef
        .add(toMap()); // sử dụng phương thức add() để tạo một tài liệu mới
    return docRef.id;
  }
}
