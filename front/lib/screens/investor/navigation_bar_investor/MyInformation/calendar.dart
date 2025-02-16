import 'package:flutter/material.dart';

import '../../../../Widget/investor/investorHeader.dart';
import '../../../../Widget/user_information_header.dart';
import '../../homepageinvestor/HomePageScreeninvestor.dart';
// import 'package:date_picker_timeline/date_picker_timeline.dart';


class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime _selectedValue=DateTime.now();
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
            // أيقونة الصفحة الرئيسية
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>
                    HomePageScreeninvestor()), // استبدل بـ HomePageScreen()
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
            Investorheader(),

            SizedBox(height: 40),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 80.0),
              child: Text(
                'التقويم',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 40),
            // DatePicker(
            //   DateTime.now(),
            //
            //   height: 100,
            //   //initialSelectedDate: DateTime.now(),
            //   selectionColor: Colors.red,
            //   selectedTextColor: Colors.white,
            //   onDateChange: (date) {
            //     setState(() {
            //       _selectedValue = date;
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}


