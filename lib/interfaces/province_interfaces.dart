import 'package:tro_tot_app/models/province_model.dart';

abstract class IProvinceServices {
  Future<List<City>> getAllAddress();

  void selectedCity();

  Future<City> getCityFromId(int id);

  Future<District> getDistrictFromId(int id);

  Future<Ward> getWardFromId(int id );


}
