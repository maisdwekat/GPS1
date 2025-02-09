import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/token_controller.dart';
import '../Welcome/welcome_screen.dart';
import '../investor/homepageinvestor/HomePageScreeninvestor.dart';
import '../users/homepageUsers/HomePageScreenUsers.dart';
import 'IdeaDetailsPage.dart';
import 'ProjectDetailsPage.dart';
import 'ProjectsPage.dart';
import 'UsersPage.dart';
import 'Courses.dart';
import 'FeedbackPage.dart';
import 'Grants.dart';
import 'IdeasPage.dart';
import 'Notifications.dart';
import 'ActiveUsersTable.dart';
import 'chatscreen.dart';

class DashboardPage extends StatelessWidget {
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
        _buildHeader(context),
        _buildTitle(),
        Expanded(child: UserRequestTable()),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        "الطلبات المرسلة",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFF2B2B2B),
      ),
      child: Row(
        children: [
          // مستطيل عرض كما يظهر للمستخدم
          GestureDetector(
            onTap: () {
              // الانتقال إلى الصفحة الرئيسية للمستخدم
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => homepagescreen()), // استبدلها بالصفحة الخاصة بالمستخدم
              );
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "عرض كما يظهر للمستخدم",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          SizedBox(width: 20), // مسافة بين المستطيلين
          // مستطيل عرض كما يظهر للمستثمر
          GestureDetector(
            onTap: () {
              // الانتقال إلى الصفحة الرئيسية للمستثمر
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePageScreeninvestor()), // استبدلها بالصفحة الخاصة بالمستثمر
              );
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "عرض كما يظهر للمستثمر",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
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

class UserRequestTable extends StatefulWidget {
  @override
  _UserRequestTableState createState() => _UserRequestTableState();
}

class _UserRequestTableState extends State<UserRequestTable> {
  List<Map<String, String>> requests = [
    {'user': 'أحمد', 'type': 'نشر فكرة', 'email': 'user1@example.com'},
    {'user': 'عبير', 'type': 'نشر مشروع', 'email': 'user2@example.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            width: 900,
            decoration: BoxDecoration(
              color: Color(0xFF4A4A4A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DataTable(
              columnSpacing: 8,
              horizontalMargin: 10,
              dataRowHeight: 48,
              columns: [
                DataColumn(label: Text("اسم المستخدم", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("طلب التقديم", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("البريد الإلكتروني", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("الإجراءات", style: TextStyle(color: Colors.white))),
              ],
              rows: requests.map((request) {
                return _createRow(request, context);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _createRow(Map<String, String> request, BuildContext context) {
    String userInitial = request['user']!;
    String requestType = request['type']!;
    String email = request['email']!;

    Color requestColor;

    switch (requestType) {
      case "نشر فكرة":
        requestColor = Colors.green;
        break;
      case "نشر مشروع":
        requestColor = Colors.blue;
        break;
      default:
        requestColor = Colors.grey;
    }

    return DataRow(
      cells: [
        DataCell(Text(userInitial, style: TextStyle(color: Colors.white))),
        DataCell(
          Container(
            width: 150,
            color: requestColor.withOpacity(0.5),
            padding: EdgeInsets.all(8),
            child: Text(requestType, style: TextStyle(color: Colors.white)),
          ),
        ),
        DataCell(Text(email, style: TextStyle(color: Colors.white))),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.check_circle, color: Colors.green),
                onPressed: () {
                  // إرسال إشعار بالموافقة
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تمت الموافقة على طلبك')),
                  );

                  // إزالة الطلب من القائمة
                  setState(() {
                    requests.remove(request);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  // إرسال إشعار بالرفض
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم رفض الطلب')),
                  );

                  // إزالة الطلب من القائمة
                  setState(() {
                    requests.remove(request);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.visibility, color: Colors.blue),
                onPressed: () {
                  // الانتقال إلى الصفحة المناسبة حسب نوع الطلب
                  Widget page;

                  if (requestType == "نشر فكرة") {
                    page = IdeaDetailsPage(); // صفحة تفاصيل الفكرة
                  } else if (requestType == "نشر مشروع") {
                    page = ProjectDetailsPage(); // صفحة تفاصيل المشروع
                  } else {
                    // يمكنك تعيين صفحة افتراضية هنا
                    page = DashboardPage(); // استبدل هذا بصفحة افتراضية مناسبة
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}