import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tro_tot_app/services/auth_services.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final AuthServices _authServices = AuthServices();

  Future<bool> signIn (String email, String password) async{
    return await _authServices.signIn(email, password);
  }

  Future<void> signOut() async{
      return await _authServices.signOut();
  }

  Future<bool> signUp(String email, String password) async{
    return await _authServices.signUp(email, password);
  }

  Future<bool> checkAuth() async{
    return  await _authServices.checkAuth();
  }

  Future<bool> isEmailAlreadyInUse(String email) async{
    return await _authServices.isEmailAlreadyInUse(email);
  }

  Future<bool> changePass(String id, String oldPassword, String newPassword) async{
    return await _authServices.changePass(id, oldPassword, newPassword);
  }
}
