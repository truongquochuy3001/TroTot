import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListRoomPage extends StatefulWidget {
  const ListRoomPage({super.key});

  @override
  State<ListRoomPage> createState() => _ListRoomPageState();
}

class _ListRoomPageState extends State<ListRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 250),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _searchFeild(context),
              _sortAndArea(context),
              SizedBox(
                height: 10.h,
              ),
              Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: _listRoom(context)),
            ],
          ),
        ),
      ),
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
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 24.w,
                color: Colors.white,
              )),
          Expanded(
            child: Text(
              "Thừa Thiên Huế ",
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
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

  Widget _listRoom(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _roomInfor(context),
        SizedBox(
          height: 8.h,
        ),
        _roomInfor(context),
        SizedBox(
          height: 8.h,
        ),
        _roomInfor(context),
        SizedBox(
          height: 8.h,
        ),
        _roomInfor(context),
        SizedBox(
          height: 8.h,
        ),
        _roomInfor(context),
        SizedBox(
          height: 8.h,
        ),
        _roomInfor(context),
      ],
    );
  }

  Widget _roomInfor(BuildContext context) {
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
          Image.asset(
            "assets/images/image.jpg",
            width: 120.w,
            height: 120.h,
            fit: BoxFit.fill,
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
                        height: 42.h,
                        child: Text(
                          "Tên khách sạn được hiển thị tối đa 2 dòng",
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
                        "50 m2 ",
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
                        "2.000.000/Thang",
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
                        "Phuong Thuan Loc",
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
