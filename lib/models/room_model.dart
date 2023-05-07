import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geohash/geohash.dart';

class Room {
  final String? id;
  final String userId;
  final int? cityId;
  final int? districtId;
  final int? wardId;
  final String name;
  final String address;
  final double price;
  final String roomType;
  final double size;
  final List<String> images;
  final String image;
  final DateTime? postingDate;
  final bool status;
  final String description;
  final bool furniture;
  final double longitude;
  final double latitude;
  final double? deposit;
  final String? road;
  final String? city;
  final String? district;
  final String? ward;
  final String geohash;

  Room(
      {this.id,
      required this.userId,
      this.cityId,
      this.districtId,
      this.wardId,
      required this.name,
      required this.address,
      required this.price,
      required this.roomType,
      required this.size,
      required this.images,
      required this.image,
      required this.postingDate,
      required this.status,
      required this.description,
      required this.furniture,
      required this.longitude,
      required this.latitude,
      this.deposit,
      this.road,
      this.city,
      this.district,
      this.ward})
      : geohash = Geohash.encode(latitude, longitude);

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
        id: json['id'],
        userId: json['userId'],
        cityId: json['cityId'],
        districtId: json['districtId'],
        wardId: json['wardId'],
        name: json['name'],
        address: json['address'],
        price: json['price'],
        roomType: json['roomType'],
        size: json['size'],
        images: List<String>.from(json['images']),
        image: json['image'],
        postingDate: (json['postingDate'] as Timestamp?)?.toDate(),
        status: json['status'],
        description: json['description'],
        furniture: json['furniture'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        deposit: json['deposit'],
        road: json['road'],
        city: json['city'],
        district: json['district'],
        ward: json['ward'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'cityId': cityId,
      'userId': userId,
      'districtId': districtId,
      'wardId': wardId,
      'name': name,
      'address': address,
      'price': price,
      'roomType': roomType,
      'size': size,
      'images': images,
      'image': image,
      'postingDate':
          postingDate != null ? Timestamp.fromDate(postingDate!) : null,
      'status': status,
      'description': description,
      'furniture': furniture,
      'longitude': longitude,
      'latitude': latitude,
      'deposit': deposit,
      'road': road,
      'city': city,
      'district': district,
      'ward' : ward,
      'geohash': geohash,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
