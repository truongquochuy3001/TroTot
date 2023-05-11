abstract class IAuthServices{
  Future<bool> signIn(String email, String password);

  Future<void> signOut();

  Future<bool> signUp(String email, String password);

  Future<bool> changePass(String id, String oldPassword, String newPassword);

  Future<bool> checkAuth();

  Future<bool> isEmailAlreadyInUse(String email);
}