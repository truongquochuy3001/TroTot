import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/view_models.dart/province_view_model.dart';
import 'package:tro_tot_app/view_models.dart/user_view_model.dart';
import 'package:tro_tot_app/views/profile_page.dart';

import '../models/province_model.dart';
import '../models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameInput = TextEditingController();
  TextEditingController addressInput = TextEditingController();
  TextEditingController phoneNumberInput = TextEditingController();
  TextEditingController roadInput = TextEditingController();

  late Future _getCities;

  List<String> sexList = ["Nam", "Nữ"];
  String sexSelect = "Giới tính";

  File? _image;

  LatLng? _latLng;

  String _imageUrl = "";

  StreamController<City> cityController = StreamController<City>.broadcast();
  StreamController<District> districtController =
      StreamController<District>.broadcast();
  StreamController<Ward> wardController = StreamController<Ward>.broadcast();
  StreamController<List<File?>> imageController =
      StreamController<List<File?>>.broadcast();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadImage(File _image) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('User')
        .child(imageName);

    firebase_storage.UploadTask uploadTask = ref.putFile(_image);

    await uploadTask;
    String imageUrl = await ref.getDownloadURL();

    _imageUrl = imageUrl;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Chỉnh sửa thông tin"),
      ),
      body: Consumer<UserViewModel>(
        builder: (context, value, child) => SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              _userInfor(context, value.user!),
              SizedBox(
                height: 5.h,
              ),
              _addrSelect(context),
              SizedBox(
                height: 10.h,
              ),
              _submitButton(context, value.user!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context, UserInfor userData) {
    return Consumer<UserViewModel>(
      builder: (context, value, child) => Consumer<ProvinceViewModel>(
        builder: (context, value2, child) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(360.w, 40.h),
            ),
            onPressed: () async {
              if (value.user!.lat != null && value.user!.lng != null) {
                _latLng = LatLng(value.user!.lat!, value.user!.lng!);
              }
              if (_latLng == null) {
                await getLatLngFromAddress(
                    "${value2.selectedCity!.name}, ${value2.selectedDistrict!.name}, ${value2.selectedWard!.name}, ${roadInput.text.toString()}");
                print(_latLng);
              } else if (_latLng == null) {
                await getLatLngFromAddress(
                    "${value2.selectedCity!.name}, ${value2.selectedDistrict!.name}, ${value2.selectedWard!.name}");
                print(
                    "${value2.selectedCity!.name}, ${value2.selectedDistrict!.name}, ${value2.selectedWard!.name}");
                print(_latLng);
              }

              if (_latLng == null) {
                await getLatLngFromAddress(
                    "${value2.selectedCity!.name}, ${value2.selectedDistrict!.name}");
                print(
                    "${value2.selectedCity!.name}, ${value2.selectedDistrict!.name}");
                print(_latLng);
              }

              if (_latLng == null) {
                await getLatLngFromAddress("${value2.selectedCity!.name}");
                print("${value2.selectedCity!.name}");
                print(_latLng);
              }
              print(_image);
              if (_image != null) {
                await uploadImage(_image!);
              }

              print(_imageUrl);

              UserInfor userInf = UserInfor(
                road: roadInput.text,
                avatar: _imageUrl == "" ? value.user!.avatar : _imageUrl,
                name: nameInput.text,
                phoneNumber: phoneNumberInput.text,
                address:
                    value2.address == "" ? value.user!.address : value2.address,
                lat: _latLng!.latitude,
                lng: _latLng!.longitude,
                city: value2.cityName == null ? userData.city : value2.cityName,
                district: value2.districtName == null
                    ? userData.district
                    : value2.districtName,
                ward: value2.wardName == null ? userData.ward : value2.wardName,
                cityId: value2.cityId == null ? userData.cityId : value2.cityId,
                districtId: value2.districtId == null
                    ? userData.districtId
                    : value2.districtId,
                wardId: value2.wardId == null ? userData.wardId : value2.wardId,
              );
              print(value.user!.userID!);

              await value.updateUser(userInf, value.user!.userID!);
              setState(() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ));
              });
            },
            child: Text("Cập nhật")),
      ),
    );
  }

  Widget _userInfor(BuildContext context, UserInfor user) {
    // roadInput.text = user.road!;
    return Container(
      color: Colors.white,
      width: 360.w,
      // height: 640.h,
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 100.w,
                height: 100.h,
                child: Center(
                  child: _image != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(_image!),
                          minRadius: 60.w,
                        )
                      : (user.avatar == null || user.avatar == "")
                          ? CircleAvatar(
                              backgroundImage:
                                  const AssetImage("assets/images/avatar.jpg"),
                              minRadius: 60.w,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(user.avatar!),
                              minRadius: 60.w,
                            ),
                ),
              ),
              Positioned(
                  bottom: 0.w,
                  right: 0.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: Size(20.w, 20.w),
                      backgroundColor: Colors.grey,
                      shape: CircleBorder(),
                    ),
                    onPressed: () {
                      _pickImage();
                    },
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 12.w,
                    ),
                  ))
            ],
          ),
          // SizedBox(
          //   height: 12.h,
          // ),
          _userInforDetail(context, user),
        ],
      ),
    );
  }

  Widget _userInforDetail(BuildContext context, UserInfor user) {
    nameInput.text = user.name;
    if (user.address != null) {
      addressInput.text == user.address;
    }
    if (user.phoneNumber != null) {
      phoneNumberInput.text = user.phoneNumber!;
    }

    return Container(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      width: 360.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 12.w,
              ),
            ],
          ),
          TextField(
            controller: nameInput,
            decoration: InputDecoration(
              labelText: "Họ và tên",
              floatingLabelAlignment: FloatingLabelAlignment.start,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          // TextField(
          //   controller: addressInput,
          //   decoration: const InputDecoration(
          //     labelText: "Địa chỉ",
          //     floatingLabelAlignment: FloatingLabelAlignment.start,
          //   ),
          // ),
          SizedBox(
            height: 5.h,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: phoneNumberInput,
            decoration: const InputDecoration(
                labelText: "Số điện thoại",
                floatingLabelAlignment: FloatingLabelAlignment.start),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }

  Widget _addrSelect(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userData, child) {
        roadInput.text = userData.user!.road!;
        return Consumer<ProvinceViewModel>(
          builder: (context, value, child) {
            value.roadInput = roadInput.text;
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.sp),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            _citySelect(context, userData.user!),
                            SizedBox(
                              height: 10.h,
                            ),
                            _districtSelect(context, userData.user!),
                            SizedBox(
                              height: 10.h,
                            ),
                            _wardSelect(context, userData.user!),
                            SizedBox(
                              height: 10.h,
                            ),
                            _roadInput(context, userData.user!),
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12.w, right: 12.w),
                              child: Consumer<ProvinceViewModel>(
                                builder: (context, value, child) =>
                                    ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.w)),
                                      elevation: 0,
                                      backgroundColor: Colors.blue,
                                      fixedSize: Size(360.w, 40.h)),
                                  onPressed: () {
                                    setState(() {
                                      value.roadInput = roadInput.text;

                                      value.checkLocationInput();
                                    });
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
              child: Consumer<ProvinceViewModel>(
                builder: (context, value, child) => Consumer<UserViewModel>(
                  builder: (context, value2, child) => Container(
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
                                color:
                                    const Color.fromARGB(255, 128, 128, 137)),
                          ),
                          Text(
                            value.address == ""
                                ? value2.user!.address!
                                : value.address,
                            style: TextStyle(
                                fontSize: 12.sp,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ]),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _citySelect(BuildContext context, UserInfor userData) {
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

              for (int i = 0; i < citiesData.length; i++) {
                if (citiesData[i].code == userData.cityId) {
                  value.selectedCity = citiesData[i];
                }
              }
              if (value.selectedCity != null) {
                for (int i = 0; i < value.selectedCity!.districts.length; i++) {
                  if (value.selectedCity!.districts[i].code ==
                      userData.districtId) {
                    value.selectedDistrict = value.selectedCity!.districts[i];
                  }
                }
              }
              if (value.selectedDistrict != null) {
                for (int i = 0; i < value.selectedDistrict!.wards.length; i++) {
                  if (value.selectedDistrict!.wards[i].code ==
                      userData.wardId) {
                    value.selectedWard = value.selectedDistrict!.wards[i];
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
                                          value.citySelect(city);

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
                  stream: value.cityController.stream,
                  initialData: value.selectedCity,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData && userData.city == null) {
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
                      print(userData.city);
                      // print(value.selectedCity!.name);
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
                              value.selectedCity == null
                                  ? userData.city!
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

  Widget _districtSelect(BuildContext context, UserInfor userData) {
    return Consumer<ProvinceViewModel>(
      builder: (context, value, child) => GestureDetector(
        onTap: () {
          if (value.selectedCity == null) {
            Fluttertoast.showToast(
              msg: "Vui lòng chọn tỉnh, thành phố trước",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.w,
            );

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
                                    value.selectedCity!.districts[index];

                                return GestureDetector(
                                  onTap: () {
                                    value.districtSelect(district);
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
                              itemCount: value.selectedCity!.districts.length),
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
            if ((!snapshot.hasData || snapshot.data!.code == 0) &&
                userData.city == null) {
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
                      value.selectedDistrict == null
                          ? userData.district!
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
            }
          },
        ),
      ),
    );
  }

  Widget _wardSelect(BuildContext context, UserInfor userData) {
    return Consumer<ProvinceViewModel>(
      builder: (context, value, child) => GestureDetector(
        onTap: () {
          if (value.selectedCity == null && value.selectedDistrict == null) {
            Fluttertoast.showToast(
              msg: "Vui lòng chọn tỉnh, thành phố và quận, huyện, thị xã",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.w,
            );
          } else if (value.selectedCity == null) {
            Fluttertoast.showToast(
              msg: "Vui lòng chọn tỉnh, thành phố trước",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.w,
            );
          } else if (value.selectedDistrict == null) {
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ),
                          SizedBox(
                            height: 640.h,
                            child: ListView.separated(
                                // physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  Ward ward =
                                      value.selectedDistrict!.wards[index];
                                  return GestureDetector(
                                      onTap: () {
                                        value.wardSelect(ward);
                                        Navigator.pop(context);
                                      },
                                      child: Text(ward.name));
                                },
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                itemCount:
                                    value.selectedDistrict!.wards.length),
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
            if ((!snapshot.hasData || snapshot.data!.code == 0) &&
                userData.ward == null) {
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
                      value.selectedWard == null
                          ? userData.ward!
                          : value.selectedWard!.name,
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

  Widget _roadInput(BuildContext context, UserInfor userData) {
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
}
