import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/models/room_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';

class RoomDetailPage extends StatefulWidget {
  final String id;
  const RoomDetailPage({super.key, required this.id});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
  }

  late Future getRoom;

  var _currentPageCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: Text(
            "Cho thue can ho ABC dasdasd",
            style: TextStyle(color: Colors.black, fontSize: 34.sp),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          actions: [
            Icon(
              Icons.more_vert,
              color: Colors.black,
              size: 70.h,
            )
          ],
        ),
        body: SingleChildScrollView(child: Consumer<RoomData>(
          builder: (context, value, child) {
            return FutureBuilder(
              future: value.getRoom(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Lỗi: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Không tìm thấy phòng trọ!'));
                } else {
                  final roomData = snapshot.data;
                  return Column(
                    children: [
                      _carouselImage(context, roomData!),
                      SizedBox(
                        height: 40.h,
                      ),
                      _generalInfo(context, roomData),
                      SizedBox(
                        height: 40.h,
                      ),
                      _roomDetail(context),
                      SizedBox(
                        height: 40.h,
                      ),
                      _detailDecribe(context, roomData),
                      SizedBox(
                        height: 40.h,
                      ),
                      _Location(context),
                      SizedBox(
                        height: 40.h,
                      ),
                      _userInfor(context),
                      SizedBox(
                        height: 40.h,
                      ),
                      _chatWithSaler(context),
                      SizedBox(
                        height: 40.h,
                      ),
                      _otherPost(context),
                      SizedBox(
                        height: 40.h,
                      ),
                    ],
                  );
                }
              },
            );
          },
        )));
  }

  Widget _titleText(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 46.sp),
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
            aspectRatio: 16 / 10,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentPageCount = index;
              });
            },
            autoPlay: true,
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Container(
              width: 1920.w,
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
            width: 100.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                "${_currentPageCount + 1}/${roomData.images.length}",
                style: TextStyle(color: Colors.white, fontSize: 36.sp),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _generalInfo(BuildContext context, Room roomData) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      // color: Colors.green,
      width: 1920.w,
      // height: 800.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(context, roomData.name),
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: roomData.price.toString(),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 42.sp,
                        fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(
                        text: roomData.price.toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 30.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        color: Colors.red,
                        size: 60.w,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "Lưu",
                        style: TextStyle(fontSize: 38.sp),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.grey,
                  size: 50.w,
                ),
                Expanded(
                  child: Text(
                    roomData.address,
                    style: TextStyle(color: Colors.grey, fontSize: 36.sp),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 50.w,
                  color: Colors.grey,
                ),
                Text(
                  roomData.postingDate.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 36.sp),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _roomDetail(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      width: 1920.w,
      // color: Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(context, "Đặc điểm bất động sản"),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              children: [
                Icon(
                  Icons.zoom_out_map,
                  color: Colors.grey,
                  size: 50.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                RichText(
                  text: TextSpan(
                      text: "Dien tich : ",
                      style: TextStyle(fontSize: 36.sp, color: Colors.black),
                      children: [
                        TextSpan(
                            text: "25 m2",
                            style:
                                TextStyle(fontSize: 36.sp, color: Colors.black))
                      ]),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.key_outlined,
                  color: Colors.grey,
                  size: 50.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                RichText(
                  text: TextSpan(
                      text: "So tien coc :",
                      style: TextStyle(fontSize: 36.sp, color: Colors.black),
                      children: [
                        TextSpan(
                            text: "3.000.000 d",
                            style:
                                TextStyle(fontSize: 36.sp, color: Colors.black))
                      ]),
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
      width: 1920.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(context, "Mô tả chi tiết"),
          SizedBox(
            height: 15.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Text(
              roomData.description,
              maxLines: null,
              style: TextStyle(fontSize: 36.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                "Liên hệ ngay: " + "0123456789",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: 36.sp),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _Location(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
      ),
      width: 1920.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(context, "Địa điểm bất động sản"),
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            width: 1920.w,
            height: 300.h,
            child: Image.asset(
              "assets/images/maps.jpg",
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }

  Widget _userInfor(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      width: 1920.w,
      // color: Colors.grey,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(
              "assets/images/avatar.png",
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Khanh",
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 46.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 40.w,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      "Cá nhân",
                      style: TextStyle(color: Colors.grey, fontSize: 36.sp),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.brightness_1,
                      color: Colors.grey,
                      size: 40.w,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      "Hoat dong 30 phut truoc",
                      style: TextStyle(color: Colors.grey, fontSize: 36.sp),
                    )
                  ],
                )
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.all(8.w),
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26.w),
                  side: BorderSide(width: 2.w, color: Colors.orange)),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Text(
                  "Xem trang",
                  style: TextStyle(color: Colors.orange, fontSize: 36.sp),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.yellow,
                  size: 40.w,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _chatWithSaler(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      // color: Colors.grey,
      width: 1920.w,
      height: 120.h,
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
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 201, 201, 201)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 36.sp,
        ),
        softWrap: true,
      ),
    );
  }

  Widget _otherPost(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      width: 1920.w,
      height: 750.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(context, "Tin rao khác của ABC"),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _otherRoomDetail(context),
                _otherRoomDetail(context),
                _otherRoomDetail(context),
                _otherRoomDetail(context),
                _otherRoomDetail(context),
              ],
            ),
          ),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Xem tất cả",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  WidgetSpan(
                      child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.blue,
                    size: 46.w,
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _otherRoomDetail(BuildContext context) {
    return Container(
      width: 300.w,
      height: 400.h,
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
            height: 300.h,
            child: Image.asset(
              "assets/images/image.jpg",
              fit: BoxFit.fill,
            ),
          ),
          Text(
            "Cho thue tro gan DHH",
            style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w500),
          ),
          Text(
            "30 m2",
            style: TextStyle(fontSize: 34.sp, color: Colors.grey),
          ),
          Text(
            "700.000d/thang",
            style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
                fontSize: 40.sp),
          ),
          Text(
            "Tp.Hue",
            style: TextStyle(fontSize: 36.sp, color: Colors.grey),
          ),
        ],
      ),
    );
    ;
  }
}
