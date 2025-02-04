import 'package:flutter/material.dart';
import '../../../basic/footer.dart';
import '../../../basic/header.dart';
import '../DrawerUsers/DrawerUsers.dart';
import '../NavigationBarUsers.dart';
import 'Stages/Stage1.dart';
import 'Stages/Stage2.dart';
import 'Stages/Stage3.dart';
import 'Stages/Stage4.dart';
import 'Stages/Stage5.dart';

class FirstStepOfJourneyScreen extends StatefulWidget {
  const FirstStepOfJourneyScreen({super.key});

  @override
  _FirstStepOfJourneyScreenState createState() => _FirstStepOfJourneyScreenState();
}

class _FirstStepOfJourneyScreenState extends State<FirstStepOfJourneyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedContactValue;
  String? selectedValue;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'اختر المرحلة الحالية لمشروعك',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            _buildContent(), // Add this line for the new content
            const SizedBox(height: 40),
            Footer(),
          ],
        ),
      ),
    );
  }
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBox('المرحلة الثالثة : التمويل والتأمين', 'assets/images/finance.jpg', context, FinancingScreen()),
              _buildBox('المرحلة الثانية : التحقق والتخطيط', 'assets/images/Planning.jpg', context, PlanningScreen()),
              _buildBox('المرحلة الأولى : دراسة الفكرة', 'assets/images/idea.jpg', context, StudyTheIdeaScreen()),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centering both boxes
            children: [
              _buildBox('المرحلة الخامسة : الإطلاق والنمو', 'assets/images/growth.jpg', context, LaunchAndGrowthScreen()),
              const SizedBox(width: 16), // Spacing between boxes
              _buildBox('المرحلة الرابعة : تأسيس الفريق والموارد', 'assets/images/team.jpg', context, TeamFormationScreen()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBox(String title, String imagePath, BuildContext context, Widget destinationScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3 - 48, // Adjust width for smaller boxes
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100], // Light gray color
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Center title here
            ),
            const SizedBox(height: 10), // Space between title and image
            Image.asset(
              imagePath, // Image path passed as an argument
              width: 300, // Adjust width as needed
              height: 100, // Adjust height as needed
            ),
          ],
        ),
      ),
    );
  }
}