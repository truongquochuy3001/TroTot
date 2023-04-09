import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_search/dropdown_search.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String _selected = 'Loại phòng';
  String _selectedFur = "Không";
  List<String> _items = ['Phòng trọ', 'Nhà ở', 'Căn hộ/chung cư'];
  bool _fur = false;
  List<String> _furStatus = ["Có", "Không"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Đăng tin",
            style: TextStyle(color: Colors.white, fontSize: 18.sp),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              _roomTypeSelect(context),
              SizedBox(
                height: 10.h,
              ),
              _titleText(context, "Địa chỉ và hình ảnh"),
              SizedBox(
                height: 10,
              ),
              _addrSelect(context),
              SizedBox(
                height: 10.h,
              ),
              _upLoadPhoto(context),
              SizedBox(
                height: 10,
              ),
              _titleText(context, "Thông tin khác"),
              SizedBox(
                height: 10.h,
              ),
              _furnitureSelect(context),
              SizedBox(
                height: 10.h,
              ),
              _titleText(context, "Diện tích và giá"),
              SizedBox(
                height: 10.h,
              ),
              _sizeAndPriceInput(context, "Diện tích"),
              SizedBox(
                height: 10.h,
              ),
              _detailDecribe(context),
              SizedBox(height: 20.h),
              _submitButton(context),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleText(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.only(left: 12.w),
      alignment: Alignment.centerLeft,
      width: 360.w,
      height: 30.h,
      color: const Color.fromARGB(255, 232, 232, 232),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color.fromARGB(255, 98, 98, 103),
        ),
      ),
    );
  }

  Widget _roomTypeSelect(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          enableDrag: true,
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 360.w,
                  height: 40.h,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    "Chọn loại phòng",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: ListView.separated(
                      // shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              child: Text(_items[index]),
                              onTap: () {
                                setState(() {
                                  _selected = _items[index];
                                });
                                Navigator.of(context).pop();
                              });
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: _items.length),
                  ),
                )
              ],
            );
          },
        );
      },
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 12.w, right: 12.w),
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        width: 360.w,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(
            color: Colors.blue,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chọn loại phòng",
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color.fromARGB(255, 128, 128, 137)),
                ),
                Text(
                  _selected,
                  style: TextStyle(fontSize: 12.sp),
                )
              ],
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 26.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addrSelect(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      width: 360.w,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(color: Colors.blue, width: 1.w),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chọn địa chỉ",
              style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color.fromARGB(255, 128, 128, 137)),
            ),
            Text(
              "Địa chỉ",
              style: TextStyle(fontSize: 12.sp),
            ),
          ]),
    );
  }

  Widget _upLoadPhoto(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      width: 360.w,
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        color: const Color.fromARGB(255, 232, 232, 232),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, size: 40.w, color: Colors.black),
          Text(
            "Đăng từ 3 đến 12 hình",
            style: TextStyle(fontSize: 12.sp),
          )
        ],
      ),
    );
  }

  Widget _furnitureSelect(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          enableDrag: true,
          builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 360.w,
                  height: 40.h,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    "Nội thất",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: ListView.separated(
                      // shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              child: Text(_furStatus[index]),
                              onTap: () {
                                setState(() {
                                  _selectedFur = _furStatus[index];
                                });
                                Navigator.of(context).pop();
                              });
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: _furStatus.length),
                  ),
                )
              ],
            );
          },
        );
      },
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 12.w, right: 12.w),
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        width: 360.w,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(
            color: Colors.blue,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nội thất",
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color.fromARGB(255, 128, 128, 137)),
                ),
                Text(
                  _selectedFur,
                  style: TextStyle(fontSize: 12.sp),
                )
              ],
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 26.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sizeAndPriceInput(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: TextFormField(
        // style: TextStyle(fontSize: 12.w),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(10.w)),
          hoverColor: Colors.blue,
          constraints: BoxConstraints(maxHeight: 50.h, maxWidth: 360.w),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.w),
            borderSide: BorderSide(
              width: 0.5.w,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailDecribe(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: SizedBox(
        // width: 360.w,
        // height: 300.h,
        child: TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 50.h),
            // constraints: BoxConstraints(
            //   // maxHeight: 50.h,
            //   maxWidth: 360.w,
            // ),
            labelText: "Mô tả chi tiết",

            labelStyle: TextStyle(),
            hintText:
            "vd: Phòng trọ 30m2 đường nguyễn A, Phường A, thành phố A, nội thất đầy đủ",
            hintMaxLines: 10,
            alignLabelWithHint: true,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.w),
                borderSide: BorderSide(color: Colors.blue, width: 1.w)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.w),
              borderSide: BorderSide(
                width: 0.5.w,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              fixedSize: Size(360.w, 40.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.w))),
          onPressed: () {},
          child: Text(
            "Đăng tin",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
            ),
          )),
    );
  }
}
