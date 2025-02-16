import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../Controllers/ProjectController.dart';
import '../../../../../Widget/user_information_header.dart';
import '../../../homepageUsers/HomePageScreenUsers.dart';
import 'AddStartupProject.dart';
import '../MyAccount.dart';
import '../MyIdeas/MyIdeas.dart';
import 'PreviewProject.dart';

class MyStartupProjectsScreen extends StatefulWidget {
  @override
  _MyStartupProjectsScreenState createState() =>
      _MyStartupProjectsScreenState();
}

class _MyStartupProjectsScreenState extends State<MyStartupProjectsScreen> {
  String _profileImage = ''; // Variable to store the profile image path

  ProjectController _projectController = ProjectController();

  @override
  void initState() {
    super.initState();
    projectGet(); // Fetch projects when the screen starts
  }

  List<Map<String, dynamic>> _projects = [];

  Future<void> projectGet() async {
    print("projectGet() called");

    List<Map<String, dynamic>>? projects =
        await _projectController.getAllForUser();
    if (projects == null) {
      print("❌ فشل في جلب المشاريع!");
      setState(() {
        _projects = []; // Set the list to empty
      });
    } else if (projects.isEmpty) {
      print("✅ لا توجد مشاريع متاحة.");
      setState(() {
        _projects = []; // Set the list to empty
      });
    } else {
      print("✅ تم جلب المشاريع:");
      setState(() {
        _projects = projects; // Assign the fetched projects
      });
      for (var project in projects) {
        print(
            "📌 title:  ${project['title']}, ispublic : ${project['isPublic']}, category: ${project['category']}, image: ${project['image']}");
      }
    }
  }

  // Image picker function


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D47),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => homepagescreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color(0xFF0A1D47),
              height: 30,
            ),
            UserInformationHeader(),
            Container(
              height: 2,
              color: Color(0xFF0A1D47),
            ),
            Container(
              color: Colors.grey[200],
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyIdeasScreen()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Text('أفكاري',
                          style: TextStyle(color: Color(0xFF001F3F))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyStartupProjectsScreen()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Text('مشاريعي الناشئة',
                          style: TextStyle(color: Color(0xFF001F3F))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: Text('حسابي',
                          style: TextStyle(color: Color(0xFF001F3F))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 2,
              color: Color(0xFF0A1D47),
            ),
            SizedBox(height: 40),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 80.0),
              child: Text(
                'مشاريعي الناشئة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 25, // Space between the items
              runSpacing: 20, // Space between the rows
              alignment: WrapAlignment.end, // Align items to the right
              children: [
                // New project square
                Container(
                  width: 250,
                  height: 350,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: Text(
                          '+',
                          style:
                              TextStyle(fontSize: 60, color: Color(0xFF0A1D47)),
                        ),
                      ),
                      SizedBox(height: 55),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddStartupProjectScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0A1D47),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text('إنشاء مشروع جديد',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                // Displaying the user's projects dynamically
                ...List.generate(_projects.length, (index) {
                  return Container(
                    width: 250,
                    height: 400,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                _projectController
                                    .deleteProject(_projects[index]['_id']);
                                _projects.removeAt(index);
                                setState(() {});
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                        Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: _projects[index]['image'] != null
                                  ? NetworkImage(_projects[index]['image'])
                                  : AssetImage('assets/images/111.jpg')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          _projects[index]['title'] ?? 'اسم المشروع',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          _projects[index]['category'] ?? 'مجال المشروع',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 150,
                          height: 2,
                          color: Color(0xFFE0E0E0),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PreviewProjectScreen(
                                                  projectId:

                                                  _projects[index]['_id'])));

                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0A1D47),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text('معاينة',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddStartupProjectScreen
                                                    .toUpdate(
                                                        projectID:
                                                            _projects[index]['_id'])));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0A1D47),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text('تعديل',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _projects[index]['isPublic'] ? 'عام': 'خاص',

                          style: TextStyle(fontSize: 14, color: Colors.green),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
