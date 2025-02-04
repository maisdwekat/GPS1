import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../constants.dart';
import '../../../basic/footer.dart';
import '../../../basic/header.dart';
import '../DrawerUsers/DrawerUsers.dart';
import '../NavigationBarUsers.dart';
import 'FirstStepOfJourney.dart';

class LaunchProjectScreen extends StatefulWidget {
  @override
  _LaunchProjectScreenState createState() => _LaunchProjectScreenState();
}

class _LaunchProjectScreenState extends State<LaunchProjectScreen> {
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
            _buildLaunchJourneySection(),
            const SizedBox(height: 40),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildLaunchJourneySection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'رحلة احتضان المشاريع الناشئة',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ستساعدك حاضنة ستارت أب على إطلاق مشروعك الناشئ وتسير معك خطوة بخطوة، وتقدم لك الإرشاد عند الحاجة. إن كانت لديك فكرة مشروع ناشئ لا تنتظر، ابدأ رحلة الاحتضان الآن.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirstStepOfJourneyScreen()), // تغيير هذا إلى الشاشة الجديدة
                );
              },
              style: ElevatedButton.styleFrom(
                iconColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'ابدأ رحلة الاحتضان',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}