class Room {
  final String? id;
  final int? cityId;
  final int? districtId;
  final int? wardId;
  final String name;
  final String address;
  final double price;
  final String roomType;
  final double size;
  final List<String> images;
  final String image;
  final DateTime? postingDate;
  final bool status;
  final String description;
  final bool furniture;
  final double longitude;
  final double latitude;

  Room({
    this.id,
    this.cityId,
    this.districtId,
    this.wardId,
    required this.name,
    required this.address,
    required this.price,
    required this.roomType,
    required this.size,
    required this.images,
    required this.image,
    this.postingDate,
    required this.status,
    required this.description,
    required this.furniture,
    required this.longitude,
    required this.latitude,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      cityId: json['cityId'],
      districtId: json['districtId'],
      wardId: json['wardId'],
      name: json['name'],
      address: json['address'],
      price: json['price'],
      roomType: json['roomType'],
      size: json['size'],
      images: List<String>.from(json['images']),
      image: json['image'],
      postingDate: json['postingDate'],
      status: json['status'],
      description: json['description'],
      furniture: json['furniture'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'cityId': cityId,
      'districtId': districtId,
      'wardId': wardId,
      'name': name,
      'address': address,
      'price': price,
      'roomType': roomType,
      'size': size,
      'images': images,
      'image': image,
      'postingDate': postingDate,
      'status': status,
      'description': description,
      'furniture': furniture,
      'longitude': longitude,
      'latitude': latitude,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
