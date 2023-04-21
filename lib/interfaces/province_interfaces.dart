import 'package:tro_tot_app/models/province_model.dart';

abstract class IProvinceServices {
  Future<List<City>> getCities();
  // Stream<List<District>> getDistricts(String name);

  void selectedCity();
}
