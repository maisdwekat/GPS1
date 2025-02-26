import 'dart:convert';
import 'package:ggg_hhh/Controllers/token_controller.dart';
import 'package:ggg_hhh/constants.dart';
import 'package:http/http.dart' as http;

class ChatController {
  List messages = [];
  final String baseUrl =
      "http://$ip:4000/api/v1/conversation"; // Adjust based on your API endpoint
  TokenController tokenController = TokenController();

  Future<String?> sendMessage(String messageText) async {
    final savedToken = await tokenController.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return "Authentication token is missing";
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendMessage'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
        body: json.encode({'content': messageText}),

      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        messages.clear();
        messages.addAll(responseData['conversation']['messages']);

      } else {
        print('Failed to send message: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null; // In case of failure
  }

  //getMessages
  Future<String> getMessages() async {
    final savedToken = await tokenController.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return '';
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.get(Uri.parse('$baseUrl/getMessage'),headers: {
        'Content-Type': 'application/json',
        'token': tokenWithPrefix,
      });

      if (response.statusCode == 200) {
        final  responseData = json.decode(response.body);
        messages.clear();
        messages.addAll(responseData['messages']);
        print("messages: ${messages}");
      } else {
        print('Failed to get messages: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return ''; // In case of failure
  }

  //sendMessageAdmin
  Future<String?> sendMessageAdmin(
      String adminMessage, String userId) async {
    final savedToken = await tokenController.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return '';
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.post(Uri.parse('$baseUrl/sendMessageAdmin/$userId'),headers: {
        'Content-Type': 'application/json',
        'token': tokenWithPrefix,
      },body: json.encode( {
        'content':adminMessage
      }));

      if (response.statusCode == 200) {
        final  responseData = json.decode(response.body);
        return 'done';

      } else {
        print('Failed to get messages: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return ''; // In case of failure
  }


  Future<String?> get(
      String adminMessage, String conversationId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendMessageAdmin/$conversationId'),
        // Use the conversation ID here
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
  Future<dynamic> getMessagesToAdmin() async {
    final savedToken = await tokenController.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return '';
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.get(Uri.parse('$baseUrl/getMessageToAdmin'),headers: {
        'Content-Type': 'application/json',
        'token': tokenWithPrefix,
      });

      if (response.statusCode == 200) {
        final  responseData = json.decode(response.body);
        return responseData['conversations'];

      } else {
        print('Failed to get messages: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return ''; // In case of failure
  }

}
