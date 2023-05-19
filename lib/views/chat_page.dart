import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tro_tot_app/views/chat_detail.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required String id}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tin nhắn"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailPage(id: '',),));
              },
              child: _chatDetail(
                  context,
                  "Truong Huy",
                  "Phòng trọ giá rẻ",
                  "Phòng này còn không",
                  "assets/images/image.jpg",
                  "assets/images/avatar.png"),
            ),
            _underline(context),
            _chatDetail(
                context,
                "Truong",
                "Phòng trọ sinh viên",
                "Giá bao nhiêu ạ",
                "assets/images/Tro1.jpg",
                "assets/images/avatar.jpg"),
            _underline(context),
            _chatDetail(
                context,
                "Truong Huy",
                "Phòng trọ giá rẻ",
                "Phòng này còn không",
                "assets/images/Tro2.jpg",
                "assets/images/avatar.png"),
          ],
        ),
      ),
    );
  }

  Widget _chatDetail(BuildContext context, String name, String title,
      String mess, String image, String avatar) {
    return SizedBox(
      width: 360.w,
      height: 80.h,
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
          ),
          CircleAvatar(backgroundImage: AssetImage(avatar), minRadius: 30.w),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 12.sp,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  mess,
                  style: TextStyle(fontSize: 12.sp),
                )
              ],
            ),
          ),
          Image.asset(
            image,
            width: 70.w,
            height: 70.w,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
    );
  }

  Widget _underline(BuildContext context) {
    return SizedBox(
      width: 360.w,
      child: Divider(
        color: Colors.grey,
        thickness: 1.w,
      ),
    );
  }
}
