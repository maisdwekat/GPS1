import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/date_controller.dart';
import 'package:ggg_hhh/Widget/bmc_widget.dart';

class ProjectDetailsPage extends StatelessWidget {
  // استخدم قيم افتراضية
  final String projectId;
  final String owner;
  final String projectName ;
  final String projectField ;
  final String creationDate ;
  final String city;
  final String currentPhase ;
  final String description;
  final String website ;
  final String email ;
  final String projectImageUrl; // صورة افتراضية
  final String summary ;
  final bool projectStatus ; // أو 'عام'
  ProjectDetailsPage({Key? key,
    required this.projectId,
    required this.owner,
    required this.projectName,
    required this.projectField,
    required this.creationDate,
    required this.city,
    required this.currentPhase,
    required this.description,
    required this.website,
    required this.email,
    required this.projectImageUrl,
    required this.summary,
    required this.projectStatus,
  }) : super(key: key);
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Text('تاريخ إنشاء المشروع:${ConvertDateAndFormate(creationDate)}',
              style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.right,),

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
              'حالة المشروع: ${ projectStatus?'عام':'خاص'}',

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
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'صورة المشروع',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10.0), // مساحة بين الصورة والجملة

                  Image.network(
                    projectImageUrl,
                    height: 200,
                    width: 400,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 4.0), // مساحة بين الصورة والجملة

                ],
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'صورة نموذج العمل',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 4.0), // مساحة بين الصورة والجملة

                BmcWidget.pre(id: projectId),
                // Image.network(
                //   businessModelImageUrl,
                //   height: 200,
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                // ),

              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'ملخص عن المشروع: $summary',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 100),

          ],
        ),
      ),
    );
  }
}