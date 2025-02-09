import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ggg_hhh/Controllers/date_controller.dart';
import 'package:intl/intl.dart';
import '../../Controllers/GrantController.dart';
import '../../Controllers/token_controller.dart';
import '../../constants.dart';
import '../Welcome/welcome_screen.dart';
import 'ActiveUsersTable.dart';
import 'FeedbackPage.dart';
import 'Courses.dart';
import 'Dashboard.dart';
import 'IdeasPage.dart';
import 'Notifications.dart';
import 'ProjectsPage.dart';
import 'UsersPage.dart';
import 'chatscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
List<dynamic> grants = [];
class Grantpage extends StatefulWidget {
  @override
  _GrantpageState createState() => _GrantpageState();
}

class _GrantpageState extends State<Grantpage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameOfCompanyController = TextEditingController();
  final TextEditingController nameOfGrantController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController DateOfEndoFGrant = TextEditingController();

  Grantcontroller grantcontroller = Grantcontroller();


  void addgrant() async {
    var result = await grantcontroller.addGrant(
      nameOfCompanyController.text,
    nameOfGrantController.text,
    descriptionController.text,
    DateOfEndoFGrant.text,
    );
    nameOfCompanyController.text='';
    nameOfGrantController.text='';
    descriptionController.text='';
    DateOfEndoFGrant.text='';
    if (result != null && result['success']) {
      print("Idea added successfully!");

      _showSuccessDialog();
    } else {
      print("Failed to add grant: ${result?['message']}");
      Fluttertoast.showToast(
        msg: "Failed to add grant: ${result?['message']}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Your idea has been added successfully."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
  TokenController token =TokenController();

  Future<void> _fetchGrants() async {
    final savedToken =await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      //return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    try{
      final response = await http.get(
        Uri.parse('http://$ip:4000/api/v1/grant/all'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          grants = (jsonResponse['getAll'] as List).map((grant) {
            return {
              '_id': grant['_id'],
              'nameOfCompany': grant['nameOfCompany'],  // تعديل هنا
              'nameOfGrant': grant['nameOfGrant'],  // تعديل هنا
              'description': grant['description'],  // تعديل هنا
              'DateOfEndoFGrant': grant['DateOfEndoFGrant'],  // تعديل هنا
            };
          }).toList();
        });

        print("$grants");
      } else {
        // يمكنك إضافة معالجة الأخطاء هنا
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في جلب البيانات')),
        );
      }} catch (error) {
      print('Error: $error');
      //return {'success': false, 'message': "An error occurred"};
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(child: _buildMainContent(context,_fetchGrants)),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context,_fetchGrants) {
    return Center(
      child: Column(
        children: [
          _buildHeader(),
          _buildTitle(),
          SizedBox(height: 8), // Add some space between header and button
          _buildAddGrantButton(_fetchGrants), // Add the button here
          SizedBox(height: 8), // Add some space between header and button
          Expanded(child: GrantTable()),
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


  Widget _buildAddGrantButton(_fetchGrants) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0), // مسافة بين الزر والحافة اليمنى
        child: GestureDetector(
          onTap: () {
            _showAddGrantDialog(_fetchGrants);
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

  void _showAddGrantDialog(_fetchGrants) {
    // final TextEditingController websiteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1C1C1C),
          title: Text("إضافة منحة", style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: 400, // زيادة عرض النموذج
            child: SingleChildScrollView(
              child: Form(
                key:formKey ,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      controller: nameOfCompanyController,
                      decoration: InputDecoration(
                        hintText: "اسم الشركة ",
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Color(0xFF4A4A4A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: nameOfGrantController,
                      decoration: InputDecoration(
                        hintText: "اسم المنحة",
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Color(0xFF4A4A4A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "الوصف",
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Color(0xFF4A4A4A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: DateOfEndoFGrant,
                      readOnly: true,
                      onTap: (){
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            setState(() {
                              print(selectedDate);
                              DateOfEndoFGrant.text =dateFormater(selectedDate);

                            });
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "تاريخ انتهاء التقديم",
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Color(0xFF4A4A4A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 10),
                    // TextField(
                    //   controller: websiteController,
                    //   decoration: InputDecoration(
                    //     hintText: "رابط التقديم",
                    //     hintStyle: TextStyle(color: Colors.white54),
                    //     filled: true,
                    //     fillColor: Color(0xFF4A4A4A),
                    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("إضافة", style: TextStyle(color: Colors.white)),
              onPressed: () {
                if(formKey.currentState!.validate()){
                setState(() {
                  grants.clear();
                  _fetchGrants();
                  addgrant();

                });
                Navigator.of(context).pop();
              }
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
}

class GrantTable extends StatefulWidget {
  @override
  State<GrantTable> createState() => _GrantTableState();
}

class _GrantTableState extends State<GrantTable> {

 // تغيير نوع المتغير
  TokenController token =TokenController();

  Future<void> _fetchGrants() async {
    final savedToken =await token.getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      //return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    try{
      final response = await http.get(
        Uri.parse('http://$ip:4000/api/v1/grant/all'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          grants = (jsonResponse['getAll'] as List).map((grant) {
            return {
              '_id': grant['_id'],
              'nameOfCompany': grant['nameOfCompany'],  // تعديل هنا
              'nameOfGrant': grant['nameOfGrant'],  // تعديل هنا
              'description': grant['description'],  // تعديل هنا
              'DateOfEndoFGrant': grant['DateOfEndoFGrant'],  // تعديل هنا
            };
          }).toList();
        });

        print("$grants");
      } else {
        // يمكنك إضافة معالجة الأخطاء هنا
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في جلب البيانات')),
        );
      }} catch (error) {
      print('Error: $error');
      //return {'success': false, 'message': "An error occurred"};
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchGrants(); // جلب البيانات عند بدء الصفحة
  }

  @override
  Widget build(BuildContext context) {
    Grantcontroller grantcontroller = Grantcontroller();
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
                DataColumn(label: Text("اسم الشركة", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("اسم المنحة ", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text(" الوصف", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("تاريخ انتهاء التقديم", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text("الإجراءات", style: TextStyle(color: Colors.white))),
              ],
              rows: grants.map((grant) {
                return DataRow(cells: [
                  DataCell(Text(grant["nameOfGrant"]!, style: TextStyle(color: Colors.white))),
                  DataCell(Text(grant["nameOfCompany"]!, style: TextStyle(color: Colors.white))),
                  DataCell(Text(grant["description"]!, style: TextStyle(color: Colors.white))),
                  DataCell(Text(ConvertDateAndFormate(grant["DateOfEndoFGrant"]!), style: TextStyle(color: Colors.white))),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            grantcontroller.deletegrant( grant["_id"]);
                            grants.removeWhere((element) =>  element["_id"] == grant["_id"]);
                            setState(() {

                            });


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
////////////////////////////////////////////////////////
