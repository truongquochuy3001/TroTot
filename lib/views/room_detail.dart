import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tro_tot_app/models/chat_model.dart';
import 'package:tro_tot_app/view_models.dart/chat_view_model.dart';
import 'package:tro_tot_app/views/chat_detail.dart';
import 'package:tro_tot_app/views/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/models/room_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:tro_tot_app/view_models.dart/user_view_model.dart';
import 'package:tro_tot_app/views/room_owner_page.dart';

import '../models/user_model.dart';

class RoomDetailPage extends StatefulWidget {
  final String id;

  const RoomDetailPage({super.key, required this.id});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  var formatter = NumberFormat('#,###');

  bool _isMyLocationEnabled = false;
  late GoogleMapController _mapController;
  String userId = "";
  late RoomViewModel roomProvider;

  Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  late Future getRoomOwner;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRoom =
        context.read<RoomViewModel>().getRoom(widget.id).then((value) async {
      await context.read<UserViewModel>().getRoomOwner(value!.userId);
      return value;
    });
    roomProvider = context.read<RoomViewModel>();
  }

  late Future getRoom;

  var _currentPageCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 245, 250),
        appBar: AppBar(
          foregroundColor: Colors.blue,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: Text(
            "Chi tiết",
            style: TextStyle(color: Colors.black, fontSize: 16.sp),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          actions: [
            Icon(
              Icons.more_vert,
              color: Colors.black,
              size: 12.h,
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Consumer2<RoomViewModel, UserViewModel>(
          builder: (context, value, value2, child) => FutureBuilder(
            future: getRoom,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Lỗi: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Center(child: Text('Không tìm thấy phòng trọ!'));
              } else {
                final roomData = snapshot.data;
                Room room = snapshot.data;

                // cai ham ni lam rang de han await
                // value2.getRoomOwner(room.userId);

                return Column(
                  children: [
                    _carouselImage(context, roomData!),
                    SizedBox(
                      height: 10.h,
                    ),
                    _generalInfo(context, roomData!),
                    SizedBox(
                      height: 10.h,
                    ),
                    _roomDetail(context, roomData),
                    SizedBox(
                      height: 10.h,
                    ),
                    _detailDecribe(context, roomData),
                    SizedBox(
                      height: 10.h,
                    ),
                    _location(context, roomData),
                    SizedBox(
                      height: 10.h,
                    ),
                    _userInfor(context, roomData),
                    SizedBox(
                      height: 10.h,
                    ),
                    value2.roomOwner!.id != FirebaseAuth.instance.currentUser!.uid ?
                    _chatWithSaler(context) : SizedBox(),
                    SizedBox(
                      height: 10.h,
                    ),
                    _otherPost(context, roomData),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                );
              }
            },
          ),
        )));
  }

  Widget _titleText(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
    );
  }

  Widget _carouselImage(BuildContext context, Room roomData) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: roomData.images.length,
          // itemCount: roomData["RoomImages"].length,
          options: CarouselOptions(
            aspectRatio: 16 / 12,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPageCount = index;
              });
            },
            // autoPlay: true,
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Container(
              width: 360.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(roomData.images[index]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 12.h,
          child: Container(
            width: 30.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                "${_currentPageCount + 1}/${roomData.images.length}",
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _generalInfo(BuildContext context, Room roomData) {
    return Container(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      // color: Colors.green,
      width: 360.w,
      // height: 800.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(context, roomData.name),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: formatter.format(roomData.price).toString(),
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: "đ/tháng",
                        style: TextStyle(color: Colors.blue, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   child: Row(
                //     children: [
                //       Icon(
                //         Icons.favorite_outline,
                //         color: Colors.blue,
                //         size: 12.w,
                //       ),
                //       SizedBox(
                //         width: 8.w,
                //       ),
                //       Text(
                //         "Lưu",
                //         style: TextStyle(fontSize: 12.sp),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey,
                  size: 12.w,
                ),
                Expanded(
                  child: Text(
                    roomData.address,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 12.w,
                  color: Colors.grey,
                ),
                Text(
                  roomData.postingDate.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _roomDetail(BuildContext context, Room roomData) {
    return Container(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      width: 360.w,
      // color: Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(context, "Đặc điểm bất động sản"),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            child: Row(
              children: [
                Icon(
                  Icons.zoom_out_map,
                  color: Colors.grey,
                  size: 12.w,
                ),
                SizedBox(
                  width: 12.w,
                ),
                RichText(
                  text: TextSpan(
                      text: "Diện tích : ",
                      style: TextStyle(fontSize: 12.sp, color: Colors.black),
                      children: [
                        TextSpan(
                            text: roomData.size.toString(),
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.black))
                      ]),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.w,
              right: 12.w,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.key_outlined,
                  color: Colors.grey,
                  size: 12.w,
                ),
                SizedBox(
                  width: 12.w,
                ),
                RichText(
                  text: TextSpan(
                    text: "Số tiền cọc : ",
                    style: TextStyle(fontSize: 12.sp, color: Colors.black),
                    children: [
                      roomData.deposit == null
                          ? TextSpan(
                              text: "0 đ",
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black))
                          : TextSpan(
                              text: "${roomData.deposit.toString()} đ",
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailDecribe(BuildContext context, Room roomData) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      width: 360.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(context, "Mô tả chi tiết"),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w),
            child: Text(
              roomData.description,
              maxLines: null,
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
          Consumer<UserViewModel>(
              builder: (context, value, child) =>
                  value.roomOwner!.phoneNumber != null
                      ? Padding(
                          padding: EdgeInsets.only(left: 12.w, right: 12.w),
                          child: GestureDetector(
                            onTap: () async {
                              await launchPhoneDialer(
                                  value.roomOwner!.phoneNumber!);
                            },
                            child: Text(
                              "Liên hệ ngay: ${value.roomOwner!.phoneNumber}",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  fontSize: 12.sp),
                            ),
                          ),
                        )
                      : const SizedBox())
        ],
      ),
    );
  }

  Widget _location(BuildContext context, Room roomData) {
    return Container(
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
      ),
      width: 360.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(context, "Địa điểm bất động sản"),
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            width: 360.w,
            height: 80.h,
            // child: Image.asset(
            //   "assets/images/maps.jpg",
            //   fit: BoxFit.cover,
            // ),
            child: GoogleMap(
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                markers: {
                  Marker(
                      markerId: MarkerId(''),
                      position: LatLng(roomData.latitude, roomData.longitude))
                },
                // markers: Set<Marker>.of(Marker(markerId: markerId)),
                mapToolbarEnabled: true,
                initialCameraPosition: CameraPosition(
                    zoom: 13,
                    target: LatLng(roomData.latitude, roomData.longitude))),
          )
        ],
      ),
    );
  }

  Widget _userInfor(BuildContext context, Room roomData) {
    return Consumer<UserViewModel>(
      builder: (context, value, child) => Container(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        width: 360.w,
        // color: Colors.grey,
        child: Row(
          children: [
            value.roomOwner!.avatar == null
                ? const CircleAvatar(
                    foregroundImage: AssetImage("assets/images/avatar.jpg"),
                  )
                : CircleAvatar(
                    foregroundImage: NetworkImage(value.roomOwner!.avatar!),
                  ),
            SizedBox(
              width: 15.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.roomOwner!.name,
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 12.w,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "Cá nhân",
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      )
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.brightness_1,
                  //       color: Colors.grey,
                  //       size: 16.w,
                  //     ),
                  //     SizedBox(
                  //       width: 8.w,
                  //     ),
                  //     Text(
                  //       "Hoat dong 30 phut truoc",
                  //       style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
            Consumer<UserViewModel>(
              builder: (context, value, child) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.all(8.w),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.w),
                      side: BorderSide(width: 2.w, color: Colors.blue)),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RoomOwnerPage(id: roomData.userId),
                      ));
                },
                child: Row(
                  children: [
                    Text(
                      "Xem trang",
                      style: TextStyle(color: Colors.blue, fontSize: 12.sp),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.blue,
                      size: 16.w,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _chatWithSaler(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      // color: Colors.grey,
      width: 360.w,
      height: 50.h,
      // height: 100.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(context, "Chat với người bán hàng"),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _commonAsk(context, "Căn hộ này còn không ạ"),
                _commonAsk(context, "Thời hạn thuê tối đa là bao lâu"),
                _commonAsk(context, "Thời gian thuê tối thiểu là bao lâu"),
                _commonAsk(context, "Căn hộ có sẵn nội thất chưa ạ"),
                _commonAsk(context, "Có thêm chi phí phát sinh gì nữa không"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _commonAsk(BuildContext context, String text) {
    return Consumer2<ChatViewModel, UserViewModel>(
      builder: (context, value, value2, child) => GestureDetector(
        onTap: () async {
          print(userId);
          if (value2.user != null) {
            if (await value.checkChatRoomExist(
                widget.id, value2.roomOwner!.id!, value2.user!.id!)) {
              if ((value.getRoomChat!.roomId == widget.id) ||
                  (value.getRoomChat!.roomOwnerId ==
                      value2.roomOwner!.id) ||
                  (value.getRoomChat!.userId == value2.user!.id)) {
                Message message = Message(
                    senderId: value2.user!.id!,
                    time: DateTime.now(),
                    content: text);
                await value
                    .addMessage(message, userId, value2.roomOwner!.id!,
                        widget.id, value.getRoomChat!.id!)
                    .whenComplete(
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatDetailPage(id: value.getRoomChat!.id!, userId : value.getRoomChat!.userId, roomOwnerId : value.getRoomChat!.roomOwnerId, roomId : value.getRoomChat!.roomId! ),
                        ),
                      ).then((value) {
                        setState(() {});
                      }),
                    );
              }
            } else {
              RoomChat roomChat = RoomChat(
                  roomOwnerId: value2.roomOwner!.id!,
                  userId: value2.user!.id!,
                  roomId: widget.id);
              Message message = Message(
                  senderId: value2.user!.id!,
                  time: DateTime.now(),
                  content: text);

              await value.addRoomChat(roomChat);
              await value.getRoomChatFromId(widget.id);
              await value
                  .addMessage(message, userId, value2.roomOwner!.id!,
                      widget.id, value.getRoomChat!.id!)
                  .whenComplete(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatDetailPage(id: value.getRoomChat!.id!, userId : value.getRoomChat!.userId, roomOwnerId : value.getRoomChat!.roomOwnerId, roomId : value.getRoomChat!.roomId! ),
                      ),
                    ).then((value) {setState(() {

                    });}),
                  );
            }
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: 12.w, right: 12.w),
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 12.w, right: 12.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(255, 217, 217, 217)),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
            ),
            softWrap: true,
          ),
        ),
      ),
    );
  }

  Widget _otherPost(BuildContext context, Room roomData) {
    Future getOtherRoom = roomProvider.getRoomsUser(roomData.userId);

    return FutureBuilder(
      future: roomProvider.getRoomsUser(roomData.userId),
      builder: (context, snapshot) {
        List<Room> rooms = roomProvider.userRooms;
        return Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          width: 360.w,
          height: 220.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleText(context, "Tin rao khác"),
              SizedBox(
                height: 15.h,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    Room room = rooms[index];
                    return _otherRoomDetail(context, room);
                  },
                ),
              ),
              // Center(
              //   child: RichText(
              //     text: TextSpan(
              //       children: [
              //         TextSpan(
              //           text: "Xem tất cả",
              //           style: TextStyle(
              //             color: Colors.blue,
              //             fontSize: 12.sp,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         WidgetSpan(
              //             child: Icon(
              //               Icons.keyboard_arrow_right,
              //               color: Colors.blue,
              //               size: 16.w,
              //             ))
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _otherRoomDetail(BuildContext context, Room room) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetailPage(id: room.id!),
            ));
      },
      child: Container(
        width: 120.w,
        // height: 100.h,
        // decoration: BoxDecoration(
        //     border: Border.all(
        //       width: 2.w,
        //     ),
        //     borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(8.w),
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 70.h,
              child: Image.network(
                room.image,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              room.name,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
            Text(
              "${room.size.toString()} m2",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
            Text(
              "${formatter.format(room.price).toString()} đ/tháng",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp),
            ),
            Text(
              room.address,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
