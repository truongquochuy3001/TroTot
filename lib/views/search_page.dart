// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../models/room_model.dart';
// import '../view_models.dart/room_view_model.dart';
//
// class SearchPage extends StatefulWidget {
//   late Future rooms;
//
//   SearchPage({required this.rooms});
//
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();
//   late Future _searchResults;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchResults = widget.rooms;
//   }
//
//   void _performSearch() {
//     final searchQuery = _searchController.text;
//     setState(() {
//       _searchResults = context.read<RoomViewModel>().searchRoom(searchQuery);
//     });
//   }
//
//   void _closeSearchPage() {
//     Navigator.pop(context, _searchResults);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//
//               Navigator.pop(context);
//
//
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//             )),
//         elevation: 0,
//         titleSpacing: 1.w,
//         title: TextFormField(
//           controller: searchKey,
//           style: const TextStyle(
//             color: Colors.black,
//           ),
//           onChanged: (value) {
//             searchKey = value.isNotEmpty ? TextEditingController(text: value) : null;
//           },
//           onEditingComplete: () {
//             setState(() {
//               Navigator.pop(context, searchKey?.text);
//               print("aaa");
//               print(searchKey?.text);
//             });
//
//           },
//
//
//           decoration: InputDecoration(
//
//             filled: true,
//             fillColor: Colors.white,
//             hintText: "Search",
//             hintStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
//             // enabledBorder: OutlineInputBorder(
//             //     borderRadius: BorderRadius.circular(16.w),
//             //
//             // ),
//           ),
//         ),
//       ),
//     );
//   }
// }
