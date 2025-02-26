import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/token_controller.dart';
import 'package:ggg_hhh/constants.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'AuthController.dart';

class ProjectController extends GetxController {
  final String baseUrl = "http://$ip:4000/api/v1/project";
  TokenController tokenController = TokenController();

  // Delete project
  Future<void> deleteProject(String projectId) async {
    final url = Uri.parse('$baseUrl/delete/$projectId');
    final savedToken =
        await tokenController.getToken(); // تأكد من وجود دالة _getToken
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
        update(); // الآن تعمل لأن الفئة تمتد من GetxController
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

  // Function to get all projects
  Future<List<dynamic>> getAllProjects() async {
    final url = Uri.parse('$baseUrl/all');
    final savedToken =
        await tokenController.getToken(); // تأكد من وجود دالة _getToken
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return [];
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(savedToken);
    print("Decoded Token: $decodedToken");
    String userId = decodedToken['id'];
    print("User ID: $userId");
    String tokenWithPrefix = 'token__$savedToken';
    print("Token: $tokenWithPrefix");
    // Adjust the endpoint based on your API
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          'token': tokenWithPrefix,
        },
      );

      if (response.statusCode == 200) {
        // Convert the response body into a list of projects
       var projects = jsonDecode(response.body);
       List<dynamic> allProjects = projects['findAllProject'];
        return allProjects; // Return the list of projects
      } else {
        throw Exception('Failed to load projects');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not fetch projects: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return []; // Return an empty list in case of an error
    }
  }

  // الحصول على جميع المشاريع للمستخدم
  Future<List<Map<String, dynamic>>?> getAllForUser() async {
    print("getAllForUser() called");
    final savedToken =
    await tokenController.getToken(); // تأكد من وجود دالة _getToken
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
        Uri.parse('$baseUrl/allByUser/$userId'),
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

        List<Map<String, dynamic>> project =
        (responseData['findUserProjects'] as List)
            .map((project) => {
          '_id': project['_id'],
          'title': project['title'],
          'isPublic': project['isPublic'],
          'category': project['category'],
          'image': project['image'],

        })
            .toList();
        print(
            'Successfully fetched ideas: ${responseData['ideas']}'); // طباعة الأفكار المسترجعة
        print('Successfully fetched ideas: $project');
        return project; // Assuming the response contains a key 'ideas'
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



  Future<Map<String, dynamic>?> getByIdForUser(String projectId) async {
    print("getAllForUser() called");
    final savedToken =
    await tokenController.getToken(); // تأكد من وجود دالة _getToken
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
        Uri.parse('$baseUrl/allByUser/$userId'),
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

        List<Map<String, dynamic>> project =
        (responseData['findUserProjects'] as List)
            .map((project) => {
          '_id': project['_id'],
          'title': project['title'],
          'isPublic': project['isPublic'],
          'description': project['description'],
          'current_stage': project['current_stage'],
          'location': project['location'],
          'website': project['website'],
          'email': project['email'],
          'summary': project['summary'],
          'date': project['date'],
          'category': project['category'],
          'image': project['image'],


        })
            .toList();
        print(
            'Successfully fetched ideas: ${responseData['ideas']}'); // طباعة الأفكار المسترجعة
        print('Successfully fetched ideas: $project');
        Map<String, dynamic> theProject = project.firstWhere((p) => p['_id'] == projectId);
        return theProject; // Assuming the response contains a key 'ideas'
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

//getByIdForProject للجيت داخل صفحة المعاينة
  Future<Map<String, dynamic>?> getprojectById(String projectId) async {
    print("getprojectById() called");
    final savedToken =
    await tokenController.getToken(); // تأكد من وجود دالة _getToken
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
        Uri.parse('$baseUrl/allByUser/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
      );
      print("Sent Request");
      print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        List<Map<String, dynamic>> project =
        (responseData['findUserProjects'] as List)
            .map((project) => {
          '_id': project['_id'],
          'title': project['title'],
          'isPublic': project['isPublic'],
          'description': project['description'],
          'current_stage': project['current_stage'],
          'location': project['location'],
          'website': project['website'],
          'email': project['email'],
          'summary': project['summary'],
          'date': project['date'],
          'category': project['category'],
          'image': project['image'],


        })
            .toList();
        print(
            'Successfully fetched ideas: ${responseData['ideas']}'); // طباعة الأفكار المسترجعة

        Map<String, dynamic> theProject = project.firstWhere((p) => p['_id'] == projectId);
        return theProject; // Assuming the response contains a key 'ideas'
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

  Future<dynamic> updateproject(String projectId, String title, String description, String current_stage, bool isPublic, String location, String category, String website, String email, String summary, String date) async {
    print("getAllForUser() called");
    final savedToken =
    await tokenController.getToken(); // تأكد من وجود دالة _getToken
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");

    }
    String tokenWithPrefix = 'token__$savedToken';
    print("Token: $tokenWithPrefix");
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/update/$projectId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
        body: jsonEncode({"title":title ,
          "description":description,
          "current_stage":current_stage,
          "isPublic":isPublic,
          "location":location,
          "category":category,
          "website":website,
          "email":  email,
          "summary":summary,
          "date":date,
        })
      );

      print("Sent Request");
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
  // Assuing the response contains a key 'ideas'
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


  Future<Map<String, dynamic>?> getProject(String projectId) async {
    print("getAllForUser() called");
    final savedToken =
        await tokenController.getToken(); // تأكد من وجود دالة _getToken
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return null;
    }
    String tokenWithPrefix = 'token__$savedToken';
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get/$projectId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
      );

      print("Sent Request to get idea");

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);
      print(responseData['getProject']['_id']);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        Map<String, dynamic> projects = {
          '_id': responseData['getProject']['_id'],
          'title': responseData['getProject']['title'],
          'name': responseData['getProject']['name'],
          'description': responseData['getProject']['description'],
          'current_stage': responseData['getProject']['current_stage'],
          'isPublic': responseData['getProject']['isPublic'],
          'location': responseData['getProject']['location'],
          'category': responseData['getProject']['category'],
          'website': responseData['getProject']['website'],
          'email': responseData['getProject']['email'],
          'summary': responseData['getProject']['summary'],
          'date': responseData['getProject']['date'],
          'image': responseData['getProject']['image'],
          'averageRating': responseData['getProject']['averageRating'],
          'stages': (responseData['getProject']['stages'] as List).map((stage) {
            return {
              'stageName': stage['stageName'],
              'tasks': (stage['tasks'] as List).map((task) {
                return {
                  'question1': task['question1'],
                  'answer1': task['answer1'],
                  'question2': task['question2'],
                  'answer2': task['answer2'],
                  'question3': task['question3'],
                  'answer3': task['answer3'],
                  'question4': task['question4'],
                  'answer4': task['answer4'],
                  'question5': task['question5'],
                  'answer5': task['answer5'],
                  'question6': task['question6'],
                  'answer6': task['answer6'],
                  'question7': task['question7'],
                  'answer7': task['answer7'],
                  'question8': task['question8'],
                  'answer8': task['answer8'],
                };
              }).toList(),
            };
          }).toList(),
          'notes': (responseData['getProject']['notes'] as List).map((note) {
            return {
              'noteText': note['noteText'],
              'createdAt': note['createdAt'],
            };
          }).toList(),
        };

        print(
            'Successfully fetched project: ${responseData['ideas']}'); // طباعة الأفكار المسترجعة
        print('Successfully fetched project: $projects');
        return projects;
      } else {
        print('Failed to get project: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  //addTask
  Future<Map<String, dynamic>> addTask(
      String projectId, Map<String, dynamic> taskData, String token) async {
    final url = Uri.parse('$baseUrl/addTask/$projectId');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // إضافة التوكن هنا
        },
        body: jsonEncode(taskData),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not add the task: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return {'success': false, 'message': e.toString()};
    }
  }

