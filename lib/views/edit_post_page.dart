import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geohash/geohash.dart';
import 'package:get_storage/get_storage.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/models/province_model.dart';
import 'package:tro_tot_app/models/room_model.dart';
import 'package:tro_tot_app/view_models.dart/province_view_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'list_room_page.dart';

class EditPostPage extends StatefulWidget {
  final String id;

  const EditPostPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  RoomViewModel _roomViewModel = RoomViewModel();

  TextEditingController titleInput = TextEditingController();
  TextEditingController priceInput = TextEditingController();
  TextEditingController depositInput = TextEditingController();
  TextEditingController sizeInput = TextEditingController();
  TextEditingController decribeInput = TextEditingController();
  TextEditingController roadInput = TextEditingController();
  TextEditingController place = TextEditingController();

  late Room room;

  late int cityId;
  late int? districtId;
  late int? wardId;
  late Future _getCities;
  late final listImages;
  late List<String> listImage;
  late ProvinceViewModel value;
  late Future _getRoom;

  LatLng? _latLng;

  String _selectedRoomType = '';
  String _selectedFur = "";
  String address = "Địa chỉ";
  String city = "";
  String district = "";
  String ward = "";

  bool isSelected = true;
  bool isPicked = false;
  bool isFur = false;
  bool isLoading = false;

  bool roomTypeError = false;
  bool addrError = false;
  bool imagesError = false;
  bool sizeError = false;
  bool priceError = false;
  bool titleError = false;
  bool decribeError = false;

  final List<String> _items = ['Phòng trọ', 'Nhà ở', 'Căn hộ/chung cư'];
  final List<String> _furStatus = ["Có", "Không"];
  List<File> selectedImages = [];
  List<String> imageUrls = [];

  final picker = ImagePicker();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StreamController<City> cityController = StreamController<City>.broadcast();
  StreamController<District> districtController =
      StreamController<District>.broadcast();
  StreamController<Ward> wardController = StreamController<Ward>.broadcast();
  StreamController<List<File?>> imageController =
      StreamController<List<File?>>.broadcast();

  List<XFile> listXfile = [];

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage();
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            listXfile.add(XFile(xfilePick[i].path));
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  String downloadUrl = "";

