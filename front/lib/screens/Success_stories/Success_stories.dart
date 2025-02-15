import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../basic/footer.dart';
import '../basic/header.dart';
import '../users/navigation_bar/DrawerUsers/DrawerUsers.dart';
import '../users/navigation_bar/NavigationBarUsers.dart';

class SuccessStoriesScreen extends StatefulWidget {
  @override
  _SuccessStoriesScreenState createState() => _SuccessStoriesScreenState();
}

class _SuccessStoriesScreenState extends State<SuccessStoriesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isHovered = false;

  String? selectedContactValue;
  String? selectedValue;
  TextEditingController _searchController = TextEditingController();
  late List<bool> _hoveredStates;

  // بيانات العناصر مع تفاصيل إضافية
  final List<Map<String, String>> _items = [
    {
      "title": " طرقات ",
      "image": "assets/images/Success1.PNG",
      "description":
          "Turqat offers a range of functions and services to have safer travels and a peace of mind.",
      "route": "/page1",
    },
    {
      "title": "سكل زاد",
      "image": "assets/images/Success2.PNG",
      "description":
          " E-learning platform for private tutoring for university students that help them pass their degrees and be prepared for the workforce",
      "route": "/page2",
    },
    {
      "title": "SHIFT-ICT ",
      "image": "assets/images/Success3.PNG",
      "description":
          "SHIFT-ICT is an innovative, technological service provider company that delivers IT services with high quality and competitive cost advantages.",
      "route": "/page3",
    },
    {
      "title": "Developers Plus",
      "image": "assets/images/Success4.PNG",
      "description":
          " We, Developers Plus, are a specialized company in Software Development.",
      "route": "/page4",
    },
    {
      "title": " Algebra Intelligence",
      "image": "assets/images/Success5.PNG",
      "description":
          " Algebra Intelligence is a software development firm that integrates artificial intelligence solutions into the Energy Sector to usher smart technology into sustainable development.",
      "route": "/page5",
    },
    {
      "title": " Newline Tech Company for Information Technology",
      "image": "assets/images/Success6.PNG",
      "description":
          "NEWLINE TECH) is a Palestinian company established early 2011. NEWLINE TECH is dedicated to provide technology-based solutions, In simple terms",
      "route": "/page6",
    },
  ];

  @override
  void initState() {
    super.initState();
    _hoveredStates = List<bool>.filled(_items.length, false);
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
              onSelectContact: (value) {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            const SizedBox(height: 40),
            _buildGrid(), // إضافة المربعات هنا
            const SizedBox(height: 40),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return _buildCircleFrame(index);
        },
      ),
    );
  }

  Widget _buildCircleFrame(int index) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredStates[index] = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredStates[index] = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: _hoveredStates[index] ? Colors.grey[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: _hoveredStates[index]
            ? _buildHoveredContent(index) // تمرير الفهرس للمحتوى عند التحويم
            : _buildInitialContent(
                _items[index]["title"]!, _items[index]["image"]!),
      ),
    );
  }

  Widget _buildInitialContent(String title, String imagePath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 240,
          height: 240,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildHoveredContent(int index) {
    return Stack(
      children: [
        Positioned(
          right: 10,
          top: 10,
          child: ClipOval(
            child: Image.asset(
              _items[index]["image"]!, // استخدام الصورة الخاصة بكل عنصر
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _items[index]["title"]!, // استخدام العنوان الخاص بكل عنصر
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                _items[index]["description"]!, // استخدام الوصف الخاص بكل عنصر
                style: GoogleFonts.poppins(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context,
                      _items[index]["route"]!); // التنقل إلى الصفحة الخاصة
                },
                child: Text(
                  'اقرأ المزيد',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
