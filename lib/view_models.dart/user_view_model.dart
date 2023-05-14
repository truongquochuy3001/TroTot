import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tro_tot_app/interfaces/user_interfaces.dart';
import 'package:tro_tot_app/services/user_services.dart';

import '../models/user_model.dart';

class UserViewModel extends ChangeNotifier{
  final UserSevices _userServices = UserSevices();
  UserInfor? user;
  UserInfor? roomOwner;

  Future<void> addUser(UserInfor User) async
  {
    await _userServices.addUser(User);
    notifyListeners();
  }

  Future<void> getUser(String id)async
  {
  user =  await _userServices.getUser(id);
  }

  Future<void> getRoomOwner(String id) async{
    roomOwner = await _userServices.getUser(id);
    notifyListeners();
  }

  Future<void> updateUser(UserInfor user, String id) async{
   await _userServices.updateUser(user, id);
  }
}