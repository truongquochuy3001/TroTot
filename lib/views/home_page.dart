import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tro_tot_app/models/room_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:tro_tot_app/views/room_detail.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // CollectionReference room = FirebaseFirestore.instance.collection('Room');
  RoomData room1 = RoomData();
  late Future getRoom;
  late Future<List<Room>> _listRoom;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _listRoom,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Lỗi: ${snapshot.error}');
            } else {
              final List<Room> roomList = snapshot.data!;

              return ListView(
                children: [
                  _search(context),
                  _sortArea(context),
                  SizedBox(
                    height: 8.h,
                  ),
                  _sortCatalog(context),
                  SizedBox(
                    height: 16.h,
                  ),
                  _sortApartmentType(context),
                  SizedBox(
                    height: 8.h,
                  ),
                  _gridviewCount(context, roomList),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
              );
            }
          }),
    );
  }

  Widget _search(BuildContext context) {
    return SizedBox(
      width: 1920.w,
      height: 70.h,
      child: Row(
        children: [
          SizedBox(
            height: 50.h,
            width: 400.w,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "search",
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _sortArea(BuildContext context) {
    return SizedBox(
      width: 1920.w,
      height: 80.h,
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined),
          const Text("Khu vuc:"),
          GestureDetector(child: Text("Toan quoc")),
        ],
      ),
    );
  }

  Widget _sortCatalog(BuildContext context) {
    return SizedBox(
      width: 1920.w,
      height: 70.h,
      child: Row(
        children: [
          SizedBox(
            width: 250.w,
            height: 70.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  side: const BorderSide(width: 1, color: Colors.grey)),
              child: Row(
                children: const [
                  Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.black,
                  ),
                  Text(
                    "Lọc",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        width: 1,
                        color: Colors.grey,
                      )),
                  child: Row(
                    children: const [
                      Text(
                        "Cho thuê",
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(Icons.arrow_drop_down_sharp, color: Colors.black),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        width: 1.w,
                        color: Colors.grey,
                      )),
                  child: Row(
                    children: const [
                      Text(
                        "trọ",
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(Icons.arrow_drop_down_sharp, color: Colors.black),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.grey,
                  ),
                  child: Row(
                    children: const [
                      Text(
                        "giá +",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _sortApartmentType(BuildContext context) {
    return SizedBox(
      width: 1920.w,
      height: 200.h,
      child: ListView(
        padding: EdgeInsets.only(left: 8.w, right: 8.w),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            margin: EdgeInsets.only(left: 4.w, right: 4.w),
            width: 250.w,
            height: 200.h,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  side: const BorderSide(width: 1, color: Colors.grey),
                ),
                onPressed: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.apartment_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                    Text(
                      "Căn hộ, chung cư",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                )),
          ),
          Container(
            margin: const EdgeInsets.only(left: 4, right: 4),
            width: 250.w,
            height: 200.h,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  side: const BorderSide(width: 1, color: Colors.grey),
                ),
                onPressed: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.house_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                    Text(
                      "Nhà ở",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: 4.w, right: 4.h),
            width: 250.w,
            height: 200.h,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  side: const BorderSide(width: 1, color: Colors.grey),
                ),
                onPressed: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.home_work,
                      size: 35,
                      color: Colors.black,
                    ),
                    Text(
                      "Trọ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                )),
          ),
          Container(
            margin: const EdgeInsets.only(left: 4, right: 4),
            width: 250.w,
            height: 200.h,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  side: const BorderSide(width: 1, color: Colors.grey),
                ),
                onPressed: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_business,
                      size: 35,
                      color: Colors.black,
                    ),
                    Text(
                      "Mặt bằng",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget _gridviewCount(BuildContext context, List<Room> roomData) {
    return Flex(direction: Axis.horizontal, children: [
      Expanded(
        child: SizedBox(
          child: GridView.builder(
              itemCount: roomData.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (300.w / 380.h),
              ),
              itemBuilder: (BuildContext context, int index) {
                // Lấy phòng trọ tại vị trí index
                Room room = roomData[index];
                return _roomDetailGridView(context, room);
                // _roomDetailGridView(context),
                // _roomDetailGridView(context),
                // _roomDetailGridView(context),
                // _roomDetailGridView(context),
                // _roomDetailGridView(context),
                // _roomDetailGridView(context),
                // _roomDetailGridView(context),
              }),
        ),
      ),
    ]);
  }

  Widget _roomDetailGridView(BuildContext context, Room roomData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RoomDetailPage(
                      id: '${roomData.id}',
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 2.w,
            ),
            borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(8.w),
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 150,
              child: Image.network(
                roomData.image,
                fit: BoxFit.fill,
              ),
            ),
            Text(
              roomData.name,
              style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w500),
            ),
            Text(
              roomData.capacity.toString() + "m2",
              style: TextStyle(fontSize: 34.sp, color: Colors.grey),
            ),
            Text(
              roomData.price.toString(),
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                  fontSize: 40.sp),
            ),
            Text(
              roomData.address,
              style: TextStyle(fontSize: 36.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