  Future<List<String>> _getImageUrls() async {
    for (File imageFile in selectedImages) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Room')
          .child(imageName);

      firebase_storage.UploadTask uploadTask =
          ref.putFile(File(imageFile.path));

      await uploadTask;
      String imageUrl = await ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  // Lấy kinh độ vĩ độ từ địa chỉ
  Future<LatLng> getLatLngFromAddress(String address) async {
    // Get the location coordinates from the address
    List<Location> locations =
        await GeocodingPlatform.instance.locationFromAddress(address);

    // Extract the latitude and longitude from the location
    LatLng latLng = LatLng(locations.first.latitude, locations.first.longitude);
    _latLng = latLng;
    return latLng;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCities = context.read<ProvinceViewModel>().getAllAddress();
    value = context.read<ProvinceViewModel>();
    _getRoom = context.read<RoomViewModel>().getRoom(widget.id);

    // signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chỉnh sửa tin",
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
      ),
      body:
          // isLoading == true ? const Center(child: CircularProgressIndicator(),) :
          SafeArea(
        child: Consumer<RoomViewModel>(
          builder: (context, value, child) {
            return FutureBuilder(
                future: _getRoom,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Lỗi: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Center(
                        child: Text('Không tìm thấy phòng trọ!'));
                  } else {
                    final Room roomData = snapshot.data;
                    sizeInput.text = roomData.size.toString();
                    priceInput.text = roomData.price.toString();
                    if (roomData.deposit != null) {
                      depositInput.text = roomData.deposit.toString();
                    }
                    titleInput.text = roomData.name;
                    decribeInput.text = roomData.description;
                    if (roomData.road != null) {
                      roadInput.text = roomData.road!;
                    }
                    if (roomData.cityId != null) {}

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          _roomTypeSelect(context, roomData),
                          SizedBox(
                            height: 10.h,
                          ),
                          _titleText(context, "Địa chỉ và hình ảnh"),
                          SizedBox(
                            height: 10.h,
                          ),
                          _addrSelect(context, roomData),
                          SizedBox(
                            height: 10.h,
                          ),
                          _upLoadPhoto(context, roomData),
                          imagesError
                              ? const Text(
                                  "Vui lòng chọn ít nhất 1 ảnh",
                                  style: TextStyle(color: Colors.red),
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: 10.h,
                          ),
                          _titleText(context, "Thông tin khác"),
                          SizedBox(
                            height: 10.h,
                          ),
                          _furnitureSelect(context, roomData),
                          SizedBox(
                            height: 10.h,
                          ),
                          _titleText(context, "Diện tích và giá"),
                          SizedBox(
                            height: 10.h,
                          ),
                          _sizeInput(context, roomData),
                          sizeError
                              ? const Text(
                                  "Vui lòng nhập diện tích",
                                  style: TextStyle(color: Colors.red),
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: 10.h,
                          ),
                          _priceInput(context),
                          priceError
                              ? const Text(
                                  "Vui lòng nhập giá",
                                  style: TextStyle(color: Colors.red),
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: 10.h,
                          ),
                          _depositInput(context),
                          SizedBox(
                            height: 10.h,
                          ),
                          _titleText(
                              context, "Tiêu đề tin đăng và mô tả chi tiết"),
                          SizedBox(
                            height: 10.h,
                          ),
                          _titleInput(context),
                          titleError
                              ? const Text(
                                  "Vui lòng nhập tiêu đề",
                                  style: TextStyle(color: Colors.red),
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: 10.h,
                          ),
                          _detailDecribe(context),
                          decribeError
                              ? const Text(
                                  "Vui lòng nhập mô tả",
                                  style: TextStyle(color: Colors.red),
                                )
                              : const SizedBox(),
                          SizedBox(height: 20.h),
                          _submitButton(context, roomData),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      ),
                    );
                  }
                });
          },
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

  Widget _roomTypeSelect(BuildContext context, Room roomData) {
    _selectedRoomType = roomData.roomType;
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
                  decoration: const BoxDecoration(color: Colors.blue),
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
                                  _selectedRoomType = _items[index];
                                });
                                Navigator.of(context).pop();
                              });
                        },
                        separatorBuilder: (context, index) => const Divider(),
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
                  _selectedRoomType == ''
                      ? roomData.roomType.toString()
                      : _selectedRoomType.toString(),
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

  Widget _addrSelect(BuildContext context, Room roomData) {
    return Consumer<ProvinceViewModel>(
      builder: (context, value, child) {
        List<City> citiesData = value.GetCities;

        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              enableDrag: true,
              builder: (context) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: 640.h,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 360.w,
                          height: 40.h,
                          color: Colors.blue,
                          child: Text(
                            "Địa chỉ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        _citySelect(context, roomData),
                        SizedBox(
                          height: 10.h,
                        ),
                        _districtSelect(context, roomData),
                        SizedBox(
                          height: 10.h,
                        ),
                        _wardSelect(context, roomData),
                        SizedBox(
                          height: 10.h,
                        ),
                        _roadInput(context),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.w, right: 12.w),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w)),
                                elevation: 0,
                                backgroundColor: Colors.blue,
                                fixedSize: Size(360.w, 40.h)),
                            onPressed: () {
                              setState(() {
                                value.roadInput = roadInput.text;

                                value.checkLocationInput();

                                address = value.address;
                              });
                              print(value.address);
                              if (value.address != "") {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Hoàn thành",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.sp),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
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
                    // value.address == ""
                    //     ? "Địa chỉ"
                    //     : value.address,
                    value.address == ""
                        ? roomData.address
                        : value.address,

                    style: TextStyle(fontSize: 12.sp),
                  ),
                ]),
          ),
        );
      },
    );
  }

  Widget _citySelect(BuildContext context, Room roomData) {
    return Consumer<ProvinceViewModel>(
      builder: (context, value, child) {
        List<City> citiesData = value.GetCities;
        for (int i = 0; i < citiesData.length; i++) {
          if (citiesData[i].code == roomData.cityId) {
            value.selectedCity = citiesData[i];
            value.cityId =citiesData[i].code;
          }
        }
        print(roomData.districtId);
        print(value.selectedCity!.name);
        if (value.selectedCity != null) {
          for (int i = 0; i < value.selectedCity!.districts.length; i++) {
            if (value.selectedCity!.districts[i].code == roomData.districtId) {
              value.selectedDistrict = value.selectedCity!.districts[i];
              value.districtId = value.selectedDistrict!.code;
            }
          }
        }
        print(value.selectedDistrict!.name);
        if (value.selectedDistrict != null) {
          for (int i = 0; i < value.selectedDistrict!.wards.length; i++) {
            if (value.selectedDistrict!.wards[i].code == roomData.wardId) {
              value.selectedWard = value.selectedDistrict!.wards[i];
              value.wardId = value.selectedWard!.code;
            }
          }
        }
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              enableDrag: true,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 640.h,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 360.w,
                          height: 40.h,
                          color: Colors.blue,
                          child: Text(
                            "Chọn tỉnh, thành phố",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                        SizedBox(
                            height: 640.h,
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              // shrinkWrap: true,
                              // physics:
                              //     const NeverScrollableScrollPhysics(),
                              itemCount: citiesData.length,
                              itemBuilder: (context, index) {
                                City city = citiesData[index];

                                return GestureDetector(
                                  onTap: () {
                                    value.citySelect(city);

                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.w),
                                    child: Text(
                                      city.name,
                                      style: const TextStyle(),
                                    ),
                                  ),
                                );
                              },
                            ))
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: StreamBuilder<City>(
            stream: value.cityController.stream,
            initialData: value.selectedCity,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value.cityReset == "a" ?  roomData.city! :
                        value.selectedCity == null
                            ?   roomData.city!
                            : value.selectedCity!.name,

                        style: TextStyle(
                            fontSize: 14.sp,
                            color:
                            const Color.fromARGB(255, 128, 128, 137)),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 26.w,
                      ),
                    ],
                  ),
                );
              } else {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        snapshot.data!.name,
                        style: TextStyle(
                            fontSize: 14.sp,
                            color:
                            const Color.fromARGB(255, 128, 128, 137)),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 26.w,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );;
      },
    );
  }

  Widget _districtSelect(BuildContext context, Room roomData) {
    return Consumer<ProvinceViewModel>(
      builder: (context, value, child) => GestureDetector(
        onTap: () {
          if (value.checkDistrictSelect()) {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 640.h,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 360.w,
                          height: 40.h,
                          color: Colors.blue,
                          child: Text(
                            "Chọn quận, huyện",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                        SizedBox(
                          height: 640.h,
                          child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                District district = value
                                    .selectedCity!.districts[index];

                                return GestureDetector(
                                  onTap: () {
                                    value.districtSelect(district);
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.w),
                                    child: Text(
                                      district.name,
                                      style: const TextStyle(),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: value
                                  .selectedCity!.districts.length),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
        child: StreamBuilder<District>(
          stream: value.districtController.stream,
          initialData: value.selectedDistrict,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.code == 0) {
              //
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value.selectedDistrict == null
                          ? value.districtName ==
                                  "Chọn quận, huyện, thị xã"
                              ? value.districtName!
                              : roomData.district!
                          : value.selectedDistrict!.name,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 128, 128, 137)),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 26.w,
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 128, 128, 137)),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 26.w,
                    ),
                  ],
                ),
              );
            } else {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      snapshot.data!.name,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 128, 128, 137)),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 26.w,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _wardSelect(BuildContext context, Room roomData) {
    return Consumer<ProvinceViewModel>(
      builder: (context, value, child) => GestureDetector(
        onTap: () {
          if (value.checkWardSelect()) {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return SafeArea(
                  child: SizedBox(
                    height: 640.h,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // SizedBox(height: 20.h,),
                          Container(
                            alignment: Alignment.center,
                            width: 360.w,
                            height: 40.h,
                            color: Colors.blue,
                            child: Text(
                              "Chọn phường, xã, thị trấn",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ),
                          SizedBox(
                            height: 640.h,
                            child: ListView.separated(
                                // physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Ward ward = value
                                      .selectedDistrict!.wards[index];
                                  return GestureDetector(
                                      onTap: () {
                                        value.wardSelect(ward);
                                        Navigator.pop(context);
                                      },
                                      child: Text(ward.name));
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                                itemCount: value
                                    .selectedDistrict!.wards.length),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
        child: StreamBuilder<Ward>(
          stream: value.wardController.stream,
          initialData: value.selectedWard,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.code == 0) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value.selectedWard == null
                          ? value.wardName ==
                                  "Chọn phường, xã, thị trấn"
                              ? value.wardName!
                              : roomData.ward!
                          : value.selectedWard!.name!,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 128, 128, 137)),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 26.w,
                    ),
                  ],
                ),
              );
            } else {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value.selectedWard!.name,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color.fromARGB(255, 128, 128, 137)),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 26.w,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _roadInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: TextFormField(
        controller: roadInput,
        decoration: InputDecoration(
            constraints: BoxConstraints(
              minWidth: 50.h,
              maxHeight: 360.w,
            ),
            label: const Text("Nhập đường"),
            floatingLabelAlignment: FloatingLabelAlignment.start,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.w),
              borderRadius: BorderRadius.circular(10.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.w),
              borderRadius: BorderRadius.circular(10.w),
            )),
        style: TextStyle(
            fontSize: 14.sp, color: const Color.fromARGB(255, 128, 128, 137)),
      ),
    );
  }

  Widget _upLoadPhoto(BuildContext context, Room roomData) {
    return roomData.images.isEmpty
        ? GestureDetector(
            onTap: () {
              getImages();
            },
            child: Container(
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
                    "Nhấn vào đây để đăng hình",
                    style: TextStyle(fontSize: 12.sp),
                  )
                ],
              ),
            ),
          )
        : SizedBox(
            width: 360.w,
            height: 80.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                SizedBox(
                  width: 12.w,
                ),
                GestureDetector(
                  onTap: () {
                    getImages();
                  },
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.w),
                      color: Colors.blue,
                    ),
                    child: Icon(
                      Icons.add_a_photo,
                      size: 20.w,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedImages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (selectedImages.isNotEmpty) {
                      return Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 3.w, right: 3.w),
                              width: 80.w,
                              height: 80.h,

                              // child: kIsWeb
                              //     ? Image.network(
                              //   selectedImages[index]!.path,
                              //   fit: BoxFit.fill,
                              // )
                              //     : Image.file(
                              //   selectedImages[index]!,
                              //   fit: BoxFit.fill,
                              // ),

                              child: Image.file(selectedImages[index],
                                  fit: BoxFit.cover)),
                          Positioned(
                              right: 5.w,
                              top: 0,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      roomData.images.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                    size: 16.w,
                                  )))
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: roomData.images.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (roomData.images[index].isNotEmpty) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 3.w, right: 3.w),
                            width: 80.w,
                            height: 80.h,

                            // child: kIsWeb
                            //     ? Image.network(
                            //   selectedImages[index]!.path,
                            //   fit: BoxFit.fill,
                            // )
                            //     : Image.file(
                            //   selectedImages[index]!,
                            //   fit: BoxFit.fill,
                            // ),

                            child: CachedNetworkImage(
                                imageUrl: roomData.images[index],
                                fit: BoxFit.cover),
                          ),
                          Positioned(
                              right: 5.w,
                              top: 0,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      roomData.images.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                    size: 16.w,
                                  )))
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                  scrollDirection: Axis.horizontal,
                )
              ]),
            ),
          );
  }

  Widget _furnitureSelect(BuildContext context, Room roomData) {
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
                  decoration: const BoxDecoration(color: Colors.blue),
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
                                  if (_selectedFur == "Có") {
                                    isFur = true;
                                  } else {
                                    isFur = false;
                                  }
                                });
                                Navigator.of(context).pop();
                              });
                        },
                        separatorBuilder: (context, index) => const Divider(),
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
                  _selectedFur == ""
                      ? roomData.furniture == false
                          ? "Không"
                          : "Có"
                      : _selectedFur,
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

  Widget _titleInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: TextFormField(
        controller: titleInput,
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
          labelText: "Tiêu đề",
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

  Widget _sizeInput(BuildContext context, Room roomData) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: TextField(
        controller: sizeInput,
        keyboardType: TextInputType.number,
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
          labelText: "Diện tích",
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

  Widget _priceInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: TextFormField(
        controller: priceInput,
        keyboardType: TextInputType.number,
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
          labelText: "Giá",
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

  Widget _depositInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: TextFormField(
        controller: depositInput,
        keyboardType: TextInputType.number,
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
          labelText: "Tiền cọc",
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
          controller: decribeInput,
          maxLines: 5,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 50.h),
            // constraints: BoxConstraints(
            //   // maxHeight: 50.h,
            //   maxWidth: 360.w,
            // ),
            labelText: "Mô tả chi tiết",

            labelStyle: const TextStyle(),
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

  Widget _submitButton(BuildContext context, Room roomData) {
    return Consumer<ProvinceViewModel>(
      builder: (context, value, child) =>Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: Size(360.w, 40.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.w))),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              if (address == "Địa chỉ") {
                setState(() {
                  addrError = true;
                  isLoading = false;
                });
              } else {
                setState(() {
                  addrError = false;
                  isLoading = false;
                });
              }

              if (imageUrls.isEmpty) {
                setState(() {
                  imagesError = true;
                  isLoading = false;
                });
              } else {
                setState(() {
                  imagesError = false;
                  isLoading = false;
                });
              }
              if (priceInput.text.isEmpty) {
                setState(() {
                  priceError = true;
                  isLoading = false;
                });
              } else {
                setState(() {
                  priceError = false;
                  isLoading = false;
                });
              }
              if (titleInput.text.isEmpty) {
                setState(() {
                  titleError = true;
                  isLoading = false;
                });
              } else {
                setState(() {
                  titleError = false;
                  isLoading = false;
                });
              }
              if (decribeInput.text.isEmpty) {
                setState(() {
                  decribeError = true;
                  isLoading = false;
                });
              } else {
                setState(() {
                  decribeError = false;
                  isLoading = false;
                });
              }

              String userId = _auth.currentUser!.uid.toString();

              _latLng = LatLng(roomData.latitude, roomData.longitude);
              if (_latLng == null) {
                await getLatLngFromAddress(
                    "${value.selectedCity!.name}, ${value.selectedDistrict!.name}, ${value.selectedWard!.name}, ${roadInput.text.toString()}");
              }
              print(_latLng);
              if (_latLng == null) {
                await getLatLngFromAddress(
                    "${value.selectedCity!.name}, ${value.selectedDistrict!.name}, ${value.selectedWard!.name}");
                print(
                    "${value.selectedCity!.name}, ${value.selectedDistrict!.name}, ${value.selectedWard!.name}");
                print(_latLng);
              }

              if (_latLng == null) {
                await getLatLngFromAddress(
                    "${value.selectedCity!.name}, ${value.selectedDistrict!.name}");
                print(
                    "${value.selectedCity!.name}, ${value.selectedDistrict!.name}");
                print(_latLng);
              }

              if (_latLng == null) {
                await getLatLngFromAddress(
                    "${value.selectedCity!.name}");
                print("${value.selectedCity!.name}");
                print(_latLng);
              }
              String geohash = Geohash.encode(
                  _latLng!.latitude, _latLng!.longitude,
                  codeLength: 8);
              GeoPoint location = GeoPoint(_latLng!.latitude, _latLng!.longitude);
              print(selectedImages);
              await _getImageUrls();
              // nối chuỗi ảnh vừa thêm và ảnh có sẵn
              imageUrls.addAll(roomData.images);
              // await _getImageUrls();
              // print (imageUrls);
              if (depositInput.text.isEmpty) {
                room = Room(
                  cityId: value.cityId == null
                      ? roomData.cityId
                      : value.cityId,
                  userId: userId,
                  districtId: value.districtId == null
                      ? roomData.districtId
                      : value.districtId,
                  wardId: value.wardId == null
                      ? roomData.wardId
                      : value.wardId,
                  name: titleInput.text.toString(),
                  address: value.address == ""
                      ? roomData.address
                      : value.address,
                  price: double.parse(priceInput.text.toString()),
                  roomType: _selectedRoomType,
                  size: double.parse(sizeInput.text.toString()),
                  images: imageUrls,
                  image: imageUrls[0],
                  status: true,
                  description: decribeInput.text.toString(),
                  furniture: isFur,
                  longitude: _latLng!.longitude,
                  latitude: _latLng!.latitude,
                  location: location,
                  postingDate: DateTime.now(),
                  road: value.roadInput,
                  city: value.selectedCity?.name == null
                      ? roomData.city
                      : value.selectedCity?.name,
                  district: value.selectedDistrict?.name == null
                      ? roomData.district
                      : value.selectedDistrict?.name,
                  ward: value.selectedWard?.name == null
                      ? roomData.ward
                      : value.selectedWard?.name,
                );
              } else {
                room = Room(
                  cityId: value.cityId == null
                      ? roomData.cityId
                      : value.cityId,
                  userId: userId,
                  districtId: value.districtId == null
                      ? roomData.districtId
                      : value.districtId,
                  wardId: value.wardId == null
                      ? roomData.wardId
                      : value.wardId,
                  name: titleInput.text.toString(),
                  address: value.address,
                  price: double.parse(priceInput.text.toString()),
                  roomType: _selectedRoomType,
                  size: double.parse(sizeInput.text.toString()),
                  images: imageUrls,
                  image: imageUrls[0],
                  status: true,
                  description: decribeInput.text.toString(),
                  furniture: isFur,
                  longitude: _latLng!.longitude,
                  latitude: _latLng!.latitude,
                  location: location,
                  postingDate: DateTime.now(),
                  deposit: double.parse(depositInput.text.toString()),
                  road: value.roadInput,
                  city: value.selectedCity?.name == null
                      ? roomData.city
                      : value.selectedCity?.name,
                  district: value.selectedDistrict?.name == null
                      ? roomData.district
                      : value.selectedDistrict?.name,
                  ward: value.selectedWard?.name == null
                      ? roomData.ward
                      : value.selectedWard?.name,
                );
              }
              await _roomViewModel.updateRoom(widget.id, room, geohash);
              await _roomViewModel.getAllRoom();
              print(_roomViewModel.userRooms.first.name);
              setState(() {
                isLoading = false;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListRoomPage(),
                    ));
                // Navigator.pop(context);
              });
            },
            child: Text(
              "Đăng tin",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            )),
      ),
    );
  }
}
