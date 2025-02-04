import 'package:flutter/material.dart';
import 'ActiveUsersTable.dart';
import 'Courses.dart';
import 'Dashboard.dart';
import 'Grants.dart';
import 'IdeasPage.dart';
import 'Notifications.dart';
import 'ProjectsPage.dart';
import 'UsersPage.dart';
import 'chatscreen.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B), // تغيير لون الخلفية هنا
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(child: _buildMainContent(context)),
        ],
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
    return Center(
      child: Column(
        children: [
          _buildHeader(),
          _buildTitle(),
          Expanded(child: FeedbackTable()), // إضافة الجدول هنا
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        "الفيدباك",
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
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackTable extends StatefulWidget {
  @override
  _FeedbackTableState createState() => _FeedbackTableState();
}

class _FeedbackTableState extends State<FeedbackTable> {
  List<Map<String, String>> _feedbackList = [
    {"username": "مستخدم 1", "email": "user1@example.com",  "notes": "ملاحظات مفيدة"},
    {"username": "مستخدم 2", "email": "user2@example.com",  "notes": "تجربةتجربةتجربةتجربةتجربةتجربةتجربةتجربةتجربةتجربةتجربةتجربةتجربةتجربةتجربةتجربةتجربة جيدة"},
    {"username": "مستخدم 3", "email": "user3@example.com",  "notes": "يمكن تحسين الخدمة"},
  ];

  List<bool> _isNoteOpen = [false, false, false]; // لتتبع حالة الفتح لكل ملاحظة

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF4A4A4A), // لون خلفية الجدول
              borderRadius: BorderRadius.circular(8),
            ),
            child: DataTable(
              columnSpacing: 16, // إضافة مسافة بين الأعمدة
              horizontalMargin: 10,
              dataRowHeight: 48,
              columns: [
                DataColumn(label: Text("اسم المستخدم", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("البريد الإلكتروني", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("الفيدباك", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("الإجراءات", style: TextStyle(color: Colors.white))),
              ],
              rows: _feedbackList.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> feedback = entry.value;

                return DataRow(cells: [
                  DataCell(Text(feedback["username"]!, style: TextStyle(color: Colors.white))),
                  DataCell(Text(feedback["email"]!, style: TextStyle(color: Colors.white))),
                  DataCell(
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isNoteOpen[index] = !_isNoteOpen[index];
                            });
                            if (_isNoteOpen[index]) {
                              _showNoteDialog(context, feedback["username"]!, feedback["notes"]!);
                            }
                          },
                          child: Text(
                            "فيدباك",
                            style: TextStyle(
                              color: _isNoteOpen[index] ? Colors.green : Colors.red,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _feedbackList.removeAt(index);
                        });
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _showNoteDialog(BuildContext context, String username, String note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1C1C1C), // لون خلفية الصندوق من مشتقات الأسود
          title: Text(
            "فيدباك من $username",
            style: TextStyle(color: Colors.white), // تغيير لون الخط إلى الأبيض
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2B2B2B), // لون خلفية الصندوق
              borderRadius: BorderRadius.circular(8), // زوايا مدورة
            ),
            padding: EdgeInsets.all(16.0), // إضافة حشوة داخلية
            child: Text(
              note,
              style: TextStyle(color: Colors.white), // تغيير لون الخط إلى الأبيض
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "إغلاق",
                style: TextStyle(color: Colors.white), // تغيير لون الخط إلى الأبيض
              ),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الصندوق
              },
            ),
          ],
        );
      },
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