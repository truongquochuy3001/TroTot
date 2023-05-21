import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/models/chat_model.dart';
import 'package:tro_tot_app/models/user_model.dart';
import 'package:tro_tot_app/view_models.dart/chat_view_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:tro_tot_app/view_models.dart/user_view_model.dart';
import 'package:tro_tot_app/views/chat_detail.dart';

class ChatScreen extends StatefulWidget {
  final String id;

  const ChatScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future getAllRoomChat;
  late Future getRoomChatYouOwn;
  late Future getRoomChatHire;
  late RoomViewModel getRoomFromId;
  UserViewModel getUser = UserViewModel();
  bool isSelected = true;
  late UserViewModel _userViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
    getAllRoomChat = context.read<ChatViewModel>().getAllRoomChat();
    getRoomChatYouOwn =
        context.read<ChatViewModel>().getRoomChatYouOwn(widget.id);
    getRoomChatHire = context.read<ChatViewModel>().getRoomChatHire(widget.id);
    getRoomFromId = context.read<RoomViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tin nhắn"),
        elevation: 0,
      ),
      body: Column(
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
                      "Tin người khác",
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
                      "Tin của bạn",
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
          Consumer<ChatViewModel>(
            builder: (context, value, child) => Expanded(
              child: FutureBuilder(
                future:
                    isSelected == true ? getRoomChatHire : getRoomChatYouOwn,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List<RoomChat> roomChats = snapshot.data;
                        RoomChat room = roomChats[index];
                        print(room.roomOwnerId);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailPage(id: roomChats[index].id!),));
                          },
                          child: _chatDetail(
                              context,
                              roomChats[index].userId,
                              roomChats[index].roomOwnerId,
                              roomChats[index].roomId!,
                              roomChats[index].id!),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _chatDetail(BuildContext context, String userId, String roomOwnerId,
      String roomId, String id) {
    return FutureBuilder(
      future: isSelected
          ? getUser.getUserChat(roomOwnerId)
          : getUser.getUserChat(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return FutureBuilder(
            future: getRoomFromId.getRoom(roomId),
            builder: (context, snapshot2) {
              if (snapshot2.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Consumer<UserViewModel>(
                  builder: (context, value, child) => SizedBox(
                    width: 360.w,
                    height: 80.h,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data!.avatar!),
                            minRadius: 30.w),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!.name,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                snapshot2.data!.name,
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
                                "",
                                style: TextStyle(fontSize: 12.sp),
                              )
                            ],
                          ),
                        ),
                        Image.network(
                          snapshot2.data!.image,
                          width: 70.w,
                          height: 70.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }
      },
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
