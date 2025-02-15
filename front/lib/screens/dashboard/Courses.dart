import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ggg_hhh/Controllers/date_controller.dart';
import '../../Controllers/CoursesController.dart';
import '../../Controllers/token_controller.dart';
import '../../Widget/admin/sidebar.dart';

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  CoursesController courseController = CoursesController();

  List<dynamic> courses = [];
  final CoursesController _coursesController = CoursesController();
  final companyController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  TokenController token =TokenController();
  @override
  void initState() {
    super.initState();
    fetchCourses(); // جلب الدورات عند بدء الشاشة
  }

  Future<void> fetchCourses() async {
    try {
        courses = await courseController.getAllCourses();
      setState(() {
        courses = courses.map((course) {
          return {
            '_id': course['_id']?.toString() ?? '',
            'nameOfCompany': course['nameOfCompany']?.toString() ?? '',
            'nameOfEducationalCourse': course['nameOfEducationalCourse']?.toString() ?? '',
            'description': course['description']?.toString() ?? '',
            'DateOfCourse': course['DateOfCourse']?.toString() ?? '',
          };
        }).toList();
      });
    } catch (e) {
      print('Error: $e');
    }
  }


  void _showAddCourseDialog(BuildContext context) {
    String date;
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
                  _buildTextField(companyController, "اسم الشركة"),
                  SizedBox(height: 10),
                  _buildTextField(nameController, "اسم الدورة"),
                  SizedBox(height: 10),
                  _buildMultilineTextField(descriptionController, "الوصف"),
                  SizedBox(height: 10),
                  _buildTextField(dateController, "تاريخ الدورة",readOnly: true, onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        date = pickedDate.toString();
                        dateController.text = ConvertDateAndFormate(date);
                      });
                    }
                  }),
                  SizedBox(height: 10),
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
                date=DateTime.parse(dateController.text).toIso8601String();
                var result = await courseController.addCourse(
                  companyController.text,
                  nameController.text,
                  descriptionController.text,
                  date,
                );
                Navigator.pop(context); // العودة للصفحة السابقة


                if (result != null) {
                  print("Courses added successfully!");
                  _showSuccessDialog();
                  courses.add({
                    'nameOfCompany': companyController.text,
                    'nameOfEducationalCourse': nameController.text,
                    'description': descriptionController.text,
                    'DateOfCourse': date,
                  });

                  setState(() {});
                } else {
                  print("Failed to add course: ${result?['message']}");
                  Fluttertoast.showToast(
                    msg: "Failed to add course: ${result?['message']}",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );

                }

              },
            ),
          ],
        );
      },
    );
  }


  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Course has been added successfully."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }




  Widget _buildTextField(TextEditingController controller, String hint,{bool readOnly = false,final onTap}) {
    return TextField(
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Color(0xFF4A4A4A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildMultilineTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
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
          DataColumn(label: Text('الإجراءات', style: TextStyle(color: Colors.white))),
        ],
        rows: courses.map<DataRow>((course) {
          return DataRow(cells: [
            DataCell(Text(course['nameOfCompany']!, style: TextStyle(color: Colors.white))),
            DataCell(Text(course['nameOfEducationalCourse']!, style: TextStyle(color: Colors.white))),
            DataCell(Text(course['description']!, style: TextStyle(color: Colors.white))),
            DataCell(Text(ConvertDateAndFormate(course['DateOfCourse']!), style: TextStyle(color: Colors.white))),
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
                  onPressed: ()async {
                   await courseController.deleteCourse( course["_id"]);
                    courses.removeWhere((element) =>  element["_id"] == course["_id"]);
                    setState(() {

                    });


                  },
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Future<void> _deleteCourse(String id) async {
    print("delete Course : ");
    try {
      await _coursesController.deleteCourse(id);
      // fetchCourses(); // تحديث قائمة الدورات بعد الحذف
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showEditCourseDialog(BuildContext context, dynamic course) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        companyController.text = course['nameOfCompany'];
        nameController.text = course['nameOfEducationalCourse'];
        descriptionController.text = course['description'];
        String date = course['DateOfCourse'];
        dateController.text = ConvertDateAndFormate(date);
        return AlertDialog(
          title: Text("تعديل دورة", style: TextStyle(color: Colors.white)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Color(0xFF3A3A3A),
          content: SingleChildScrollView(
            child: Container(
              width: 400,
              child: Column(
                children: [
                  _buildTextField(companyController, "اسم الشركة"),
                  SizedBox(height: 10),
                  _buildTextField(nameController, "اسم الدورة"),
                  SizedBox(height: 10),
                  _buildMultilineTextField(descriptionController, "الوصف"),
                  SizedBox(height: 10),
                  _buildTextField(dateController, "تاريخ الدورة", readOnly: true,onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      date=pickedDate.toString();
                      String formattedDate = dateFormater(pickedDate);
                      setState(() {
                        dateController.text = formattedDate;
                      });
                    }
                  }),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("إلغاء", style: TextStyle(color: Colors.white)),
              onPressed: () {
                companyController.clear();
                nameController.clear();
                descriptionController.clear();
                dateController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("تعديل", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                final res=await courseController.updateCourse(
                  corseid:course["_id"],
                  nameOfCompany: companyController.text,
                  description: descriptionController.text,
                  DateOfCourse: date,
                  nameOfEducationalCourse: nameController.text,
                                  );
                companyController.clear();
                nameController.clear();
                descriptionController.clear();
                dateController.clear();
                Navigator.pop(context); // العودة للصفحة السابقة
                  if(res!=null){
                    _showSuccessDialog();
                    courses.clear();
                    fetchCourses();
                    setState(() {

                    });
                  }
                  else{

                  }

              },
            ),
          ] ,
        );
      },
    );
  }



  Widget _buildMainContent(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildTitle(),
        _buildAddCourseButton(context),
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
          Sidebar(),
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