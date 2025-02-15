import 'package:ggg_hhh/Controllers/token_controller.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'dart:convert';


class UsersChatController {
  String baseUrl = 'http://$ip:3000';
  TokenController tokenController = TokenController();
  Future<String?> sendMessageUser( String userId,String massage) async {
    final savedToken = await tokenController.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return '';
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");
    try {

      final response = await http.post(Uri.parse('$baseUrl/sendMessage/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'token': tokenWithPrefix,
          },
          body: jsonEncode({'message': massage}));
      if (response.statusCode == 200) {
        print(response.body);
        return 'done';
      } else {
        print('Failed to send message: ${response.statusCode}');
        return '';
      }
    }catch
    (error) {
      print('Error: $error');

    }
    return ''; // In case of failure
  }

  Future<String?> getMessageUser( String userId,String massage) async {
    try {

      final response = await http.post(Uri.parse('$baseUrl/getConversations/$userId'),);
      if (response.statusCode == 200) {
        print(response.body);
        return 'done';
      } else {
        print('Failed to send message: ${response.statusCode}');
        return '';
      }
    }catch
    (error) {
      print('Error: $error');

    }
    return ''; // In case of failure
  }


}