//getTasks
  Future<Map<String, dynamic>> getTask(String taskId, String token) async {
    final url = Uri.parse(
        '$baseUrl/task/$taskId'); // Adjust the endpoint based on your API
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // إضافة التوكن هنا
        },
      );

      if (response.statusCode == 200) {
        // Assuming the response body contains task details
        Map<String, dynamic> task = jsonDecode(response.body);
        return task; // Return the task details
      } else {
        throw Exception('Failed to load task');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not fetch task: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return {}; // Return an empty map in case of an error
    }
  }

  //deleteTask
  Future<void> deleteTask(String projectId, String taskId, String token) async {
    final url = Uri.parse(
        '$baseUrl/deleteTask/$projectId/$taskId'); // Adjust the endpoint based on your API
    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // إضافة التوكن هنا
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Task deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Failed to delete the task');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not delete the task: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
//addNote
  Future<Map<String, dynamic>> addNote(
      String projectId, Map<String, dynamic> noteData) async {
    final savedToken = await tokenController.getToken(); // تأكد من وجود دالة _getToken
    print("Saved Token: $savedToken");
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
    }
    String tokenWithPrefix = 'token__$savedToken';
    final url = Uri.parse('$baseUrl/addNote/$projectId');
    print('Making POST request to: $url');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": tokenWithPrefix, // Include the token here
        },
        body: jsonEncode(noteData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      final message = jsonDecode(response.body)['message'] ?? 'Unknown error occurred';
      print('Response message: $message');
      if (response.statusCode == 200) {
        print('Success: Note added successfully');
        return {
          'success': true,
          'message': message
        };
      } else {
        print('Error response: ${jsonDecode(response.body)['message']}');
        return {
          'success': false,
          'message': message
        };
      }
    } catch (e) {
      print('Exception caught: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Could not add the note: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return {'success': false, 'message': e.toString()};
    }
  }

  //deleteNote
  Future<void> deleteNote(String projectId, String noteId) async {
    final savedToken = await tokenController.getToken(); // تأكد من وجود دالة _getToken
    print("Saved Token: $savedToken");
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
    }
    String tokenWithPrefix = 'token__$savedToken';
    final url = Uri.parse('$baseUrl/deleteNote/$projectId/$noteId');
    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": tokenWithPrefix, // Include the token here
        },
      );

      if (response.statusCode < 299) {
        Get.snackbar(
          'Success',
          'Note deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Failed to delete the note');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not delete the note: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  //updateNote
  Future<Map<String, dynamic>> updateNote(String projectId, String noteId,
      Map<String, dynamic> noteData) async {
    final savedToken = await tokenController.getToken(); // تأكد من وجود دالة _getToken
    print("Saved Token: $savedToken");
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
    }
    String tokenWithPrefix = 'token__$savedToken';
    final url = Uri.parse('$baseUrl/updateNote/$projectId/$noteId');
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": tokenWithPrefix, // Include the token here
        },
        body: jsonEncode(noteData),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update the note: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return {'success': false, 'message': e.toString()};
    }
  }

  //getNotes
  Future<List<dynamic>> getNotes(String projectId) async {
    print("getAllNotesForUser() called");
    print("widget.projectId: ${projectId}");
    final savedToken = await tokenController.getToken(); // تأكد من وجود دالة _getToken
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
    }
    String tokenWithPrefix = 'token__$savedToken';
    final url = Uri.parse('$baseUrl/getNotes/$projectId');
    print("Requesting: $url");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": tokenWithPrefix, // Include the token here
        },
      );
      print("Sent Request to get Note");
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> notesList = jsonDecode(response.body);
        return notesList; // تحويل البيانات إلى List<Map<String, dynamic>>
      } else {
        throw Exception('Failed to load notes');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not fetch notes: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return []; // إعادة قائمة فارغة عند حدوث خطأ
    }
  }

