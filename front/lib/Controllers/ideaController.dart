import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'AuthController.dart';

class IdeaController {
  final String baseUrl = "http://192.168.1.25:4000/api/v1/idea";


  Future<String?> _getToken() async {
    AuthController authController = AuthController();
    return await authController.getToken();
  }

  // إضافة فكرة جديدة
  Future<Map<String,dynamic>?> addIdea(String description, bool isPublic, String category) async {
     final savedToken =await _getToken();
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
          'description': description,
          'isPublic': isPublic,
          'category': category,
        }),
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData.containsKey('saveIdea')) {
        return {'success': true, 'message': "Idea added successfully!"};
      } else {
        return {'success': false, 'message': responseData['message'] ?? "Failed to add idea"};
      }
    } catch (error) {
      print('Error: $error');
      return {'success': false, 'message': "An error occurred"};
    }
    return null;
  }

  // إضافة تعليق على فكرة
  Future<String?> addComment(String ideaId, String commentText) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addComment/$ideaId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'comment': commentText}),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData['message'];
      } else {
        print('Failed to add comment: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  // إضافة إعجاب على فكرة
  Future<String?> addLike(String ideaId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addlike/$ideaId'),
      );

      if (response.statusCode == 200) {
        return 'Liked successfully';
      } else {
        print('Failed to add like: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  // الحصول على فكرة بواسطة المعرف
  Future<Map<String, dynamic>?> getIdea(String ideaId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get/$ideaId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get idea: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  // الحصول على جميع الأفكار
  Future<List<dynamic>?> getAllIdeas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getAll'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get all ideas: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  // تحديث فكرة بواسطة المعرف
  Future<String?> updateIdea(String ideaId, String description, bool isPublic, String category, String email) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$ideaId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'description': description,
          'isPublic': isPublic,
          'categrory': category,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['message'];
      } else {
        print('Failed to update idea: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  // الحصول على جميع التعليقات لفكرة معينة
  Future<List<dynamic>?> getAllComments(String ideaId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getAllComment/$ideaId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get all comments: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  // حذف تعليق بواسطة معرف الفكرة ومعرف التعليق
  Future<bool> deleteComment(String ideaId, String commentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deletecomment/$ideaId/$commentId'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete comment: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return false;
  }

  // حذف إعجاب بواسطة معرف الفكرة ومعرف المستخدم
  Future<bool> deleteLike(String ideaId, String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deletelike/$ideaId/$userId'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete like: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return false; // في حالة الفشل
  }

  // حذف فكرة بواسطة معرفها
  Future<bool> deleteIdea(String ideaId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deleteIdea/$ideaId'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete idea: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return false;
  }

  // الحصول على الأفكار الموصى بها
  Future<List<dynamic>?> getRecommendedIdeas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getRocomanded'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get recommended ideas: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  // إعجاب بفكرة معينة
  Future<String?> likeIdea(String ideaId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/likeIdea/$ideaId'),
      );

      if (response.statusCode == 200) {
        return 'Liked successfully';
      } else {
        print('Failed to like idea: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  // الحصول على جميع الإعجابات لفكرة معينة
  Future<List<dynamic>?> getAllLikes(String ideaId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/alllike/$ideaId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get all likes: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }
  // الحصول على جميع الأفكار للمستخدم
  Future<List<Map<String, dynamic>>?> getAllForUser() async {
    print("getAllForUser() called");
    final savedToken = await _getToken(); // تأكد من وجود دالة _getToken
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return null;
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(savedToken);
    print("Decoded Token: $decodedToken");
    String userId = decodedToken['id'];
    print("User ID: $userId");
    String tokenWithPrefix = 'token__$savedToken';
    print("Token: $tokenWithPrefix");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getAllForUser/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
      );
      print("Sent Request");
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<Map<String, dynamic>> ideas = (responseData['getIdeas'] as List)
            .map((idea) => {
          'category': idea['category'],
          'description': idea['description'],
          'isPublic': idea['isPublic'],
        })
            .toList();
        print('Successfully fetched ideas: ${responseData['ideas']}'); // طباعة الأفكار المسترجعة
        print('Successfully fetched ideas: $ideas');
        return ideas; // Assuming the response contains a key 'ideas'
      } else {
        print('Failed to fetch ideas: ${response.statusCode}'); // طباعة رسالة عند الفشل
        return null; // أو معالجة الخطأ حسب الحاجة
      }
    } catch (error) {
      print('Error: $error'); // طباعة أي خطأ قد يحدث
      return null; // أو معالجة الخطأ حسب الحاجة
    }
  }

}