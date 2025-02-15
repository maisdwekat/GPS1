import 'dart:convert';
import 'package:ggg_hhh/Controllers/token_controller.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class CoursesController {
  final String baseUrl = "http://$ip:4000/api/v1/EducationalCourse";
  TokenController token =TokenController();


  //updateCourse
  Future<void> updateCourse(String id, Map<String, String> updatedCourse) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedCourse),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل في تحديث الدورة');
    }
  }
  //addCourse
  Future<Map<String,dynamic>?> addCourse(String nameOfCompany, String nameOfEducationalCourse, String description  , String DateOfCourse) async {
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
          'nameOfEducationalCourse': nameOfEducationalCourse,
          'description': description,
          'DateOfCourse': DateOfCourse,
        }),
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);

      if (response.statusCode == 201 && responseData.containsKey('saveIdea')) {
        return {'success': true, 'message': "Courses added successfully!"};
      } else {
        return {'success': false, 'message': responseData['message'] ?? "Failed to add idea"};
      }
    } catch (error) {
      print('Error: $error');
      return {'success': false, 'message': "An error occurred"};
    }
    return null;
  }

  Future<List< dynamic>> getAllCourses() async {
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
      print("getAllCourses Requset Sent");
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responesData = json.decode(response.body);
        List< dynamic> ideas = (responesData['findAll'] as List);
        return ideas;

      } else {
        print('Failed to get all Courses: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return [];
  }






  //deleteCourse
  Future<bool> deleteCourse(String grantid) async {
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