import 'package:flutter/material.dart';

class ProjectDetailsPage extends StatelessWidget {
  // استخدم قيم افتراضية
  final String projectName = 'اسم المشروع غير متوفر';
  final String projectField = 'مجال المشروع غير متوفر';
  final String creationDate = 'تاريخ الإنشاء غير متوفر';
  final String city = 'المدينة غير متوفرة';
  final String currentPhase = 'المرحلة الحالية غير متوفرة';
  final String description = 'لا يوجد وصف متاح';
  final String website = 'غير متوفر';
  final String email = 'غير متوفر';
  final String projectImageUrl = 'https://via.placeholder.com/200'; // صورة افتراضية
  final String businessModelImageUrl = 'https://via.placeholder.com/200'; // صورة افتراضية
  final String summary = 'ملخص المشروع غير متوفر';
  final String projectStatus = 'خاص'; // أو 'عام'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B), // لون خلفية من درجات الأسود
      appBar: AppBar(
        title: Text(
          'تفاصيل المشروع',
          style: TextStyle(color: Colors.white), // تغيير لون النص إلى الأبيض
        ),
        backgroundColor: Colors.grey[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // سهم الرجوع أبيض
          onPressed: () {
            Navigator.pop(context); // العودة للخلف
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'اسم المشروع: $projectName',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16.0), // زيادة المسافة بين الحقول
            Text(
              'مجال المشروع: $projectField',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16.0),
            Text(
              'تاريخ إنشاء المشروع: $creationDate',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16.0),
            Text(
              'المدينة: $city',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16.0),
            Text(
              'المرحلة الحالية للمشروع: $currentPhase',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16.0),
            Text(
              'حالة المشروع: $projectStatus',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16.0),
            Text(
              'شرح مبسط عن المشروع: $description',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16.0),
            Text(
              'الموقع الإلكتروني: $website',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16.0),
            Text(
              'الإيميل: $email',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.network(
                  projectImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 4.0), // مساحة بين الصورة والجملة
                Text(
                  'صورة المشروع',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.network(
                  businessModelImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 4.0), // مساحة بين الصورة والجملة
                Text(
                  'صورة نموذج العمل',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'ملخص عن المشروع: $summary',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}