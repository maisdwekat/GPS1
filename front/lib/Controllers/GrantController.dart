import 'package:ggg_hhh/Controllers/token_controller.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Grantcontroller {
  final String baseUrl = "http://$ip:4000/api/v1/grant";
  TokenController token = TokenController();

  Future<Map<String,dynamic>?> addGrant(String nameOfCompany, String nameOfGrant, String description , String DateOfEndoFGrant) async {
    final savedToken =await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json',
          'token': tokenWithPrefix,},
        body: json.encode({
          'nameOfCompany': nameOfCompany,
          'nameOfGrant': nameOfGrant,
          'description': description,
          'DateOfEndoFGrant': DateOfEndoFGrant,
        }),
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);

      if (response.statusCode <= 299 && responseData.containsKey('saveGrant')) {
        return {'success': true, 'message': "Grant added successfully!"};
      } else {
        return {'success': false, 'message': responseData['message'] ?? "Grant added successfully"};
      }
    } catch (error) {
      print('Error: $error');
      return {'success': false, 'message': "An error occurred"};
    }
    return null;
  }


  Future<List< dynamic>> getAllGrants() async {
    final savedToken = await token.getToken(); // تأكد من وجود دالة _getToken
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return [];
    }
    try {

      final response = await http.get(Uri.parse('$baseUrl/all'),headers: {
        'Content-Type': 'application/json',
        'token': 'token__$savedToken',
      });
      print("getAllGrants Requset Sent");
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responesData = json.decode(response.body);
        List< dynamic> grants = (responesData['findAll'] as List);
        return grants;

      } else {
        print('Failed to get all grant: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return [];
  }

  Future<bool> deletegrant(String grantid) async {
    final savedToken =await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return true;
    }
    String tokenWithPrefix = 'token__$savedToken';

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete/$grantid'),
        headers: {'Content-Type': 'application/json',
          'token': tokenWithPrefix,},
      );

      if (response.statusCode == 200) {
        return false;
      } else {
        print('Failed to delete grant: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return true; // في حالة الفشل
  }



}