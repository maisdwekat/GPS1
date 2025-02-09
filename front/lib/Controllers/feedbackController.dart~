import 'dart:convert';
import 'package:ggg_hhh/Controllers/token_controller.dart';
import 'package:ggg_hhh/constants.dart';
import 'package:http/http.dart' as http;

class FeedbackController {
  final String baseUrl = "http://$ip:4000/api/v1/feedback"; // ضبط الرابط الأساسي
  TokenController token = TokenController();

  Future<Map<String,dynamic>?> addFeedback(String description) async {
    final savedToken =await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json','token': tokenWithPrefix,},
        body: json.encode({'description': description}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['message'];
      } else {
        print('success to add feedback: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }
  Future<List<dynamic>> getFeedBack() async {
    final savedToken = await token.getToken(); // Ensure this function exists
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/all'), // Adjust the endpoint as needed
        headers: {
          'Content-Type': 'application/json',
          'token': 'token__$savedToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body); // Decode the JSON response
        print('Response Data: $responseData'); // Print the response for inspection

        // Check if 'getFeedback' key exists and is a List
        if (responseData['getFeedback'] is List) {
          List<dynamic> ideas = responseData['getFeedback'];
          return ideas;
        } else {
          print("Error: 'getFeedback' is not a List or does not exist");
        }
      } else {
        print('Failed to get feedback: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return [];
  }

  Future<bool> deleteFeedback(String feedbackId) async {
    final savedToken = await token.getToken(); // Ensure this function exists
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/all/$feedbackId'), // Adjust the endpoint as needed
        headers: {
          'Content-Type': 'application/json',
          'token': 'token__$savedToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body); // Decode the JSON response
        print('Response Data: $responseData'); // Print the response for inspection

        // Check if 'getFeedback' key exists and is a List
        if (responseData['showAll'] is List) {
          List<dynamic> ideas = responseData['showAll'];
          return true;
        } else {
          print("Error: 'getFeedback' is not a List or does not exist");
        }
      } else {
        print('Failed to get feedback: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return false;
  }


  Future<List<dynamic>?> getAllFeedbackForAdmin() async {
    final savedToken = await token.getToken(); // Ensure this function exists
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/all'), // Adjust the endpoint as needed
        headers: {
          'Content-Type': 'application/json',
          'token': 'token__$savedToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body); // Decode the JSON response
        print('Response Data: $responseData'); // Print the response for inspection

        // Check if 'getFeedback' key exists and is a List
        if (responseData['showAll'] is List) {
          List<dynamic> ideas = responseData['showAll'];
          return ideas;
        } else {
          print("Error: 'getFeedback' is not a List or does not exist");
        }
      } else {
        print('Failed to get feedback: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return [];
  }

  Future<String?> getFeedbackById(String feedbackId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all/$feedbackId'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['feedback'];
      } else {
        print('Failed to get feedback by ID: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null; // في حالة الفشل
  }
}