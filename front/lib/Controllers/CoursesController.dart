import 'dart:convert';
import 'package:http/http.dart' as http;

class CoursesController {
  final String baseUrl = "http://192.168.1.16:4000/api/v1/EducationalCourse";
  Future<List<Map<String, String>>> fetchCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((course) => {
        // 'id': course['id'].toString(),
        'nameOfCompany': course['company'],
        'nameOfEducationalCourse': course['courseName'],
        'description': course['description'],
        'DateOfCourse': course['date'],
      }).toList().cast<Map<String, String>>();
    } else {
      throw Exception('فشل في جلب الدورات');
    }
  }
  //addCourse
  Future<void> addCourse(Map<String, String> course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course),
    );

    if (response.statusCode != 201) {
      throw Exception('فشل في إضافة الدورة');
    }
  }
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
  //deleteCourse
  Future<void> deleteCourse(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('فشل في حذف الدورة');
    }
  }
}