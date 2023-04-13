import 'dart:async';
import 'dart:convert';

import 'package:tro_tot_app/interfaces/province_interfaces.dart';
import 'package:tro_tot_app/models/province_model.dart';
import 'package:http/http.dart' as http;

class ProvinceServices implements IProvinceServices {
  StreamController<List<District>> _districtStreamController =
      StreamController<List<District>>();

  @override
  Future<List<City>> getCities() async {
    final response =
        await http.get(Uri.parse('https://provinces.open-api.vn/api/?depth=3'));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      return data.map((json) => City.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch cities');
    }
  }

  // @override
  // Stream<List<District>> getDistricts(String name) async* {
  //   try {
  //     final response = await http
  //         .get(Uri.parse('https://provinces.open-api.vn/api/d/$name'));
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(utf8.decode(response.bodyBytes));
  //       final districts = data.map((json) => District.fromJson(json)).toList();
  //       _districtStreamController.add(districts);
  //     } else {
  //       throw Exception('Failed to fetch district');
  //     }
  //   } catch (e) {
  //     _districtStreamController.addError(e);
  //   }
  //   yield* _districtStreamController.stream;
  // }
}
