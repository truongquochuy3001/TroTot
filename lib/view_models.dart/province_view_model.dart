import 'package:flutter/material.dart';
import 'package:tro_tot_app/models/province_model.dart';
import 'package:tro_tot_app/services/province_services.dart';

class ProvinceViewModel extends ChangeNotifier {
  final ProvinceServices _provinceServices = ProvinceServices();
  List<City> _cities = [];
  List<City> get GetCities => _cities;

  Future<void> getCities() async {
    _cities = await _provinceServices.getCities();
    notifyListeners();
  }
}