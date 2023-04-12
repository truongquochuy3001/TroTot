import 'dart:convert';

import 'package:tro_tot_app/interfaces/province_interfaces.dart';
import 'package:tro_tot_app/models/province_model.dart';
import 'package:http/http.dart' as http;

class ProvinceServices implements IProvinceServices {
  @override
  Future<List<City>> getCities() async {
    final response =
        await http.get(Uri.parse('https://provinces.open-api.vn/api/p/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return data.map((json) => City.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch cities');
    }
  }
}
