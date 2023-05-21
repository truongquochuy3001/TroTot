import '../models/user_model.dart';

abstract class IUserServices {
  Future<void> addUser(UserInfor user);

  Future<UserInfor?> getUser(String id);

  Future<UserInfor?> getUserFromUserId(String userId);

  Future<void> updateUser(UserInfor user, String id);
}
