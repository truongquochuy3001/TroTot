import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geohash/geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tro_tot_app/view_models.dart/province_view_model.dart';
import 'package:tro_tot_app/view_models.dart/room_view_model.dart';
import 'package:tro_tot_app/views/list_room_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/province_model.dart';

class SortPage extends StatefulWidget {
  const SortPage({Key? key}) : super(key: key);

  @override
  State<SortPage> createState() => _SortPageState();
}

class _SortPageState extends State<SortPage> {
  double _startValue = 0;
  double _endValue = 100000000;
  int selectedSortBy = 0;
  final formatter = NumberFormat('#,###');
  late Future _getCities;

  late ProvinceViewModel _provinceViewModel;
  late RoomViewModel _roomViewModel;

  // ProvinceViewModel _provinceViewModel = ProvinceViewModel();
  City? _selectedCity = null;
  District? _selectedDistrict = null;
  Ward? _selectedWard = null;

  bool lowestPrice = false;
  bool nearest = false;
  bool latestNew = false;

  LatLng? _latlng;

  Future<LatLng> getLatLngFromAddress(String address) async {
    // Get the location coordinates from the address
    List<Location> locations =
    await GeocodingPlatform.instance.locationFromAddress(address);

    // Extract the latitude and longitude from the location
    LatLng latLng = LatLng(locations.first.latitude, locations.first.longitude);
    _latlng = latLng;
    return latLng;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCities = context.read<ProvinceViewModel>().getCities();
    _provinceViewModel = context.read<ProvinceViewModel>();
    _roomViewModel = context.read<RoomViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Lọc kết quả",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _priceDisplay(context),
            _priceSelect(context),
            _title(context, "Địa chỉ"),
            SizedBox(
              height: 10.h,
            ),
            _citySelect(context),
            SizedBox(
              height: 5.h,
            ),
            _districtSelect(context),
            SizedBox(
              height: 5.h,
            ),
            _wardSelect(context),
            SizedBox(
              height: 10.h,
            ),
            _title(context, "Sắp xếp theo"),
            SizedBox(
              height: 10.h,
            ),
            _sortBy(context),
            SizedBox(height: 10.h,),
            _submitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _priceDisplay(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: RichText(
        text: TextSpan(
          text: 'Giá từ ',
          style: TextStyle(fontSize: 14.sp, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
                text: "${formatter.format(_startValue.toInt())} đ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: Colors.black)),
            TextSpan(
              text: ' đến ',
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
            TextSpan(
                text: "${formatter.format(_endValue.toInt())} đ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _priceSelect(BuildContext context) {
    return RangeSlider(
      min: 0,
      max: 100000000,
      values: RangeValues(_startValue, _endValue),
      onChanged: (values) {
        setState(() {
          _startValue = values.start;
          _endValue = values.end;
        });
      },
    );
  }

  Widget _title(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.only(left: 12.w),
      alignment: Alignment.centerLeft,
      width: 360.w,
      height: 45.h,
      color: const Color.fromARGB(255, 232, 232, 232),
      child: Text(
        textAlign: TextAlign.center,
        title,
        style: TextStyle(
            color: const Color.fromARGB(255, 131, 131, 131), fontSize: 16.sp),
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
              return Center(child: CircularProgressIndicator());
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
                                          _provinceViewModel.citySelect(city);

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
                                  )),
                              SizedBox(height: 10.h,),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: StreamBuilder<City>(
                  stream: _provinceViewModel.cityController.stream,
                  initialData: _provinceViewModel.selectedCity,
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
        // _provinceViewModel.checkDistrictSelect();
        if (_provinceViewModel.checkDistrictSelect()) {

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
                              District district = _provinceViewModel
                                  .selectedCity!.districts[index];

                              return GestureDetector(
                                onTap: () {
                                  _provinceViewModel.districtSelect(district);
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
                            itemCount: _provinceViewModel
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
        stream: _provinceViewModel.districtController.stream,
        initialData: _provinceViewModel.selectedDistrict,
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
        if (_provinceViewModel.checkWardSelect()) {

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
                                Ward ward = _provinceViewModel
                                    .selectedDistrict!.wards[index];
                                return GestureDetector(
                                    onTap: () {
                                      _provinceViewModel.wardSelect(ward);
                                      Navigator.pop(context);
                                    },
                                    child: Text(ward.name));
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemCount: _provinceViewModel
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
        stream: _provinceViewModel.wardController.stream,
        initialData: _provinceViewModel.selectedWard,
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
                    _provinceViewModel.selectedWard!.name,
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

  Widget _sortBy(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedSortBy = 1;
              latestNew = true;
              lowestPrice = false;
              nearest = false;
            });
          },
          child: Container(
            width: 360.w,
            height: 35.h,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0.5.w,
                  color: const Color.fromARGB(255, 128, 128, 137)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 8.w,
                ),
                Icon(
                  Icons.access_time,
                  size: 24.w,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  "Tin mới",
                  style: TextStyle(fontSize: 12.sp),
                ),
                const Expanded(child: SizedBox()),
                selectedSortBy == 1
                    ? Icon(Icons.album_outlined, size: 24.w, color: Colors.blue)
                    : Icon(Icons.album_outlined,
                        size: 24.w,
                        color: const Color.fromARGB(255, 232, 232, 232)),
                SizedBox(
                  width: 8.w,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedSortBy = 2;
              lowestPrice = true;
              nearest = false;
              latestNew = false;
            });
          },
          child: Container(
            width: 360.w,
            height: 35.h,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0.5.w,
                  color: const Color.fromARGB(255, 128, 128, 137)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 8.w,
                ),
                Icon(
                  Icons.price_check,
                  size: 24.w,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  "Giá thấp trước",
                  style: TextStyle(fontSize: 12.sp),
                ),
                const Expanded(child: SizedBox()),
                selectedSortBy == 2
                    ? Icon(Icons.album_outlined, size: 24.w, color: Colors.blue)
                    : Icon(Icons.album_outlined,
                        size: 24.w,
                        color: const Color.fromARGB(255, 232, 232, 232)),
                SizedBox(
                  width: 8.w,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedSortBy = 3;
              latestNew = true;
              lowestPrice = false;
              nearest = false;
            });
          },
          child: Container(
            width: 360.w,
            height: 35.h,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0.5.w,
                  color: const Color.fromARGB(255, 128, 128, 137)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 8.w,
                ),
                Icon(
                  Icons.location_on_outlined,
                  size: 24.w,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  "Gần bạn trước",
                  style: TextStyle(fontSize: 12.sp),
                ),
                const Expanded(child: SizedBox()),
                selectedSortBy == 3
                    ? Icon(Icons.album_outlined, size: 24.w, color: Colors.blue)
                    : Icon(Icons.album_outlined,
                        size: 24.w,
                        color: const Color.fromARGB(255, 232, 232, 232)),
                SizedBox(
                  width: 8.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context)
  {
    return Padding(
      padding:  EdgeInsets.only(left: 12.w, right: 12.w),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom( fixedSize: Size(360.w, 40.h)) ,
          onPressed: () async {

            await  _roomViewModel.sortRoom(_startValue, _endValue, _provinceViewModel.cityId, _provinceViewModel.districtId, _provinceViewModel.wardId, latestNew, lowestPrice);

            print(_roomViewModel.sortRooms.length);

            setState(() {
              bool sort = true;

              Navigator.pop(context, sort);
            });
      }, child: Text("Áp dụng", style: TextStyle(fontSize: 16.sp),)),
    );
  }
}
