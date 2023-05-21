import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/view_models.dart/chat_view_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:tro_tot_app/view_models.dart/user_view_model.dart';

import '../models/chat_model.dart';
import '../models/room_model.dart';

class ChatDetailPage extends StatefulWidget {
  final String id;

  const ChatDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController _messageText = TextEditingController();
  late Future getAllMessage;
  late Future getRoomChat;
  late RoomViewModel getRoom;
  late UserViewModel getUser;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllMessage = context.read<ChatViewModel>().getListMessage(widget.id);
    getRoomChat =
        context.read<ChatViewModel>().getRoomChatFromRoomId(widget.id);
    getRoom = context.read<RoomViewModel>();
    getUser = context.read<UserViewModel>();
  }

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
            // FutureBuilder(
            //   future: getRoomChat,
            //   builder: (context, snapshot) {
            //     RoomChat roomChat = snapshot.data;
            //
            //     return FutureBuilder(
            //       future: getRoom.getRoom(roomChat.id!),
            //       builder: (context, snapshot2) {
            //         if (!snapshot2.hasData) {
            //           return const SizedBox();
            //         }
            //         else {
            //           return Container(
            //             color: const Color.fromARGB(100, 222, 222, 222),
            //             width: 360.w,
            //             height: 60.h,
            //             child: Row(
            //               children: [
            //                 SizedBox(
            //                   width: 10.w,
            //                 ),
            //                 Image.network(
            //                   snapshot2.data!.image,
            //                   fit: BoxFit.cover,
            //                   width: 60.w,
            //                   height: 60.w,
            //                 ),
            //                 SizedBox(
            //                   width: 10.w,
            //                 ),
            //                 Expanded(
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         snapshot2.data!.name,
            //                         style: TextStyle(
            //                             fontSize: 16.sp,
            //                             fontWeight: FontWeight.bold),
            //                       ),
            //                       Text(
            //                         "${snapshot2.data!.price
            //                             .toString()}đ/tháng",
            //                         style: TextStyle(
            //                             fontSize: 14.sp, color: Colors.blue),
            //                       ),
            //                       Text(
            //                         snapshot2.data!.address,
            //                         style: TextStyle(
            //                             fontSize: 14.sp,
            //                             overflow: TextOverflow.ellipsis),
            //                       )
            //                     ],
            //                   ),
            //                 )
            //               ],
            //             ),
            //           );
            //         }
            //       },
            //
            //     );
            //   },
            //
            // ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      Consumer2<ChatViewModel, UserViewModel>(
                        builder: (context, value, value2, child) =>
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('ChatRoom')
                                  .doc(widget.id)
                                  .collection('Message')
                                  .orderBy('time', descending: false)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // List<Message> listMess = snapshot.data!;

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> map = snapshot.data!.docs[index]
                                          .data() as Map<String, dynamic>;
                                          return Container(
                                            width: 360.w,
                                            height: 50.h,
                                            alignment:
                                            map['senderId'] ==
                                                value2.user!.id
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            padding: EdgeInsets.only(
                                                left: 10.w, right: 10.w),
                                            child: Container(
                                              padding: EdgeInsets.all(16.w),
                                              // width: 300.w,
                                              // height: 40.h,
                                              decoration: BoxDecoration(
                                                color:  map['senderId'] ==
                                                    value2.user!.id
                                                    ? const Color.fromARGB(
                                                    255, 176, 209, 252)
                                                    : const Color.fromARGB(
                                                    100, 222, 222, 222),
                                                borderRadius: BorderRadius
                                                    .circular(12.w),
                                              ),
                                              child: Text(
                                                map['content'],
                                                style: TextStyle(fontSize: 14.sp),
                                              ),
                                            ),
                                          );
                                    }

                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                      ),
                    ],
                  ),
                )),
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_rounded)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.photo,
                      color: Colors.blue,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    )),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(100, 222, 222, 222),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: TextField(
                      controller: _messageText,
                      autofocus: false,
                      scribbleEnabled: false,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: "Nhập tin nhắn",
                      ),
                    ),
                  ),
                ),
                Consumer2<ChatViewModel, UserViewModel>(
                  builder: (context, value, value2, child) =>
                      IconButton(
                        onPressed: () async {
                          if (_messageText.text.isNotEmpty) {
                            Message message = Message(
                                senderId: value2.user!.id!,
                                time: DateTime.now(),
                                content: _messageText.text);
                            await value.addMessage(
                                message, "a", "a", "a", widget.id);
                            _messageText.clear();
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.blue,
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

  Widget _testMessRight(BuildContext context, String mess) {
    return Container(
      width: 360.w,
      height: 50.h,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        // width: 300.w,
        // height: 40.h,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 176, 209, 252),
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Text(
          mess,
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _testMessLeft(BuildContext context, String mess) {
    return Container(
      width: 360.w,
      height: 50.h,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        // width: 300.w,
        // height: 40.h,
        decoration: BoxDecoration(
          color: const Color.fromARGB(100, 222, 222, 222),
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Text(
          mess,
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _mapTest(BuildContext context) {
    return Container(
      width: 360.w,
      height: 100.h,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: SizedBox(
        width: 100.w,
        height: 100.h,
        child: GoogleMap(
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            markers: {
              const Marker(
                  markerId: MarkerId(''),
                  position: LatLng(16.4810966, 107.5754849))
            },
            // markers: Set<Marker>.of(Marker(markerId: markerId)),
            mapToolbarEnabled: true,
            initialCameraPosition: const CameraPosition(
                zoom: 13, target: LatLng(16.4810966, 107.5754849))),
      ),
    );
  }
}
