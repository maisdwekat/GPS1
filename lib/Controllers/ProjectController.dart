import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AuthController.dart';

class ProjectController extends GetxController {
  final String baseUrl = "http://172.23.14.245:4000/api/v1/project";
  String? savedToken;
  Future<void> getToken() async {
    AuthController authController = AuthController();
    savedToken = await authController.getToken();
    update(); // لتحديث الحالة إذا كنت تستخدم Reactive Programming
  }
  Future<Map<String, dynamic>> addNewProject(
      String title,
      String description,
      String current_stage,
      String isPublic,
      String location,
      String category,
      String website,
      String email,
      String summary,
      String date,
      http.MultipartFile image,
      String token, // إضافة المعامل token
      ) async {
    final url = Uri.parse('$baseUrl/add');

    print('إرسال طلب إضافة مشروع جديد إلى: $url');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // إضافة التوكن هنا
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'current_stage': current_stage,
        'isPublic': isPublic,
        'location': location,
        'category': category,
        'website': website,
        'email': email,
        'summary': summary,
        'date': date,
        'image': image,
      }),
    );

    print('استجابة الخادم: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('تمت إضافة المشروع بنجاح: ${response.body}');
      return {'success': true, 'message': jsonDecode(response.body)['message']};
    } else {
      print('فشل إضافة المشروع: ${response.body}');
      return {'success': false, 'message': jsonDecode(response.body)['message'] ?? 'Unknown error'};
    }
  }
  // Delete project
  Future<void> deleteProject(String projectId) async {
    final url = Uri.parse('$baseUrl/delete/$projectId');
    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
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
    final url = Uri.parse('$baseUrl/all'); // Adjust the endpoint based on your API
    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // Convert the response body into a list of projects
        List<dynamic> projects = jsonDecode(response.body);
        return projects; // Return the list of projects
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
// Function to update a project
  Future<Map<String, dynamic>> updateProject(
      String projectId,
      String title,
      String description,
      String current_stage,
      String isPublic,
      String location,
      String category,
      String website,
      String email,
      String summary,
      String date,
      String image,
      ) async {
    final url = Uri.parse('$baseUrl/update/$projectId'); // Adjust the endpoint based on your API
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'title': title,
          'description': description,
          'current_stage': current_stage,
          'isPublic': isPublic,
          'location': location,
          'category': category,
          'website': website,
          'email': email,
          'summary': summary,
          'date': date,
          'image': image,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': jsonDecode(response.body)['message']};
      } else {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update the project: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return {'success': false, 'message': e.toString()};
    }
  }
  //addTask
  Future<Map<String, dynamic>> addTask(String projectId, Map<String, dynamic> taskData, String token) async {
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
        return {'success': true, 'message': jsonDecode(response.body)['message']};
      } else {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
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
    final url = Uri.parse('$baseUrl/task/$taskId'); // Adjust the endpoint based on your API
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
    final url = Uri.parse('$baseUrl/deleteTask/$projectId/$taskId'); // Adjust the endpoint based on your API
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
  Future<Map<String, dynamic>> addNote(String projectId, Map<String, dynamic> noteData, String token) async {
    final url = Uri.parse('$baseUrl/addNote/$projectId');
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Include the token here
        },
        body: jsonEncode(noteData),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': jsonDecode(response.body)['message']};
      } else {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
      }
    } catch (e) {
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
  Future<void> deleteNote(String projectId, String noteId, String token) async {
    final url = Uri.parse('$baseUrl/deleteNote/$projectId/$noteId');
    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Include the token here
        },
      );

      if (response.statusCode == 200) {
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
  Future<Map<String, dynamic>> updateNote(String projectId, String noteId, Map<String, dynamic> noteData, String token) async {
    final url = Uri.parse('$baseUrl/updateNote/$projectId/$noteId');
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Include the token here
        },
        body: jsonEncode(noteData),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': jsonDecode(response.body)['message']};
      } else {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
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
  Future<List<dynamic>> getNotes(String projectId, String token) async {
    final url = Uri.parse('$baseUrl/getNotes/$projectId');
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Include the token here
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> notes = jsonDecode(response.body);
        return notes; // Return the list of notes
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
      return []; // Return an empty list in case of an error
    }
  }
//rateProject
  Future<Map<String, dynamic>> rateProject(String projectId, Map<String, dynamic> ratingData, String token) async {
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
        return {'success': true, 'message': jsonDecode(response.body)['message']};
      } else {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
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


}