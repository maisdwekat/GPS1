import 'package:flutter/material.dart';
import 'ActiveUsersTable.dart';
import 'FeedbackPage.dart';
import 'Courses.dart';
import 'Dashboard.dart';
import 'IdeasPage.dart';
import 'Notifications.dart';
import 'ProjectsPage.dart';
import 'UsersPage.dart';
import 'chatscreen.dart';

class Grantpage extends StatefulWidget {
  @override
  _GrantpageState createState() => _GrantpageState();
}

class _GrantpageState extends State<Grantpage> {
  List<Map<String, String>> _grants = [
    {"name": "منحة دراسية 1", "description": "وصف المنحة 1", "website": "https://example.com/apply1"},
    {"name": "منحة دراسية 2", "description": "وصف المنحة 2", "website": "https://example.com/apply2"},
    {"name": "منحة دراسية 3", "description": "وصف المنحة 3", "website": "https://example.com/apply3"},
  ];

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
          SizedBox(height: 8), // Add some space between header and button
          _buildAddGrantButton(), // Add the button here
          Expanded(child: GrantTable(grants: _grants, onGrantRemoved: _removeGrant)), // تمرير البيانات
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        "المنح",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //////////////////////////////////////


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


  Widget _buildAddGrantButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0), // مسافة بين الزر والحافة اليمنى
        child: GestureDetector(
          onTap: () {
            _showAddGrantDialog();
          },
          child: Container(
            width: 120, // عرض الزر
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "إضافة منحة",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////

  void _showAddGrantDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController websiteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1C1C1C),
          title: Text("إضافة منحة", style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: 400, // زيادة عرض النموذج
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "اسم المنحة",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: "وصف المنحة",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: websiteController,
                    decoration: InputDecoration(
                      hintText: "رابط التقديم",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF4A4A4A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("إضافة", style: TextStyle(color: Colors.white)),
              onPressed: () {
                setState(() {
                  _grants.add({
                    "name": nameController.text,
                    "description": descriptionController.text,
                    "website": websiteController.text,
                  });
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("إغلاق", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _removeGrant(Map<String, String> grant) {
    setState(() {
      _grants.remove(grant);
    });
  }
}

class GrantTable extends StatelessWidget {
  final List<Map<String, String>> grants;
  final Function(Map<String, String>) onGrantRemoved;

  GrantTable({required this.grants, required this.onGrantRemoved});

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
              color: Color(0xFF4A4A4A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DataTable(
              columnSpacing: 16,
              horizontalMargin: 10,
              dataRowHeight: 48,
              columns: [
                DataColumn(label: Text("اسم المنحة", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("الوصف", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("رابط التقديم", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("الإجراءات", style: TextStyle(color: Colors.white))),
              ],
              rows: grants.map((grant) {
                return DataRow(cells: [
                  DataCell(Text(grant["name"]!, style: TextStyle(color: Colors.white))),
                  DataCell(Text(grant["description"]!, style: TextStyle(color: Colors.white))),
                  DataCell(Text(grant["website"]!, style: TextStyle(color: Colors.white))),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            onGrantRemoved(grant); // استدعاء الدالة لحذف الجرانت
                          },
                        ),
                      ],
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