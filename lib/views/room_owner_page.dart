import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:tro_tot_app/view_models.dart/auth_view_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:tro_tot_app/view_models.dart/user_view_model.dart';

import '../models/room_model.dart';
import '../models/user_model.dart';

class RoomOwnerPage extends StatefulWidget {
  final String id;
  const RoomOwnerPage({Key? key, required this.id}) : super(key: key);

  @override
  State<RoomOwnerPage> createState() => _RoomOwnerPageState();
}

class _RoomOwnerPageState extends State<RoomOwnerPage> {
  bool _isSelect = true;
  AuthViewModel _authViewModel = AuthViewModel();
  String userId = "";
  late RoomViewModel _getRoomUser;
  late UserViewModel _getUser;
  // late Future _getUserInfor;
  late Future _getRoomsDisplay;
  late Future _getRoomsHide;
  DateTime now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getRoomUser = context.read<RoomViewModel>();
    _getUser = context.read<UserViewModel>();

      _getRoomsDisplay = context.read<RoomViewModel>().getRoomsUser(widget.id);
      // _getRoomsHide = context.read<RoomViewModel>().getRoomUserHide(_getUser.user!.id!);

    // _getUserInfor = context.read<UserViewModel>().getUser(userId);
    // _getRoomsDisplay = context.read<RoomViewModel>().getRoomsUser(userId);
    // _getRoomsHide = context.read<RoomViewModel>().getRoomUserHide(userId);
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 250),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          // user.name.toString(),
          "Trang cá nhân",
          style: TextStyle(
            fontSize: 20.sp,
          ),
        ),
        // actions: [
        //   Consumer<UserViewModel>(
        //     builder: (context, value, child) =>  IconButton(
        //         onPressed: () {
        //           value.user = null;
        //           _authViewModel.signOut();
        //           Navigator.pop(context);
        //         },
        //         icon: const Icon(Icons.logout)),
        //   )
        // ],
      ),
      body: Consumer<UserViewModel>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _userInfor(context, value.roomOwner!),
                SizedBox(
                  height: 10.h,
                ),
                _listPost(context),
              ],
            ),
          );
        },

      ),
    );
  }

  Widget _userInfor(BuildContext context, UserInfor user) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: 360.w,
          height: 350.h,
          child: Column(
            children: [
              Container(
                width: 360.w,
                height: 80.h,
                color: Colors.grey,
              ),
              SizedBox(
                height: 12.h,
              ),
              _userInforDetail(context, user),
            ],
          ),
        ),
        Positioned(
          left: 14.w,
          top: 50.h,
          child: Stack(
            children: [
              CircleAvatar(
                minRadius: 32.w,
                backgroundImage: AssetImage("assets/images/avatar.jpg"),
              ),
              Positioned(
                  bottom: -10.w,
                  right: -10.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: Size(20.w, 20.w),
                      backgroundColor: Colors.grey,
                      shape: CircleBorder(),
                    ),
                    onPressed: () {},
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 12.w,
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget _userInforDetail(BuildContext context, UserInfor user) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 12.w, right: 12.w),
        width: 360.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //           elevation: 0,
            //           backgroundColor: Colors.white,
            //           shape: RoundedRectangleBorder(
            //               side: BorderSide(color: Colors.blue, width: 1.w),
            //               borderRadius: BorderRadius.circular(8.w))),
            //       onPressed: () {},
            //       child: Text(
            //         "Chỉnh sửa thông tin",
            //         style: TextStyle(color: Colors.black, fontSize: 12.sp),
            //       ),
            //     ),
            //     SizedBox(
            //       width: 12.w,
            //     ),
            //   ],
            // ),
            Text(
              _getUser.roomOwner!.name,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 8.h,
            ),
            // Text(
            //   "Chưa có đánh giá",
            //   style: TextStyle(fontSize: 12.sp),
            // ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              width: 360.w,
              height: 20.h,
              // child: Row(
              //   children: [
              //     Text("Người theo dõi: " + "0",
              //         style: TextStyle(fontSize: 10.sp)),
              //     const VerticalDivider(
              //       color: Colors.black,
              //       thickness: 1,
              //     ),
              //     Text("Đang theo dõi :" + "0",
              //         style: TextStyle(fontSize: 10.sp)),
              //   ],
              // ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 16.w,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  "Đã tham gia: ",
                  style: TextStyle(fontSize: 12.sp),
                ),
                Text(
                  "1 Năm ",
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.w,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  "Địa chỉ: ",
                  style: TextStyle(fontSize: 12.sp),
                ),
                Text(
                  "Chưa cung cấp",
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _listPost(BuildContext context) {
    return Consumer<RoomViewModel>(
      builder: (context, value, child) {
        return FutureBuilder(
          future: _getRoomsDisplay,
          builder: (context, snapshot) {
            List<Room> rooms =
             _getRoomUser.userRooms ;

            return Container(
              width: 360.w,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSelect = true;
                              });
                            },
                            child: Center(
                              child: Text(
                                "Đang hiển thị",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                            )),
                      ),
                      // Expanded(
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       setState(() {
                      //         _isSelect = false;
                      //       });
                      //     },
                      //     child: Center(
                      //       child: Text(
                      //         "Đã đóng",
                      //         style: TextStyle(
                      //             fontSize: 14.sp, fontWeight: FontWeight.w700),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  // SizedBox(
                  //   width: 360.w,
                  //   child: AnimatedAlign(
                  //     alignment: _isSelect
                  //         ? Alignment.centerLeft
                  //         : Alignment.centerRight,
                  //     duration: const Duration(milliseconds: 300),
                  //     child: Container(
                  //       color: Colors.blue,
                  //       width: 180.w,
                  //       height: 1.h,
                  //     ),
                  //   ),
                  // ),
                  ListView.builder(
                    itemCount: rooms.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      Room room = rooms[index];

                      return _roomInfor(context, room);
                    },
                  ),
                  // _moreInfoButton(context)
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _roomInfor(BuildContext context, Room room) {
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
                        "${room.size.toString()}" + " m2",
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
                        "${room.price.toString()}đ/tháng",
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

  Widget _moreInfoButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        onPressed: () {},
        child: Text("Xem them"));
  }
}
