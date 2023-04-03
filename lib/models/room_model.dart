import 'dart:core';

class Room {
  final int id;
  final String name;
  final String address;
  final int price;
  final String roomType;
  final int capacity;
  final List<String> images;
  final DateTime postingDate;
  final bool status;
  final String description;

  Room({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    required this.roomType,
    required this.capacity,
    required this.images,
    required this.postingDate,
    required this.status,
    required this.description,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['RoomImage'] != null) {
      for (var image in json['RoomImage']) {
        images.add(image);
      }
    }

    return Room(
      id: json['Document ID'],
      name: json['RoomTitle'],
      address: json['RoomAddr'],
      price: json['RoomPrice'],
      roomType: json['RoomType'],
      capacity: json['RoomCapacity'],
      images: images,
      postingDate: DateTime.parse(json['RoomPostDate']),
      status: json['RoomStatus'],
      description: json['RoomDecribe'],
    );
  }
}
