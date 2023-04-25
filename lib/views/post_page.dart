import 'dart:async';
import 'dart:io';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  RoomViewModel _roomViewModel = RoomViewModel();

  TextEditingController titleInput = TextEditingController();
  TextEditingController priceInput = TextEditingController();
  TextEditingController sizeInput = TextEditingController();
  TextEditingController decribeInput = TextEditingController();
  TextEditingController roadInput = TextEditingController();

  late Room room;

  late int cityId;
  late int? districtId;
  late int? wardId;

  TextEditingController place = TextEditingController();
  LatLng? _latLng;

  String _selectedRoomType = 'Loại phòng';
  String _selectedFur = "Không";

  bool isSelected = true;
  bool isPicked = false;
  bool isFur = false;

  String address = "Địa chỉ";

  late Future _getCities;

  final List<String> _items = ['Phòng trọ', 'Nhà ở', 'Căn hộ/chung cư'];
  final List<String> _furStatus = ["Có", "Không"];
  List<File> selectedImages = [];
  List<String> imageUrls = [];


  final picker = ImagePicker();
  late final listImages;
  late List<String> listImage;

  City? selectedCity = null;
  District? selectedDistrict = null;
  Ward? selectedWard = null;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInAnonymously() async {
    final UserCredential userCredential = await _auth.signInAnonymously();
    // final User user = userCredential.user!;
    // ...
  }

  StreamController<City> cityController = StreamController<City>.broadcast();
  StreamController<District> districtController =
      StreamController<District>.broadcast();
  StreamController<Ward> wardController = StreamController<Ward>.broadcast();
  StreamController<List<File?>> imageController =
      StreamController<List<File?>>.broadcast();

  void _selectedCity(City city) {
    if (selectedCity == null) {}
    if (!cityController.isClosed) cityController.sink.add(city);
    selectedCity = city;
    cityId = city.code;
    selectedDistrict = null;
    selectedWard = null;

    districtController.sink.add(District(
        name: "",
        code: 0,
        divisionType: "",
        codename: "0",
        provinceCode: 0,
        wards: []));

    wardController.sink.add(
      Ward(name: "", code: 0, divisionType: "", codename: "0", districtCode: 0),
    );
  }

  void _selectedDistrict(District district) {
    districtController.sink.add(district);
    selectedDistrict = district;
    districtId = district.code;
    selectedWard = null;

    wardController.sink.add(
      Ward(name: "", code: 0, divisionType: "", codename: "0", districtCode: 0),
    );
  }

  void _selectedWard(Ward ward) {
    wardController.sink.add(ward);
    selectedWard = ward;
    wardId = ward.code;
  }

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
            // // vi rang add vo cai listXFile ni han lam loi cai imagepicker he

            // co cai ham add ni la han ko hien anh minh vua them
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

      firebase_storage.UploadTask uploadTask = ref.putFile(File(imageFile.path));


      await uploadTask;
      String imageUrl = await ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }
    print(imageUrls);
    return imageUrls;
  }

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
    _getCities = context.read<ProvinceViewModel>().getCities();
    signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đăng tin",
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
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
                height: 10.h,
              ),
              _addrSelect(context),
              SizedBox(
                height: 10.h,
              ),
              _upLoadPhoto(context),
              SizedBox(
                height: 10.h,
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
              _sizeInput(context),
              SizedBox(
                height: 10.h,
              ),
              _priceInput(context),
              SizedBox(
                height: 10.h,
              ),
              _titleText(context, "Tiêu đề tin đăng và mô tả chi tiết"),
              SizedBox(
                height: 10.h,
              ),
              _titleInput(context),
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
                                  _selectedRoomType = _items[index];
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
                  _selectedRoomType,
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
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    _citySelect(context),
                    SizedBox(
                      height: 10.h,
                    ),
                    _districtSelect(context),
                    SizedBox(
                      height: 10.h,
                    ),
                    _wardSelect(context),
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
                            if (roadInput.text.isEmpty)
                            {address = "${selectedCity!.name}, ${selectedDistrict!.name}, ${selectedWard!.name}";}
                            else
                            { address = "${selectedCity!.name}, ${selectedDistrict!.name}, ${selectedWard!.name}, ${roadInput.text}";}
                          });

                          Navigator.pop(context);
                        },
                        child: Text(
                          "Hoàn thành",
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.sp),
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
                address,
                style: TextStyle(fontSize: 12.sp),
              ),
            ]),
      ),
    );
  }

  Widget _citySelect(BuildContext context) {
    return Consumer<ProvinceViewModel>(
      builder: (context, value, child) {
        return FutureBuilder(
          future: _getCities,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              List<City> citiesData = value.GetCities;
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
                          physics: NeverScrollableScrollPhysics(),
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
                                      return Divider();
                                    },
                                    // shrinkWrap: true,
                                    // physics:
                                    //     const NeverScrollableScrollPhysics(),
                                    itemCount: citiesData.length,
                                    itemBuilder: (context, index) {
                                      City city = citiesData[index];

                                      return GestureDetector(
                                        onTap: () {
                                          _selectedCity(city);

                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 12.w),
                                          child: Text(
                                            city.name,
                                            style: TextStyle(),
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
                  stream: cityController.stream,
                  initialData: selectedCity,
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
                              "Chọn tỉnh, thành phố",
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
              );
            }
          },
        );
      },
    );
  }

  Widget _districtSelect(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selectedCity == null) {
          Fluttertoast.showToast(
            msg: "Vui lòng chọn tỉnh, thành phố trước",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.w,
          );

          districtController.sink.addError("vui long nhap tinh, thahn pho");

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui long chon tinh, thanh pho')));
          Text("a");
        } else {
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
                              District district =
                                  selectedCity!.districts[index];

                              return GestureDetector(
                                onTap: () {
                                  _selectedDistrict(district);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12.w),
                                  child: Text(
                                    district.name,
                                    style: TextStyle(),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemCount: selectedCity!.districts.length),
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
        stream: districtController.stream,
        initialData: selectedDistrict,
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
                    "Chọn quận, huyện, thị xã",
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
    );
  }

  Widget _wardSelect(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selectedCity == null && selectedDistrict == null) {
          Fluttertoast.showToast(
            msg: "Vui lòng chọn tỉnh, thành phố và quận, huyện, thị xã",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.w,
          );
        }

        if (selectedCity == null) {
          Fluttertoast.showToast(
            msg: "Vui lòng chọn tỉnh, thành phố trước",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.w,
          );
        }

        if (selectedDistrict == null) {
          Fluttertoast.showToast(
            msg: "Vui lòng chọn quận, huyện, thị xã trước",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.w,
          );
        } else {
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        ),
                        SizedBox(
                          height: 640.h,
                          child: ListView.separated(
                              // physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Ward ward = selectedDistrict!.wards[index];
                                return GestureDetector(
                                    onTap: () {
                                      _selectedWard(ward);
                                      Navigator.pop(context);
                                    },
                                    child: Text(ward.name));
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemCount: selectedDistrict!.wards.length),
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
        stream: wardController.stream,
        initialData: selectedWard,
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
                    "Chọn phường, xã, thị trấn",
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
                    selectedWard!.name,
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
            label: Text("Nhập đường"),
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

  Widget _upLoadPhoto(BuildContext context) {
    return selectedImages.isEmpty
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
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedImages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (selectedImages[index] != null) {
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

                            child: Image.file(

                              selectedImages[index]!,
                              fit: BoxFit.cover ,

                            ),
                          ),
                          Positioned(
                              right: 5.w,
                              top: 0,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImages.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                    size: 16.w,
                                  )))
                        ],
                      );
                    }
                  },
                  scrollDirection: Axis.horizontal,
                )
              ]),
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
                                  if (_selectedFur == "Có") {
                                    isFur = true;
                                  } else {
                                    isFur = false;
                                  }
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

  Widget _sizeInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: TextFormField(
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
          onPressed: () async {
            // print(imageUrls);
            // uploadImages();
            // print(downloadUrl);
            // pickAndUploadImages(selectedImages);

            await getLatLngFromAddress(
                "${selectedCity!.name}, ${selectedDistrict!.name}, ${selectedWard!.name}, ${roadInput.text.toString()}");
            print(_latLng);
            if (_latLng == null) {
              await getLatLngFromAddress(
                  "${selectedCity!.name}, ${selectedDistrict!.name}, ${selectedWard!.name}");
              print(
                  "${selectedCity!.name}, ${selectedDistrict!.name}, ${selectedWard!.name}");
              print(_latLng);
            }

            if (_latLng == null) {
              await getLatLngFromAddress(
                  "${selectedCity!.name}, ${selectedDistrict!.name}");
              print("${selectedCity!.name}, ${selectedDistrict!.name}");
              print(_latLng);
            }

            if (_latLng == null) {
              await getLatLngFromAddress("${selectedCity!.name}");
              print("${selectedCity!.name}");
              print(_latLng);
            }
            print(selectedImages);
            await _getImageUrls();
            // await _getImageUrls();
            // print (imageUrls);
            room = Room(
                cityId: cityId,
                districtId: districtId,
                wardId: wardId,
                name: titleInput.text.toString(),
                address: address,
                price: double.parse(priceInput.text.toString()),
                roomType: _selectedRoomType,
                size: double.parse(sizeInput.text.toString()),
                images: imageUrls,
                image: imageUrls[0],
                status: true,
                description: decribeInput.text.toString(),
                furniture: isFur,
                longitude: _latLng!.longitude,
                latitude: _latLng!.latitude);
            _roomViewModel.addRoom(room );
            Navigator.pop(context);
          },
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
