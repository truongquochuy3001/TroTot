import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:tro_tot_app/models/room_model.dart';
import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:tro_tot_app/view_models.dart/user_view_model.dart';
import 'package:tro_tot_app/views/chat_page.dart';
import 'package:tro_tot_app/views/location_page.dart';
import 'package:tro_tot_app/views/login_page.dart';
import 'package:tro_tot_app/views/post_manage_page.dart';

import 'package:tro_tot_app/views/post_page.dart';
import 'package:tro_tot_app/views/profile_page.dart';

import 'package:tro_tot_app/views/room_detail.dart';
import 'package:tro_tot_app/views/sort_page.dart';

import '../models/user_model.dart';
import '../view_models.dart/province_view_model.dart';

class ListRoomPage extends StatefulWidget {
  const ListRoomPage({super.key});

  @override
  State<ListRoomPage> createState() => _ListRoomPageState();
}

class _ListRoomPageState extends State<ListRoomPage> {
  RoomViewModel? room1;
  var formatter = NumberFormat('#,###');
  DateTime now = DateTime.now();

  late Future _getRooms;
  late Future _getSearchRoomLocal;
  late Future _getSortRooms;
  late RoomViewModel _roomViewModel;
  late AuthViewModel _authViewModel;

  bool isClickSearch = false;
  bool sort = false;
  TextEditingController? searchKey;

  int _selectedIndex = 0;

  // Chuyển hướng trang ở BottomNavigationBar
  _onItemTapped(int index, UserViewModel user) async {
    _selectedIndex = index;
    if (index == 0) {
      _roomViewModel.sortRooms.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListRoomPage(),
          ));
    } else if (index == 1) {

      if (user.user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostManagePage(),
            )).then((value) {
          setState(() {});
        });
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>const  LoginScreen(),
            ));
      }
    } else if (index == 2) {
      if (user.user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostPage(),
            )).then((value) {
          setState(() {});
        });
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      }
    } else {
      if (user.user != null) {
        // print(user.user!.id);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      }
    }
    ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getRooms = context.read<RoomViewModel>().getAllRoom();
    _roomViewModel = context.read<RoomViewModel>();
    _authViewModel = context.read<AuthViewModel>();
    // _getSearchRooms = context.read<RoomViewModel>().searchRoom("yh");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RoomViewModel, UserViewModel>(
      builder: (context, value,value2, child) {

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 245, 250),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _searchField(context, value.searchHistory),
                  _sortAndArea(context),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 16.w, right: 16.w),
                      child: value.sortRooms.isNotEmpty
                          ? _listRoom(context, value.sortRooms)
                          : searchKey == null
                          ? _listRoom(context, value.rooms)
                          : _listRoom(
                          context, value.searchRoomsLocal)),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Consumer<UserViewModel>(
            builder: (context, user, child) => BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              onTap: (value) {
                _onItemTapped(value, user);
              },
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
          ),
        );
      },
    );
  }

  Widget _searchField(BuildContext context, List<String> history) {
    return Consumer<UserViewModel>(
      builder: (context, value, child) =>  Container(
        alignment: Alignment.center,
        color: const Color.fromARGB(255, 26, 148, 255),
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        height: 56.h,
        width: 360.w,
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _searchPage(context, history),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        searchKey == null
                            ? "Nhấn vào đây để search"
                            : searchKey!.text,
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 24.w,
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  )),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    if (value.user != null)
                    {Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChatScreen(id :value.user!.id!),));}
                    else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                    }
                  },
                  icon: const Icon(
                    Icons.message,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _searchPage(BuildContext context, List<String> history) {
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
              _getSearchRoomLocal = context
                  .read<RoomViewModel>()
                  .searchRoomLocal(searchKey!.text);
              // _getSearchRooms =
              //     context.read<RoomViewModel>().searchRoom(searchKey!.text);

              Navigator.pop(context, searchKey?.text);
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
      body: ListView.separated(
          shrinkWrap: true,
          reverse: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _getSearchRoomLocal = context
                      .read<RoomViewModel>()
                      .searchRoomLocal(history[index]);
                  // _getSearchRooms =
                  //     context.read<RoomViewModel>().searchRoom(searchKey!.text);

                  Navigator.pop(context, history[index]);
                });
              },
              child: Padding(
                padding: EdgeInsets.only(left: 14.w),
                child: Text(
                  history[index],
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: history.length),
    );
  }

  Widget _sortAndArea(BuildContext context) {
    return Consumer<ProvinceViewModel>(
      builder: (context, value, child) => Container(
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
              onPressed: () {
                setState(() {
                  value.selectedCity = null;
                  value.selectedDistrict = null;
                  value.selectedWard = null;
                  value.cityId = null;
                  value.districtId = null;
                  value.wardId = null;

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SortPage(),
                      ));
                });
              },
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationPage(),
                    ));
              },
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
      ),
    );
  }

  Widget _listRoom(BuildContext context, List<Room> roomData) {
    return (roomData.isEmpty || roomData == [])
        ? Center(
            child: Text(
              "Không tìm thấy kết quả",
              style: TextStyle(fontSize: 14.sp),
            ),
          )
        : ListView.builder(
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
                        )).then((value) {setState(() {

                        });});
                  },
                  child: _roomInfor(context, room));
            },
          );
  }

  Widget _roomInfor(BuildContext context, Room room) {
    // lấy khoảng cách giữa thời gian hiện tại và thời gian đăng bài
    Duration difference = now.difference(room.postingDate!);

    // mặc định thời gian chênh lệnh ban đầu là số giây
    var time = difference.inSeconds;
    String timeType = "giây trước";

    // Xác định thời gian chênh lệch là năm, tháng, ngày, giờ, phút, giây
    if (time > 60) {
      //nếu thời gian chênh lệch lớn hơn 60 giây thì đổi sang phút
      time = difference.inMinutes;
      timeType = "phút trước";
      if (time > 60) {
        //nếu thời gian chênh lệch lớn hơn 60 phút thì đổi sang giờ
        time = difference.inHours;
        timeType = "giờ trước";
        if (time > 24) {
          //nếu lớn hơn 24 giờ thì đổi sang ngày
          time = difference.inDays;
          timeType = "ngày trước";
          if (time > 30) {
            // nếu lớn hơn 30 ngày (tạm thời chưa xử lý các tháng 28,29 hoặc 31 ngày) thì đổi sang tháng
            time = (time / 30.44).floor();
            timeType = "tháng trước";
            if (time > 12) {
              // nếu lớn hơn 12 tháng thì đổi sang năm
              time = (time / 365.25).floor();
              timeType = "năm trước";
            }
          }
        }
      }
    }
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
                        "${formatter.format(room.price) }/Tháng",
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
                      "$time $timeType",
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
