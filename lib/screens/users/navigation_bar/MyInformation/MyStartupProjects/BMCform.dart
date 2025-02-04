import 'package:flutter/material.dart';
import '../../../../../constants.dart';
import '../../LaunchProject/Stages/Stage2.dart';
import 'MyStartupProjects.dart'; // تأكد من استيراد ملف الثوابت

class BMCformscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Model Canvas',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor, // استخدام الكحلي
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            // إضافة عنوان الصفحة هنا
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'نموذج العمل التجاري',
                style: TextStyle(
                  fontSize: 24, // حجم الخط
                  fontWeight: FontWeight.bold, // جعل الخط عريض
                  color: kPrimaryColor, // لون الخط
                ),
                textAlign: TextAlign.center, // محاذاة النص إلى الوسط
              ),
            ),
            Expanded(
              child: Center(
                child: BusinessModelCanvas(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // توزيع الأزرار
                children: [
                  _buildActionButton(context, label: 'تنزيل', onPressed: () {
                    // هنا يمكنك إضافة وظيفة زر التنزيل في المستقبل
                  }),
                  _buildActionButton(context, label: 'حفظ', onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MyStartupProjectsScreen()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class BusinessModelCanvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey[200], // اللون السكني
        border: Border.all(color: kPrimaryColor, width: 2), // الحدود باللون الكحلي
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2, // ثلثين للقسم العلوي
            child: Row(
              children: [
                Expanded(
                  child: _buildSection('الشركاء الرئيسيون\n(Key Partners)', Icons.group),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildSection('الأنشطة الرئيسية\n(Key Activities)', Icons.work),
                      ),
                      Expanded(
                        child: _buildSection('الموارد الرئيسية\n(Key Resources)', Icons.storage),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildSection('قيمة العرض\n(Value Propositions)', Icons.star),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildSection('علاقات العملاء\n(Customer Relationships)', Icons.chat),
                      ),
                      Expanded(
                        child: _buildSection('القنوات\n(Channels)', Icons.local_shipping),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildSection('شرائح العملاء\n(Customer Segments)', Icons.people),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1, // ثلث للقسم السفلي
            child: Row(
              children: [
                Expanded(
                  child: _buildSection('هيكل التكاليف\n(Cost Structure)', Icons.money),
                ),
                Expanded(
                  child: _buildSection('مصادر الإيرادات\n(Revenue Streams)', Icons.attach_money),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor), // حدود القسم باللون الكحلي
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // لمحاذاة النص إلى الأعلى
        children: [
          SizedBox(height: 8), // مسافة بين العنوان والأيقونة
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // لمحاذاة الأيقونة والنص إلى اليمين
            children: [
              Icon(
                icon,
                size: 24, // حجم الأيقونة
                color: kPrimaryColor, // لون الأيقونة
              ),
              SizedBox(width: 8), // مسافة بين الأيقونة والعنوان
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // خط أصغر
                  textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text(
                'محتوى القسم هنا', // يمكنك إضافة محتوى القسم هنا
                style: TextStyle(fontSize: 12), // خط أصغر لمحتوى القسم
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}