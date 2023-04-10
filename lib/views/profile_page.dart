import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSelect = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 250),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          "Nguyen Van A",
          style: TextStyle(
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _userInfor(context),
            SizedBox(
              height: 10.h,
            ),
            _listPost(context),
          ],
        ),
      ),
    );
  }

  Widget _userInfor(BuildContext context) {
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
              _userInforDetail(context),
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
                backgroundImage: AssetImage("assets/images/avatar.png"),
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

  Widget _userInforDetail(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 12.w, right: 12.w),
        width: 360.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blue, width: 1.w),
                          borderRadius: BorderRadius.circular(8.w))),
                  onPressed: () {},
                  child: Text(
                    "Chỉnh sửa thông tin",
                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
              ],
            ),
            Text(
              "Nguyen Van A",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              "Chưa có đánh giá",
              style: TextStyle(fontSize: 12.sp),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              width: 360.w,
              height: 20.h,
              child: Row(
                children: [
                  Text("Người theo dõi: " + "0",
                      style: TextStyle(fontSize: 10.sp)),
                  const VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  Text("Đang theo dõi :" + "0",
                      style: TextStyle(fontSize: 10.sp)),
                ],
              ),
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
    return Container(
      width: 360.w,
      height: 400.h,
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
                            fontSize: 14.sp, fontWeight: FontWeight.w700),
                      ),
                    )),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSelect = false;
                    });
                  },
                  child: Center(
                    child: Text(
                      "Đã đóng",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          SizedBox(
            width: 360.w,
            child: AnimatedAlign(
              alignment:
                  _isSelect ? Alignment.centerLeft : Alignment.centerRight,
              duration: const Duration(milliseconds: 300),
              child: Container(
                color: Colors.blue,
                width: 180.w,
                height: 1.h,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              // itemCount: 2,
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    // _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                    _roomInfor(context),
                  ],
                );
              },
            ),
          ),
          // _moreInfoButton(context)
        ],
      ),
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
                        child: Text(
                          "Phong tro A",
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
                        "50" + " m2",
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
                        "1222222222" + "/Tháng",
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
