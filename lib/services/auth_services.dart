import 'package:firebase_auth/firebase_auth.dart';
import 'package:tro_tot_app/interfaces/auth_interfaces.dart';

class AuthServices implements IAuthServices {
  @override
  Future<bool> signIn(String email, String password) async {
    bool result;
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return false;
      }
      return false;
    }
  }

  @override
  Future<bool> signUp(String email, String password) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false; // return false if account creation fails
    } catch (e) {
      print(e);
      return false; // return false if any other error occurs
    }
  }
}
