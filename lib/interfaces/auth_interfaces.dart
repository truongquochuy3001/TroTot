abstract class IAuthServices{
  Future<bool> signIn(String email, String password);

  Future<bool> signUp(String email, String password);

  Future<bool> checkAuth();
}