//rateProject
  Future<Map<String, dynamic>> rateProject(
      String projectId, Map<String, dynamic> ratingData, String token) async {
    final url = Uri.parse('$baseUrl/rate/$projectId');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Include the token here
        },
        body: jsonEncode(ratingData), // Body containing rating details
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message']
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message']
        };
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not rate the project: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> addProject(
      {required String title,
      required String description,
      required String current_stage,
      required bool isPublic,
      required String location,
      required String category,
      required String website,
      required String email,
      required String summary,
      required String date,
      required http.MultipartFile imageFile}) async {
    String? token = await tokenController.getToken();
    final url = Uri.parse('$baseUrl/add');
    if (token == null || token.isEmpty) {
      print("Error: Token is null or empty");
      return {'success': false, 'message': 'Authentication token is missing'};
    }
    String tokenWithPrefix = 'token__$token';
    print("📂 نوع الملف المرسل: ${imageFile.contentType}");

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add headers if needed
    //request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['token'] = tokenWithPrefix;

    // Add form fields
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['current_stage'] = current_stage;
    request.fields['isPublic'] = isPublic ? 'true' : 'false';
    request.fields['location'] = location;
    request.fields['category'] = category;
    request.fields['website'] = website;
    request.fields['email'] = email;
    request.fields['summary'] = summary;
    request.fields['date'] = date;

    // Add image file
    request.files.add(imageFile);
    print("📂 Image file added to request: ${imageFile.filename}");

    // Send the request
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    // Check the response status
    if (response.statusCode < 299) {
      print('Project added successfully');
      return {'success': true, 'data':jsonDecode(responseBody)};
    } else {
      print('Failed to add project. Status code: ${response.statusCode}');
      print(response.reasonPhrase);
      return {
        'success': false,
        'message': 'Failed to add project. Status code: ${response.statusCode}'
      };
    }
  }

  Future<dynamic> getSpecificProject(String projectId) async {
    print("getSpecificProject() called");
    final savedToken =
    await tokenController.getToken(); // تأكد من وجود دالة _getToken
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
        Uri.parse('$baseUrl/get/$projectId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
      );
      print("Sent Request");
      print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        dynamic project =responseData['getProject'];

        print(project);
        return project; // Assuming the response contains a key 'ideas'

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


  Future<List<dynamic>> getallProjectForAdmin() async {
    print("getallProjectForAdmin() called");
    final savedToken =
    await tokenController.getToken(); // تأكد من وجود دالة _getToken
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return[] ;
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(savedToken);
    print("Decoded Token: $decodedToken");
    String tokenWithPrefix = 'token__$savedToken';
    print("Token: $tokenWithPrefix");
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/allForAdmin'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
      );
      print("Sent Request");
      print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        dynamic project =responseData['getProject'];

        print(project);
        return project; // Assuming the response contains a key 'ideas'

      } else {
        print(
            'Failed to fetch ideas: ${response.statusCode}'); // طباعة رسالة عند الفشل
        return []; // أو معالجة الخطأ حسب الحاجة
      }
    } catch (error) {
      print('Error: $error'); // طباعة أي خطأ قد يحدث
      return []; // أو معالجة الخطأ حسب الحاجة
    }
  }
  Future<dynamic> addRatting(String projectId, double rate) async {
    final savedToken = await tokenController.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rate/$projectId'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
        body: json.encode({
          'rating': rate
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


}
