import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class User {
  String email;
  String password;

  User({required this.email, required this.password});
}

class UserInfor {
  final String? id;
  final String? userID;
  final String name;
  final DateTime? joinDate;

  final String? avatar;
  final String? backgroundImage;
  final String? address;
  final String? phoneNumber;
  final String? sex;
  final String? city;
  final String? district;
  final String? ward;
  final String? road;
  final int? cityId;
  final int? districtId;
  final int? wardId;
  final double? lat;
  final double? lng;

  UserInfor({
    this.id,
    this.userID,
    required this.name,
    this.joinDate,
    this.avatar,
    this.backgroundImage,
    this.address,
    this.phoneNumber,
    this.sex,
    this.city,
    this.district,
    this.ward,
    this.road,
    this.cityId,
    this.districtId,
    this.wardId,
    this.lat,
    this.lng,
  });

  factory UserInfor.fromJson(Map<String, dynamic> json) {
    return UserInfor(
      id: json['id'],
      userID: json['userID'],
      name: json['name'],
      joinDate: (json['joinDate'] as Timestamp?)?.toDate(),
      avatar: json['avatar'],
      backgroundImage: json['backgroundImage'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      sex: json['sex'],
      city: json['city'],
      district: json['district'],
      ward: json['ward'],
      cityId: json['cityId'],
      districtId: json['districtId'],
      wardId: json['wardId'],
      lat : json['lat'],
      lng : json ['lng'],
      road: json['road'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'name': name,
      'joinDate': joinDate == null ? null : Timestamp.fromDate(joinDate!),
      'avatar': avatar,
      'backgroundImage': backgroundImage,
      'address': address,
      'phoneNumber': phoneNumber,
      'sex': sex,
      'city': city,
      'district': district,
      'ward': ward,
      'cityId': cityId,
      'districtId': districtId,
      'wardId': wardId,
      'lat' : lat,
      'lng' : lng,
      'road' : road
    };
  }
}
