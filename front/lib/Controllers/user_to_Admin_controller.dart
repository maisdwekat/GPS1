import 'dart:convert';

import 'package:ggg_hhh/Controllers/token_controller.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class UserToAdminController {
 String baseUrl = 'http://$ip:4000/api/v1/auth';
TokenController tokenController = TokenController();
 Future<List<dynamic>?> getUsers() async {
  final savedToken = await tokenController.getToken(); // تأكد من وجود دالة _getToken
  if (savedToken == null || savedToken.isEmpty) {
   print("Error: Token is null or empty");
   return [];
  }
  try {
   final response = await http.get(Uri.parse('$baseUrl/users'), headers: {
    'Content-Type': 'application/json',
    'token': 'token__$savedToken',
   });

   if (response.statusCode == 200) {
    final responesData = json.decode(response.body);
    List<dynamic> users = responesData['users'];
    return users;
   } else {
    print('Failed to get all ideas: ${response.statusCode}');
   }
  } catch (error) {
   print('Error: $error');
  }
  return [];
  }

}