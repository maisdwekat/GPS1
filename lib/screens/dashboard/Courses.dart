import 'package:flutter/material.dart';
import '../../Controllers/CoursesController.dart';
import 'ActiveUsersTable.dart';
import 'Dashboard.dart';
import 'FeedbackPage.dart';
import 'Grants.dart';
import 'IdeasPage.dart';
import 'Notifications.dart';
import 'ProjectsPage.dart';
import 'UsersPage.dart';
import 'chatscreen.dart';

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  List<Map<String, dynamic>> courses = [];
  final CoursesController _coursesController = CoursesController();

  @override
  void initState() {
    super.initState();
    fetchCourses(); // جلب الدورات عند بدء الشاشة
  }

  Future<void> fetchCourses() async {
    try {
      final fetchedCourses = await _coursesController.fetchCourses();
      setState(() {
        courses = fetchedCourses;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showAddCourseDialog(BuildContext context) {
    final TextEditingController companyController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("إضافة دورة جديدة", style: TextStyle(color: Colors.white)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Color(0xFF3A3A3A),
          content: SingleChildScrollView(
            child: Container(
              width: 400,
              child: Column(
                children: [
                  TextField(
                    controller: companyController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "اسم الشركة",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "اسم الدورة",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "الوصف",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: dateController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "تاريخ الدورة",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: timeController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "وقت الدورة",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("إلغاء", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("إضافة", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                final newCourse = {
                  'company': companyController.text,
                  'courseName': nameController.text,
                  'description': descriptionController.text,
                  'date': dateController.text,
                  'time': timeController.text,
                };

                try {
                  await _coursesController.addCourse(newCourse);
                  fetchCourses(); // تحديث قائمة الدورات بعد الإضافة
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditCourseDialog(BuildContext context, Map<String, dynamic> course) {
    final TextEditingController companyController = TextEditingController(text: course['company']);
    final TextEditingController nameController = TextEditingController(text: course['courseName']);
    final TextEditingController descriptionController = TextEditingController(text: course['description']);
    final TextEditingController dateController = TextEditingController(text: course['date']);
    final TextEditingController timeController = TextEditingController(text: course['time']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("تحديث الدورة", style: TextStyle(color: Colors.white)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Color(0xFF3A3A3A),
          content: SingleChildScrollView(
            child: Container(
              width: 400,
              child: Column(
                children: [
                  TextField(
                    controller: companyController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "اسم الشركة",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "اسم الدورة",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "الوصف",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: dateController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "تاريخ الدورة",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: timeController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "وقت الدورة",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("إلغاء", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("تحديث", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                final updatedCourse = {
                  'company': companyController.text,
                  'courseName': nameController.text,
                  'description': descriptionController.text,
                  'date': dateController.text,
                  'time': timeController.text,
                };

                try {
                  await _coursesController.updateCourse(course['id'], updatedCourse);
                  fetchCourses(); // تحديث قائمة الدورات بعد التحديث
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCoursesTable(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(label: Text('اسم الشركة', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('اسم الدورة', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('الوصف', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('تاريخ الدورة', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('وقت الدورة', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('الإجراءات', style: TextStyle(color: Colors.white))),
        ],
        rows: courses.map<DataRow>((course) {
          return DataRow(cells: [
            DataCell(Text(course['company']!, style: TextStyle(color: Colors.white))),
            DataCell(Text(course['courseName']!, style: TextStyle(color: Colors.white))),
            DataCell(
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 150),
                child: Text(
                  course['description']!,
                  style: TextStyle(color: Colors.white),
                  maxLines: 5,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            DataCell(Text(course['date']!, style: TextStyle(color: Colors.white))),
            DataCell(Text(course['time']!, style: TextStyle(color: Colors.white))),
            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _showEditCourseDialog(context, course);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    try {
                      await _coursesController.deleteCourse(course['id']);
                      fetchCourses(); // تحديث قائمة الدورات بعد الحذف
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.visibility, color: Colors.orange),
                  onPressed: () {
                    // منطق لعرض تفاصيل الدورة
                  },
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0xFF4A4A4A),
      child: Column(
        children: [
          SizedBox(height: 70),
          _buildMenuItem(context, "لوحة التحكم", DashboardPage()),
          _buildMenuItem(context, "المستخدمون", UsersPage()),
          _buildMenuItem(context, "المشاريع", ProjectsPage()),
          _buildMenuItem(context, "الأفكار", IdeasPage()),
          _buildMenuItem(context, "الدورات", Courses()),
          _buildMenuItem(context, "أكثر المستخدمين نشاطًا", ActiveUsers()),
          _buildMenuItem(context, "الفيد باك", FeedbackPage()),
          _buildMenuItem(context, "المنح", Grantpage()),
          _buildMenuItem(context, "الاشعارات", Notifications()),
          _buildMenuItem(context, "الرسائل", chat()),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildTitle(),
        _buildAddCourseButton(context), // زر إضافة دورة
        SizedBox(height: 20),
        Expanded(child: _buildCoursesTable(context)),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        "الدورات",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFF2B2B2B),
      ),
      child: Row(
        children: [
          Spacer(),
          _buildSearchBar(),
          SizedBox(width: 20),
          ProfileCard(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 300,
      child: TextField(
        decoration: InputDecoration(
          hintText: "بحث",
          hintStyle: TextStyle(color: Colors.white54),
          fillColor: Color(0xFF4A4A4A),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.white54),
              onPressed: () {
                // منطق البحث هنا
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCourseButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: GestureDetector(
          onTap: () {
            _showAddCourseDialog(context);
          },
          child: Container(
            width: 120,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "إضافة دورة",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(child: _buildMainContent(context)),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/defaultpfp.jpg"),
            radius: 19,
          ),
          SizedBox(width: 10.0),
          Text(
            "اسم الادمن",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}