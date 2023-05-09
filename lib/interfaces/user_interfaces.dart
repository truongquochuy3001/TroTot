import '../models/user_model.dart';

abstract class IUserServices {
  Future<void> addUser(UserInfor user);

  Future<UserInfor?> getUser(String id);
}
