import 'package:flutter/material.dart';
import '../../Controllers/ProjectController.dart';
import '../../Controllers/date_controller.dart';
import '../../Controllers/token_controller.dart';
import '../Welcome/welcome_screen.dart';
import 'ActiveUsersTable.dart';
import 'Courses.dart';
import 'Dashboard.dart';
import 'FeedbackPage.dart';
import 'Grants.dart';
import 'IdeasPage.dart';
import 'Notifications.dart';
import 'ProjectDetailsPage.dart'; // تأكد من أن لديك هذه الصفحة
import 'UsersPage.dart';
import 'chatscreen.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  ProjectController projectController = ProjectController();
   List<dynamic> projects = [];



  getProjects() async {
    await projectController.getAllProjects().then((value) => projects.addAll(value));
    setState(() {

    });
  }
  @override
  void initState() {
    print('must be working ');
    getProjects();
    super.initState();
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
          _buildMenuItem(context, "تسجيل خروج", WelcomeScreen()),

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
        if (page is WelcomeScreen) {
          TokenController tokenController=TokenController();
          tokenController.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => page),(route) => false,);
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }},
    );
  }


  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildTitle(),
        SizedBox(height: 20),
        Expanded(child: _buildProjectTable(context)), // عرض جدول المشاريع
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        "المشاريع",
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

  Widget _buildProjectTable(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(label: Text('اسم المشروع', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('اسم صاحب المشروع', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('البريد الإلكتروني', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('تاريخ الإنشاء', style: TextStyle(color: Colors.white))),
          DataColumn(label: Text('الإجراءات', style: TextStyle(color: Colors.white))),
        ],
        rows: projects.map((project) {
          return DataRow(cells: [
            DataCell(Text(project['title']!, style: TextStyle(color: Colors.white))),
            DataCell(Text(project['name']!, style: TextStyle(color: Colors.white))),
            DataCell(Text(project['email']!, style: TextStyle(color: Colors.white))),
            DataCell(Text(ConvertDateAndFormate (project['date']! ), style: TextStyle(color: Colors.white))),

            DataCell(Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      // حذف المشروع من القائمة
                      projects.remove(project);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.visibility, color: Colors.orange),
                  onPressed: () {
                    // الانتقال إلى صفحة تفاصيل المشروع
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProjectDetailsPage(
                        projectId: project['_id'],
                        owner: project['name'],
                        projectName: project['title'],
                        description: project['description'],
                        projectImageUrl: project['image'],
                        city: project['location'],
                        creationDate: project['date'],
                        email: project['email'],
                        website: project['website'],
                        projectField: project['category'],
                        summary: project['summary'],
                        projectStatus: project['isPublic'],
                        currentPhase: project['current_stage'],

                      )),
                    );
                  },
                ),
              ],
            )),
          ]);
        }).toList(),
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