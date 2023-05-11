import 'dart:async';
import 'dart:convert';

import 'package:tro_tot_app/interfaces/province_interfaces.dart';
import 'package:tro_tot_app/models/province_model.dart';
import 'package:http/http.dart' as http;

class ProvinceServices implements IProvinceServices {


  @override
  Future<List<City>> getAllAddress() async {
    final response =
        await http.get(Uri.parse('https://provinces.open-api.vn/api/?depth=3'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return data.map((json) => City.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch cities');
    }
  }

  @override
  void selectedCity() {
    // TODO: implement selectedCity
  }

  @override
  Future<City> getCityFromId(int id) async {
    // TODO: implement getCityFromId
    final response =
        await http.get(Uri.parse('https://provinces.open-api.vn/api/p/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      return City.fromJson(data);
    } else {
      throw Exception('Failed to fetch cities');
    }
  }

  @override
  Future<District> getDistrictFromId(int id) async {
    final response = await http.get(Uri.parse('https://provinces.open-api.vn/api/d/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return District.fromJson(data);
    } else {
      throw Exception('Failed to fetch districts');
    }
  }

  @override
  Future<Ward> getWardFromId(int id) async {
    final response = await http.get(Uri.parse('https://provinces.open-api.vn/api/w/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return Ward.fromJson(data);
    } else {
      throw Exception('Failed to fetch wards');
    }
  }


}
