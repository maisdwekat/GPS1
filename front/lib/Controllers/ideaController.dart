import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:ggg_hhh/Controllers/token_controller.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../constants.dart';
import 'AuthController.dart';

class IdeaController {
  final String baseUrl = "http://$ip:4000/api/v1/idea";
  TokenController token = TokenController();

  // إضافة فكرة جديدة
  Future<Map<String, dynamic>?> addIdea(
      String description, bool isPublic, String category) async {
    final savedToken = await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
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
        return {
          'success': false,
          'message': responseData['message'] ?? "Failed to add idea"
        };
      }
    } catch (error) {
      print('Error: $error');
      return {'success': false, 'message': "An error occurred"};
    }
    return null;
  }

  // إضافة تعليق على فكرة
  Future<String?> addComment(String ideaId, String commentText) async {
    final savedToken = await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return "Authentication token is missing";
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addComment/$ideaId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
        body: json.encode({'content': commentText}),
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
  Future<String?> addLikeForIdea(String ideaId) async {
    final savedToken = await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return "Authentication token is missing";
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/likeIdea/$ideaId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
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
    print("getAllForUser() called");
    final savedToken = await token.getToken(); // تأكد من وجود دالة _getToken
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return null;
    }
    String tokenWithPrefix = 'token__$savedToken';
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get/$ideaId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
      );
      print("Sent Request to get idea");
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);
      print(responseData['getIdeas']['_id']);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        Map<String, dynamic> ideas = {
          '_id': responseData['getIdeas']['_id'],
          'ownerId': responseData['getIdeas']['createdBy']['_id'],
          'description': responseData['getIdeas']['description'],
          'emailContact': responseData['getIdeas']['emailContact'],
          'isPublic': responseData['getIdeas']['isPublic'],
          'category': responseData['getIdeas']['category'],
          'createdBy': responseData['getIdeas']['createdBy'],
          'comments':
              (responseData['getIdeas']['comments'] as List).map((comment) {
            return {
              'createdBy': comment['createdBy'],
              'content': comment['content'],
              'createdAt': comment['createdAt'],
              'userName': comment['userName'],
              '_id': comment['_id'],
              'likes': comment['likes'] != null
                  ? (comment['likes'] as List).map((like) {
                      return {
                        '_id': like['_id'],
                        'createdAt': like['createdAt'],
                      };
                    }).toList()
                  : [],
            };
          }).toList(),
          'likes': (responseData['getIdeas']['likes'] as List).map((like) {
            return {
              'createdBy': like['createdBy'],
              'ideaId': like['ideaId'],
              'createdAt': like['createdAt'],
              '_id': like['_id'],
            };
          }).toList(),
          'createdAt': responseData['getIdeas']['createdAt'],
        };

        print(
            'Successfully fetched ideas: ${responseData['ideas']}'); // طباعة الأفكار المسترجعة
        print('Successfully fetched ideas: $ideas');
        return ideas;
      } else {
        print('Failed to get idea: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  // الحصول على جميع الأفكار
  Future<List<dynamic>> getAllIdeas() async {
    final savedToken = await token.getToken(); // تأكد من وجود دالة _getToken
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return [];
    }
    try {
      final response = await http.get(Uri.parse('$baseUrl/getAll'), headers: {
        'Content-Type': 'application/json',
        'token': 'token__$savedToken',
      });

      if (response.statusCode == 200) {
        final responesData = json.decode(response.body);
        List<dynamic> ideas = (responesData['getIdeas'] as List);
        return ideas;
      } else {
        print('Failed to get all ideas: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return [];
  }


  Future<Map<String, dynamic>?> updateIdea(
      String description, bool isPublic, String category, String ideaId) async {
    final savedToken = await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/update/$ideaId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
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
        return {
          'success': false,
          'message': responseData['message'] ?? "Failed to add idea"
        };
      }
    } catch (error) {
      print('Error: $error');
      return {'success': false, 'message': "An error occurred"};
    }
    return null;
  }



  // الحصول على جميع التعليقات لفكرة معينة
  Future<List<dynamic>?> getAllComments(String ideaId) async {
    print("getAllForUser() called");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getAllComment/$ideaId'),
      );

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

  // حذف إعجاب بواسطة معرف الفكرة ومعرف المستخدم
  Future<bool> deleteLikeForIDea(String ideaId) async {
    final savedToken = await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return true;
    }
    String tokenWithPrefix = 'token__$savedToken';

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deletelike/$ideaId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
      );

      if (response.statusCode == 200) {
        return false;
      } else {
        print('Failed to delete like: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return true; // في حالة الفشل
  }


  // deleteIdea
  Future<void> deleteIdea(String ideaId) async {
    final url = Uri.parse('$baseUrl/deleteIdea/$ideaId');
    final savedToken = await token.getToken();
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
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          'token': tokenWithPrefix,
        },
      );

      if (response.statusCode == 200) {
        // update(); // الآن تعمل لأن الفئة تمتد من GetxController
        Get.snackbar(
          'Success',
          'Project deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Failed to delete the project');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not delete the project: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
  Future<List<dynamic>> getAllLikes(String ideaId) async {
    final savedToken = await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return [];
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alllike/$ideaId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
      );

      if (response.statusCode == 200) {
        var likes = json.decode(response.body);
        return likes['likes'];
      } else {
        print('Failed to get all likes: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return [];
  }

  // الحصول على جميع الأفكار للمستخدم
  Future<List<Map<String, dynamic>>?> getAllForUser() async {
    print("getAllForUser() called");
    final savedToken = await token.getToken(); // تأكد من وجود دالة _getToken
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
                  '_id': idea['_id'],
                  'category': idea['category'],
                  'description': idea['description'],
                  'isPublic': idea['isPublic'],
                })
            .toList();
        print(
            'Successfully fetched ideas: ${responseData['ideas']}'); // طباعة الأفكار المسترجعة
        print('Successfully fetched ideas: $ideas');
        return ideas; // Assuming the response contains a key 'ideas'
      } else {
        print(
            'Failed to fetch ideas: ${response.statusCode}'); // طباعة رسالة عند الفشل
        return null; // أو معالجة الخطأ حسب الحاجة
      }
    } catch (error) {
      print('Error: $error'); // طباعة أي خطأ قد يحدث
      return null; // أو معالجة الخطأ حسب الحاجة
    }
  }

  //addLikeForComment
  Future<String?> addLikeForComment(String commentId) async {
    final savedToken = await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return "Authentication token is missing";
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addlike/$commentId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
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
  // الحصول على جميع الأفكار للادمن
  Future<List<dynamic>?> getAllForAdmin() async {
    print("getAllForAdmin() called");
    final savedToken = await token.getToken(); // تأكد من وجود دالة _getToken
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return null;
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(savedToken);
    print("Decoded Token: $decodedToken");
    String tokenWithPrefix = 'token__$savedToken';
    print("Token: $tokenWithPrefix");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getAllForAdmin'),
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
        List<dynamic> ideas = (responseData['getIdeas'] as List)
            .map((idea) => {
          '_id': idea['_id'],
          'emailContact': idea['emailContact'],
          'category': idea['category'],
          'description': idea['description'],
          'isPublic': idea['isPublic'],
        })
            .toList();
        print(
            'Successfully fetched ideas: ${responseData['ideas']}'); // طباعة الأفكار المسترجعة
        print('Successfully fetched ideas: $ideas');
        return ideas; // Assuming the response contains a key 'ideas'
      } else {
        print(
            'Failed to fetch ideas: ${response.statusCode}'); // طباعة رسالة عند الفشل
        return null; // أو معالجة الخطأ حسب الحاجة
      }
    } catch (error) {
      print('Error: $error'); // طباعة أي خطأ قد يحدث
      return null; // أو معالجة الخطأ حسب الحاجة
    }
  }

}
