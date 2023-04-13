class City {
  final String name;
  final int code;
  final String divisionType;
  final String codename;
  final int phoneCode;
  final List<District> districts;

  City({
    required this.name,
    required this.code,
    required this.divisionType,
    required this.codename,
    required this.phoneCode,
    required this.districts,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    var districtList = json['districts'] as List;
    List<District> districts =
        districtList.map((i) => District.fromJson(i)).toList();

    return City(
      name: json['name'],
      code: json['code'],
      divisionType: json['division_type'],
      codename: json['codename'],
      phoneCode: json['phone_code'],
      districts: districts,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> districtList =
        districts.map((i) => i.toJson()).toList();

    return {
      'name': name,
      'code': code,
      'division_type': divisionType,
      'codename': codename,
      'phone_code': phoneCode,
      'districts': districtList,
    };
  }
}

class District {
  final String name;
  final int? code;
  final String divisionType;
  final String codename;
  final int? provinceCode;
  final List<Ward> wards;

  District({
    required this.name,
    required this.code,
    required this.divisionType,
    required this.codename,
    required this.provinceCode,
    required this.wards,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    var wardList = json['wards'] as List;
    List<Ward> wards = wardList.map((i) => Ward.fromJson(i)).toList();

    return District(
      name: json['name'],
      code: json['code'],
      divisionType: json['division_type'],
      codename: json['codename'],
      provinceCode: json['province_code'],
      wards: wards,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> wardList = wards.map((i) => i.toJson()).toList();

    return {
      'name': name,
      'code': code,
      'division_type': divisionType,
      'codename': codename,
      'province_code': provinceCode,
      'wards': wardList,
    };
  }
}

class Ward {
  final String name;
  final int? code;
  final String divisionType;
  final String codename;
  final int? districtCode;

  Ward({
    required this.name,
    required this.code,
    required this.divisionType,
    required this.codename,
    required this.districtCode,
  });

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      name: json['name'],
      code: json['code'],
      divisionType: json['division_type'],
      codename: json['codename'],
      districtCode: json['district_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'division_type': divisionType,
      'codename': codename,
      'district_code': districtCode,
    };
  }
}
