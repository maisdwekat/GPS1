import 'package:flutter/material.dart';

class IdeaDetailsPage extends StatelessWidget {

  final String description;
  final String field;
  final String email; // إضافة متغير البريد الإلكتروني
  final bool status; // إضافة متغير حالة الفكرة

  IdeaDetailsPage({
   required this.description ,
    required this.field ,
    required this.email ,
    required this.status , // القيمة الافتراضية لحالة الفكرة
  });


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B), // لون خلفية من درجات الأسود
      appBar: AppBar(
        title: Text(
          'تفاصيل الفكرة',
          style: TextStyle(color: Colors.white), // تغيير لون النص إلى الأبيض
        ),
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // سهم الرجوع أبيض
          onPressed: () {
            Navigator.pop(context); // العودة للخلف
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 16),
            Text(
              'شرح مبسط عن الفكرة: $description',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'مجال الفكرة: $field',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'البريد الإلكتروني: $email',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'حالة الفكرة: ${status?'عام':'خاص'}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}