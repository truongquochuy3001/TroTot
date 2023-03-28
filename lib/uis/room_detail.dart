import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoomDetailPage extends StatefulWidget {
  const RoomDetailPage({super.key});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  List<String> listImage = [
    "assets/images/image.jpg",
    "assets/images/image.jpg",
    "assets/images/image.jpg",
  ];
  var _currentPageCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _carouselImage(context),
            SizedBox(
              height: 16.h,
            ),
            _generalInfo(context),
            SizedBox(
              height: 30.h,
            ),
            _roomDetail(context),
            SizedBox(
              height: 30.h,
            ),
            _detailDecribe(context),
            SizedBox(
              height: 30.h,
            ),
            _Location(context),
            SizedBox(
              height: 30.h,
            ),
            _userInfor(context),
            SizedBox(
              height: 30.h,
            ),
            _chatWithSaler(context),
          ],
        ),
      ),
    );
  }

  Widget _carouselImage(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: listImage.length,
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
                  image: AssetImage(listImage[index]),
                  fit: BoxFit.cover,
                ),
              ),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Container(
              //         width: 100.w,
              //         height: 50.h,
              //         decoration: BoxDecoration(
              //           color: Colors.grey,
              //           borderRadius: BorderRadius.circular(18),
              //         ),
              //         child:
              //             Text("${_currentPageCount + 1}/${listImage.length}"))
              //   ],
              // ),
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
                "${_currentPageCount + 1}/${listImage.length}",
                style: TextStyle(color: Colors.white, fontSize: 36.sp),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _generalInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      // color: Colors.green,
      width: 1920.w,
      // height: 800.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cho thue can ho ABC",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 42.sp),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 12.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: "3.5 trieu/thang",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 42.sp,
                      fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: " - 50 m2",
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
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey,
                size: 50.w,
              ),
              Expanded(
                child: Text(
                  "30/137 Dinh Tien Hoang, Phuong Thuan Loc, Thanh Pho Hue ",
                  style: TextStyle(color: Colors.grey, fontSize: 36.sp),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              )
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 50.w,
                color: Colors.grey,
              ),
              Text(
                "Dang hom qua",
                style: TextStyle(color: Colors.grey, fontSize: 36.sp),
              ),
            ],
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
          Text(
            "Đặc điểm bất động sản",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 46.sp),
          ),
          SizedBox(
            height: 30.h,
          ),
          Row(
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
          Row(
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
        ],
      ),
    );
  }

  Widget _detailDecribe(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      width: 1920.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mô tả chi tiết",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 46.sp),
            maxLines: null,
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
            maxLines: null,
            style: TextStyle(fontSize: 36.sp),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              "Liên hệ ngay: " + "0123456789",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 36.sp),
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
          Text(
            "Địa điểm bất động sản",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 46.sp),
          ),
          SizedBox(
            height: 30.h,
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
            width: 20.w,
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
      color: Colors.grey,
      width: 1920.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chat với người bán hàng",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 46.sp),
          ),
          ListView(
            scrollDirection: Axis.horizontal,
            children: [],
          )
        ],
      ),
    );
  }
}
