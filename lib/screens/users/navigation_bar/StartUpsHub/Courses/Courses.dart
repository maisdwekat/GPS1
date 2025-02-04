import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../Controllers/CoursesController.dart';
import '../../../../basic/footer.dart';
import '../../../../basic/header.dart';
import '../../DrawerUsers/DrawerUsers.dart';
import '../../NavigationBarUsers.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, String>> courses = [];
  final CoursesController _coursesController = CoursesController(); // إنشاء مثيل من CoursesController

  @override
  void initState() {
    super.initState();
    fetchCourses(); // جلب الدورات عند بدء الصفحة
  }

  Future<void> fetchCourses() async {
    try {
      final fetchedCourses = await _coursesController.fetchCourses(); // استدعاء الدالة من CoursesController
      setState(() {
        courses = fetchedCourses;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D47),
      ),
      drawer: DrawerUsers(scaffoldKey: _scaffoldKey),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderScreen(),
            NavigationBarUsers(
              scaffoldKey: _scaffoldKey,
              onSelectContact: (value) {
                // منطق لتحديد جهة الاتصال
              },
            ),
            const SizedBox(height: 20),
            // إضافة مستطيلات الدورات
            ...courses.map((course) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        course['nameOfCompany'] ?? '',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 8),
                      Text(
                        course['nameOfEducationalCourse'] ?? '',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 8),
                      Text(
                        course['description'] ?? '',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'تاريخ الدورة: ${course['DateOfCourse'] ?? ''}',
                        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 40),
            Footer(),
          ],
        ),
      ),
    );
  }
}