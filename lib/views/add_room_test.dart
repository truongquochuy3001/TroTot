// import 'dart:core';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
//
// class AddRoomTestPage extends StatefulWidget {
//   const AddRoomTestPage({super.key});
//
//   @override
//   State<AddRoomTestPage> createState() => _AddRoomTestPageState();
// }
//
// class _AddRoomTestPageState extends State<AddRoomTestPage> {
//   @override
//   Widget build(BuildContext context) {
//     RoomData add = RoomData();
//     String name = "";
//     String address = "";
//     int price = 0;
//     String roomType = "";
//     int size = 0;
//     List<String> images = [];
//     String image = "";
//     String postingDate = "Ngày hôm qua";
//     bool status = true;
//     String description = "";
//     bool furniture = true;
//     String id = "0";
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'name',
//                 ),
//                 onChanged: (value) => name = value,
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'address',
//                 ),
//                 onChanged: (value) => address = value,
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'price',
//                 ),
//                 onChanged: (value) => price = value as int,
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'roomtype',
//                 ),
//                 onChanged: (value) => roomType = value,
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'size',
//                 ),
//                 onChanged: (value) => size = value as int,
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'image',
//                 ),
//                 onChanged: (value) => image = value,
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'des',
//                 ),
//                 onChanged: (value) => description = value,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                   onPressed: () {
//                     add.addRoom(name, address, price, roomType, size, images,
//                         image, postingDate, status, description, furniture, id);
//                   },
//                   child: Text("them"))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
