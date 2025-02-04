import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../basic/footer.dart';
import '../../basic/header.dart';
import '../navigation_bar/DrawerUsers/DrawerUsers.dart';
import '../navigation_bar/NavigationBarUsers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GrantsPage extends StatefulWidget {
  const GrantsPage({super.key});

  @override
  _GrantsPageState createState() => _GrantsPageState();
}

class _GrantsPageState extends State<GrantsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> grants = []; // تغيير نوع المتغير

  @override
  void initState() {
    super.initState();
    _fetchGrants(); // جلب البيانات عند بدء الصفحة
  }

  Future<void> _fetchGrants() async {
    final response = await http.get(
      Uri.parse('https://your-backend-url.com/api/grants'), // استبدل بعنوان URL الخاص بك
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        grants = jsonResponse.map((grant) {
          return {
            'institution': grant['institution'],
            'title': grant['title'],
          };
        }).toList();
      });
    } else {
      // يمكنك إضافة معالجة الأخطاء هنا
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في جلب البيانات')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D47),
      ),
      drawer: DrawerUsers(scaffoldKey: _scaffoldKey), // استدعاء Drawer
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderScreen(), // استدعاء الهيدر
            NavigationBarUsers(
              scaffoldKey: _scaffoldKey,
              onSelectContact: (value) {
                // منطق لتحديد جهة الاتصال
              },
            ),
            const SizedBox(height: 40),
            Column(
              children: grants.map((grant) => _buildGrantCard(grant)).toList(),
            ),
            const SizedBox(height: 40),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrantCard(Map<String, dynamic> grant) { // تغيير نوع المعامل
    return Container(
      width: 800, // عرض المستطيل
      margin: EdgeInsets.only(bottom: 20), // إضافة مسافة بين المستطيلات
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // تغير موقع الظل
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150, // تحديد عرض الزر
            child: ElevatedButton(
              onPressed: () {
                // هنا يمكنك إضافة الوظيفة لزر "تقديم الآن"
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم الضغط على تقديم الآن')),
                );
              },
              child: Text('تقديم الآن'),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // تعديل إلى start
            children: [
              Text(
                grant['institution'], // استخدام نوع dynamic
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                grant['title'], // استخدام نوع dynamic
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}