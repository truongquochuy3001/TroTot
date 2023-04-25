import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:tro_tot_app/models/room_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:tro_tot_app/views/login_page.dart';

import 'package:tro_tot_app/views/post_page.dart';

import 'package:tro_tot_app/views/room_detail.dart';

class ListRoomPage extends StatefulWidget {
  const ListRoomPage({super.key});

  @override
  State<ListRoomPage> createState() => _ListRoomPageState();
}

class _ListRoomPageState extends State<ListRoomPage> {
  late RoomViewModel room1;

  late Future _getRooms;
   late Future  _getSearchRooms;
  bool isClickSearch = false;
  TextEditingController? searchKey;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListRoomPage(),
            ));
      } else if (index == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostPage(),
            ));
      } else if (index == 2) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostPage(),
            ));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getRooms = context.read<RoomViewModel>().getAllRoom();
    // _getSearchRooms = context.read<RoomViewModel>().searchRoom("yh");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomViewModel>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 245, 250),
          body: SafeArea(
            child: FutureBuilder(
              // future: _getSearchRooms,
              future: searchKey?.text == null ? _getRooms : _getSearchRooms,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text("Lỗi: ${snapshot.error}");
                } else {
                  print("${searchKey?.text} aaaaaaaa");
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _searchFeild(context),
                        _sortAndArea(context),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 16.w, right: 16.w),
                            child:
                            searchKey ==null ?
                            _listRoom(context, value.rooms): _listRoom(context, value.searchRooms)),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                  color: Colors.blue,
                ),
                label: "Trang chủ",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.article_outlined,
                    color: Colors.blue,
                  ),
                  label: "Quản lý tin"),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.post_add_outlined,
                  color: Colors.blue,
                ),
                label: "Đăng tin",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: Colors.blue,
                  ),
                  label: "Tài khoản"),
            ],
          ),
        );
      },
    );
  }

  Widget _searchFeild(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: const Color.fromARGB(255, 26, 148, 255),
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      height: 56.h,
      width: 360.w,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _searchPage(context),
                  ),
                );
              },
              child: Text(
                "Nhấn vào đây để search",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.message,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  Widget _searchPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        elevation: 0,
        titleSpacing: 1.w,
        title: TextFormField(
          controller: searchKey,
          style: const TextStyle(
            color: Colors.black,
          ),
          onChanged: (value) {
            searchKey =
                value.isNotEmpty ? TextEditingController(text: value) : null;
          },
          onEditingComplete: () {
            setState(() {
              _getSearchRooms =
                  context.read<RoomViewModel>().searchRoom(searchKey!.text);
              Navigator.pop(context, searchKey?.text);
              print("aaa");
              print(searchKey?.text);
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
            // enabledBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(16.w),
            //
            // ),
          ),
        ),
      ),
    );
  }

  Widget _sortAndArea(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.w),
                  side: BorderSide(
                      color: const Color.fromARGB(255, 221, 221, 227),
                      width: 1.w)),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Icon(
                  Icons.filter_alt_outlined,
                  color: const Color.fromARGB(255, 128, 128, 137),
                  size: 20.w,
                ),
                Text(
                  "Lọc",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 39, 39, 42),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.w),
                    side: BorderSide(
                        width: 1.w,
                        color: const Color.fromARGB(255, 26, 148, 255)))),
            onPressed: () {},
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 20.w,
                  color: const Color.fromARGB(255, 26, 148, 255),
                ),
                Text(
                  "Vị trí",
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14.sp,
                      color: const Color.fromARGB(255, 26, 148, 255)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listRoom(BuildContext context, List<Room> roomData) {
    return ListView.builder(
      itemCount: roomData.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        Room room = roomData[index];
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomDetailPage(id: room.id!),
                  ));
            },
            child: _roomInfor(context, room));
      },
    );
  }

  Widget _roomInfor(BuildContext context, Room room) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.w),
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      width: 328.w,
      height: 145.h,
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Image.network(
            room.image,
            width: 120.w,
            height: 120.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 10.w,
          ),
          SizedBox(
            width: 172.w,
            height: 120.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 172.w,
                        child: Text(
                          room.name,
                          maxLines: 2,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16.sp,
                            color: const Color.fromARGB(255, 39, 39, 42),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        "${room.size} m2",
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 128, 128, 137),
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        "${room.price}/Tháng",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 26, 148, 255),
                            fontSize: 14.sp,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.account_circle_rounded,
                      size: 12.w,
                      color: const Color.fromARGB(255, 128, 128, 137),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      "12 gio truoc",
                      softWrap: true,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 10.sp,
                        color: const Color.fromARGB(255, 128, 128, 137),
                      ),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Expanded(
                      child: Text(
                        room.address,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color.fromARGB(255, 128, 128, 137),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
