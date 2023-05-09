import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tro_tot_app/interfaces/user_interfaces.dart';
import 'package:tro_tot_app/models/user_model.dart';

class UserSevices implements IUserServices{
  @override
  Future<void> addUser(UserInfor user) async {
    // TODO: implement addUser
    final snapshot =
        await FirebaseFirestore.instance.collection('User').add(user.toJson());
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final createDate = FieldValue.serverTimestamp();
    await snapshot.update({'id': userId, 'joinDate': createDate});
  }

  @override
  Future<UserInfor?> getUser(String id) async{
    // TODO: implement getUser
    // final id = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('User').where('id',isEqualTo: id).get();
    print("aaa");
    print(snapshot.docs.first.data());
    return UserInfor.fromJson(snapshot.docs.first.data());
  }
}
