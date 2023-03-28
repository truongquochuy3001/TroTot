import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
          _gridviewCount(context),
          SizedBox(
            height: 8.h,
          ),
        ],
      ),
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

  Widget _gridviewCount(BuildContext context) {
    return Flex(direction: Axis.horizontal, children: [
      Expanded(
        child: SizedBox(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: (300.w / 380.h),
            crossAxisCount: 2,
            children: [
              _roomDetailGridView(context),
              _roomDetailGridView(context),
              _roomDetailGridView(context),
              _roomDetailGridView(context),
              _roomDetailGridView(context),
              _roomDetailGridView(context),
              _roomDetailGridView(context),
              _roomDetailGridView(context),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _roomDetailGridView(BuildContext context) {
    return Container(
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
  }
}
