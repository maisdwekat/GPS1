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

  List<dynamic> ideas = [];
  CoursesController idea = CoursesController();

  Future<void> getAllCourse() async {
    print("getAllCourses called");
    ideas = await idea.getAllCourses();
    print(ideas);
    setState(() {
      courses = ideas.map((course) {
        return {
          'nameOfCompany': course['nameOfCompany']?.toString() ?? '',
          'nameOfEducationalCourse': course['nameOfEducationalCourse']?.toString() ?? '',
          'description': course['description']?.toString() ?? '',
          'DateOfCourse': course['DateOfCourse']?.toString() ?? '',
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCourse();
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
              onSelectContact: (value) {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            const SizedBox(height: 20),
            // استخدام GridView لعرض 3 مربعات في السطر الواحد
            GridView.builder(
              physics: NeverScrollableScrollPhysics(), // منع التمرير
              shrinkWrap: true, // يسمح بملء المساحة
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // عدد الأعمدة
                crossAxisSpacing: 16, // المسافة بين الأعمدة
                mainAxisSpacing: 16, // المسافة بين الصفوف
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(

                  // elevation: 4,
                  child:

                  Padding(
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
              },
            ),
            const SizedBox(height: 40),
            Footer(),
          ],
        ),
      ),
    );
  }
}