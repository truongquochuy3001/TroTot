import 'package:firebase_auth/firebase_auth.dart';
import 'package:tro_tot_app/interfaces/auth_interfaces.dart';

class AuthServices implements IAuthServices {
  @override
  Future<bool> signIn(String email, String password) async {

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

  @override
  Future<bool> checkAuth() async {
    // TODO: implement checkAuth
    if (FirebaseAuth.instance.currentUser?.uid == null) {
// not logged
      return false;
    } else {
// logged
    print(FirebaseAuth.instance.currentUser!.email);
      return true;
    }
  }

  @override
  Future<void> signOut()async  {
    // TODO: implement signOut
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<bool> changePass(String userId, String oldPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.uid == userId) {
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: oldPassword);
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        return true; // password was successfully changed
      } else {
        return false; // invalid user ID
      }
    } catch (e) {
      print('Failed to change password: $e');
      return false; // failed to change password
    }
  }

  @override
  Future<bool> isEmailAlreadyInUse(String email) async {
    List<String> signInMethods =
    await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  }
}
