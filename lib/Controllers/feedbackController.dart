import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedbackController {
  final String baseUrl = "http://localhost:4000/api/v1/feedback"; // ضبط الرابط الأساسي

  Future<String?> addFeedback(String feedbackText) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'feedback': feedbackText}),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData['message'];
      } else {
        print('Failed to add feedback: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  Future<bool> deleteFeedback(String feedbackId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete/$feedbackId'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete feedback: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return false;
  }


  Future<List<String>?> getAllFeedback() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((feedback) => feedback['feedback'] as String).toList();
      } else {
        print('Failed to get feedback: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
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