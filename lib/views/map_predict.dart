import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';

class PlacesSearchService {
  final geo = GeoFlutterFire();

  Future<List<DocumentSnapshot>> searchNearbyPlaces() async {
    // Lấy vị trí hiện tại của người dùng
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Tạo một GeoFirePoint từ vị trí hiện tại của người dùng
    final GeoFirePoint center = geo.point(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    // Lấy danh sách các địa điểm gần vị trí hiện tại của người dùng
    final CollectionReference ref =
    FirebaseFirestore.instance.collection('Places');

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: ref)
        .within(center: center, radius: 50, field: 'position');

    // Chờ cho danh sách các địa điểm được tải về
    List<DocumentSnapshot> documentList =
    await stream.first.timeout(Duration(seconds: 5));

    // Trả về danh sách các địa điểm gần vị trí hiện tại của người dùng
    return documentList;
  }
}
