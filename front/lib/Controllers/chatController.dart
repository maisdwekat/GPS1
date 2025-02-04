import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatController {
  final String baseUrl = "http://localhost:4000/api/v1/conversation"; // Adjust based on your API endpoint

  Future<String?> sendMessage(String messageText) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendMessage'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': messageText}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['reply']; // Ensure the response comes in this format
      } else {
        print('Failed to send message: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null; // In case of failure
  }
  //getMessages
  Future<List<String>?> getMessages() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getMessage'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((msg) => msg['message'] as String).toList();
      } else {
        print('Failed to get messages: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null; // In case of failure
  }
  //sendMessageAdmin
  Future<String?> sendMessageAdmin(String adminMessage, String conversationId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendMessageAdmin/$conversationId'), // Use the conversation ID here
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'adminMessage': adminMessage}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['reply'];
      } else {
        print('Failed to send admin message: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }
}