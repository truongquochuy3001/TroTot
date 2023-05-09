import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String password;

  User({required this.email, required this.password});
}

class UserInfor {
  final String? id;
  final String name;
  final DateTime? joinDate;
  final DateTime? birthDate;
  final String? avatar;
  final String? backgroundImage;
  final String? address;
  final String? phoneNumber;
  final String? sex;

  UserInfor(
      {this.id,
      required this.name,
      this.joinDate,
      this.birthDate,
      this.avatar,
      this.backgroundImage,
      this.address,
      this.phoneNumber,
      this.sex});

  factory UserInfor.fromJson(Map<String, dynamic> json) {
    return UserInfor(
      id: json['id'],
      name: json['name'],
      joinDate: (json['joinDate'] as Timestamp?)?.toDate(),
      birthDate: (json['birthDate'] as Timestamp?)?.toDate(),
      avatar: json['avatar'],
      backgroundImage: json['backgroundImage'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      sex: json['sex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'joinDate': joinDate == null ? null : Timestamp.fromDate(joinDate!),
      'birthDate': birthDate == null ? null : Timestamp.fromDate(birthDate!),
      'avatar': avatar,
      'backgroundImage': backgroundImage,
      'address': address,
      'phoneNumber': phoneNumber,
      'sex': sex,
    };
  }
}
