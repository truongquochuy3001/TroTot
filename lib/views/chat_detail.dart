import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({Key? key}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Huy Truong"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: const Color.fromARGB(255, 176, 209, 252),
                    width: 300.w,
                    height: 40.h,
                  )
                ],
              ),
            )),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_rounded)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.photo)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.location_on)),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(100, 222, 222, 222),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: const TextField(
                      autofocus: false,
                      scribbleEnabled: false,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "Nhập tin nhắn",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
