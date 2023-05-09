import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/views/edit_post_page.dart';
import 'package:tro_tot_app/views/list_room_page.dart';
import 'package:tro_tot_app/views/room_detail.dart';

import '../models/room_model.dart';
import '../view_models.dart/room_view_model.dart';

class PostManagePage extends StatefulWidget {
  const PostManagePage({Key? key}) : super(key: key);

  @override
  State<PostManagePage> createState() => _PostManagePageState();
}

class _PostManagePageState extends State<PostManagePage> {
  late Future _getRoomsDisplay;
  late Future _getRoomsHide;
  late RoomViewModel _getRoomUser;
  bool isSelected = true;
  bool isHide = false;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  DateTime now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRoomUser = context.read<RoomViewModel>();
    _getRoomsDisplay = context.read<RoomViewModel>().getRoomsUser(userId);
    _getRoomsHide = context.read<RoomViewModel>().getRoomUserHide(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListRoomPage(),
                  ));
            },
          ),
          title: Text(
            "Quản lý tin của bạn",
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 360.w,
                height: 40.h,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = true;
                          });
                        },
                        child: Text(
                          "Đang hiển thị",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected = false;
                          });
                        },
                        child: Text(
                          "Đã ẩn",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 360.w,
                child: AnimatedAlign(
                  alignment:
                      isSelected ? Alignment.centerLeft : Alignment.centerRight,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.blue,
                    width: 180.w,
                    height: 1.h,
                  ),
                ),
              ),
              _listPost(context),
            ],
          ),
        ));
  }

  Widget _listPost(BuildContext context) {
    return Consumer<RoomViewModel>(
      builder: (context, value, child) {
        return FutureBuilder(
          future: isSelected ? _getRoomsDisplay : _getRoomsHide,
          builder: (context, snapshot) {
            List<Room> rooms = isSelected ? value.userRooms : value.userRoomsHide;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:

                  rooms.length,
              itemBuilder: (context, index) {
                Room room = rooms[index];

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
            ;
          },
        );
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
                isSelected == true
                    ? Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditPostPage(id: room.id!),
                                    ));
                              },
                              icon:const  Icon(
                                Icons.edit,
                                color: Colors.blue,
                              )),
                          SizedBox(
                            width: 5.w,
                          ),
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  isHide = true;
                                });

                                await _getRoomUser.hideRoom(room.id!, isHide);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.grey,
                              )),
                          SizedBox(
                            width: 5.w,
                          ),
                          IconButton(
                              onPressed: () {
                                _getRoomUser.deleteRoom(room.id!);
                              },
                              icon:const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isHide = false;
                          });

                          await _getRoomUser.displayRoom(room.id!);
                          setState(() {});
                        },
                        child: Text("Hiện tin")),
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
