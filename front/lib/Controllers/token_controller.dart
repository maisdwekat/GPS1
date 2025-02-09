import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenController {
  // Save token to SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
  }

  // Get saved token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('auth_token')) return null;
    return prefs.getString('auth_token').toString();
  }
// Logout method (clear token)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
  }


  Map<String, dynamic> decodedToken (token){

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print(decodedToken);
    return decodedToken;

  }
}