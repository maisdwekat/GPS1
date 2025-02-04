import 'package:flutter/material.dart';

import '../../../../constants.dart';

class RequestFormScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor, // لون كحلي
        iconTheme: IconThemeData(
          color: Colors.white, // لون السهم باللون الأبيض
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 700, // عرض المستطيل الخارجي
              decoration: BoxDecoration(
                color: Colors.grey[200], // خلفية مستطيل سكني
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // محاذاة النصوص إلى اليمين
                children: [
                  // عنوان الصفحة
                  Text(
                    'نموذج الطلب ',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right, // محاذاة العنوان إلى اليمين
                  ),
                  SizedBox(height: 20), // مسافة بين العنوان والمحتوى
                  Text(
                    'معلومات المستثمر-',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right, // محاذاة العنوان إلى اليمين
                  ),
                  SizedBox(height: 20),
                  _buildLabeledTextField('اسم المستثمر'),
                  SizedBox(height: 10),
                  _buildLabeledTextField('البريد الإلكتروني'),
                  SizedBox(height: 20),
                  Text(
                    ' تفاصيل الاستثمار -',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right, // محاذاة العنوان إلى اليمين
                  ),
                  SizedBox(height: 20),
                  _buildLabeledTextField('اسم المشروع'),
                  SizedBox(height: 10),
                  _buildLabeledTextField('مبلغ الاستثمار'),
                  SizedBox(height: 10),
                  _buildLabeledTextField('نوع الاستثمار'),
                  SizedBox(height: 10),
                  _buildLabeledTextField('تاريخ البدء بالاستثمار'),
                  SizedBox(height: 10),
                  _buildLabeledTextField('تاريخ الاستحقاق'),
                  SizedBox(height: 10),
                  _buildLabeledTextField('نسبة الاستثمار'),
                  SizedBox(height: 10),
                  _buildLabeledTextField('مدة الاستثمار'),
                  SizedBox(height: 20),
                  _buildLabeledTextField('ملاحظات إضافية', maxLines: 3),
                  SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // محاذاة النصوص إلى اليمين
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          width: 300, // عرض المستطيل الذي يحتوي على الإجابة
          child: TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '',
            ),
          ),
        ),
      ],
    );
  }
}