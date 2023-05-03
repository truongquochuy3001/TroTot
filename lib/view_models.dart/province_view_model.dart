import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tro_tot_app/models/province_model.dart';
import 'package:tro_tot_app/services/province_services.dart';

class ProvinceViewModel extends ChangeNotifier {
  final ProvinceServices _provinceServices = ProvinceServices();

  List<City> _cities = [];
  List<District> _districts = [];

  List<City> get GetCities => _cities;
  List<District> get GetDistrict => _districts;

  City? selectedCity = null;
  District? selectedDistrict = null;
  Ward? selectedWard = null;

  String? roadInput = null;
  String address = "";
  String searchAddress = "";

  // int cityId = 0;
  // int districtId = 0;
  // int wardId = 0;

  StreamController<City> cityController = StreamController<City>.broadcast();
  StreamController<District> districtController =
  StreamController<District>.broadcast();
  StreamController<Ward> wardController = StreamController<Ward>.broadcast();

   int? cityId;
   int? districtId ;
   int? wardId;

  int? searchCityId;
  int? searchDistrictId;
  int? searchWardId;

  Future<void> getCities() async {
    _cities = await _provinceServices.getCities();
    notifyListeners();
  }

  void citySelect(City city) {
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
      Ward(name: "",
          code: 0,
          divisionType: "",
          codename: "0",
          districtCode: 0),
    );
  }

  void districtSelect(District district) {
    districtController.sink.add(district);
    selectedDistrict = district;
    districtId = district.code;
    selectedWard = null;

    wardController.sink.add(
      Ward(name: "",
          code: 0,
          divisionType: "",
          codename: "0",
          districtCode: 0),
    );
  }

  void wardSelect(Ward ward) {
    wardController.sink.add(ward);
    selectedWard = ward;
    wardId = ward.code;
  }

  // Kiểm tra nếu chọn địa chỉ ở phần đăng tin bị trống
  void checkLocationInput() {
    if (selectedCity != null &&
        selectedDistrict != null &&
        selectedWard != null &&
        roadInput == null) {
      address =
      "${selectedCity!.name}, ${selectedDistrict!.name}, ${selectedWard!.name}";
    } else if (selectedCity != null &&
        selectedDistrict != null &&
        selectedWard != null &&
        roadInput != null) {
      address =
      "${selectedCity!.name}, ${selectedDistrict!.name}, ${selectedWard!
          .name}, $roadInput";
    } else {
      if (selectedCity == null &&
          selectedDistrict == null &&
          selectedWard == null) {
        Fluttertoast.showToast(
          msg: "Vui lòng chọn tỉnh, thành phố, quận, huyện, thị xã và phường",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.w,
        );
      } else if (selectedCity == null && selectedDistrict == null) {
        Fluttertoast.showToast(
          msg: "Vui lòng chọn tỉnh, thành phố, quận, huyện, thị xã",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.w,
        );
      } else if (selectedDistrict == null && selectedWard == null) {
        Fluttertoast.showToast(
          msg: "Vui lòng chọn quận, huyện, thị xã và phường",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.w,
        );
      } else if (selectedCity == null) {
        Fluttertoast.showToast(
          msg: "Vui lòng chọn tỉnh, thành phố",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.w,
        );
      } else if (selectedDistrict == null) {
        Fluttertoast.showToast(
          msg: "Vui lòng chọn quận, huyện, thị xã",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.w,
        );
      } else if (selectedWard == null) {
        Fluttertoast.showToast(
          msg: "Vui lòng chọn phường, xã, thị trấn",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.w,
        );
      }
    }
  }

  // Kiểm tra tỉnh thành phố trước khi chọn phường, xã, thị trấn
  bool checkDistrictSelect() {
    if (selectedCity == null) {
      Fluttertoast.showToast(
        msg: "Vui lòng chọn tỉnh thành phố",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.w,);
      return false;
    }
    return true;
  }

  // Kiểm tra ô chọn tỉnh, thành phố và phường xã, thị trấn trước khi chọn quận, huyện
  bool checkWardSelect() {
    if (selectedCity == null && selectedDistrict == null) {
      Fluttertoast.showToast(
        msg: "Vui lòng chọn tỉnh thành phố và phường, xã, thị trấn",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.w,);
      return false;
    }
    else if (selectedDistrict == null) {
      Fluttertoast.showToast(
        msg: "Vui lòng chọn quận, huyện, thị xã",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.w,);
      return false;
    }
    return true;
  }

  void addSearchAddress() {
    if (selectedCity != null && selectedDistrict != null && selectedWard !=null){
      searchAddress = "$selectedCity, $selectedDistrict, $selectedWard";
    }
  }
}