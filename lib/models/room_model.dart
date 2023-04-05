class Room {
  final String? id;
  final String name;
  final String address;
  final int price;
  final String roomType;
  final int capacity;
  final List<String> images;
  final String image;
  final DateTime postingDate;
  final bool status;
  final String description;
  final bool furniture;

  Room({
    this.id,
    required this.name,
    required this.address,
    required this.price,
    required this.roomType,
    required this.capacity,
    required this.images,
    required this.image,
    required this.postingDate,
    required this.status,
    required this.description,
    required this.furniture,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      price: json['price'],
      roomType: json['roomType'],
      capacity: json['capacity'],
      images: List<String>.from(json['images']),
      image: json['image'],
      postingDate: json['postingDate'].toDate(),
      status: json['status'],
      description: json['description'],
      furniture: json['furniture'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'address': address,
      'price': price,
      'roomType': roomType,
      'capacity': capacity,
      'images': images,
      'image': image,
      'postingDate': postingDate,
      'status': status,
      'description': description,
      'furniture': furniture,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
