import 'package:flutter/material.dart';
import '../../../../../Controllers/BMCcontroller.dart';
import '../../../../../Widget/bmc_widget.dart';
import '../../../../../constants.dart';
import '../../LaunchProject/Stages/Stage2.dart';
import 'MyStartupProjects.dart'; // تأكد من استيراد ملف الثوابت

class BMCformscreen extends StatefulWidget {
  String id;
  BMCformscreen({required this.id});
  @override
  _BMCformscreenState createState() => _BMCformscreenState();
}

class _BMCformscreenState extends State<BMCformscreen> {




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
        body:
        BmcWidget(id: widget.id,),
      ),
    );
  }

}

class BusinessModelCanvas extends StatelessWidget {
  final List<TextEditingController> controllers;

  BusinessModelCanvas({required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: kPrimaryColor, width: 2),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: _buildSection('الشركاء الرئيسيون\n(Key Partners)', Icons.group, controllers[0]),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildSection('الأنشطة الرئيسية\n(Key Activities)', Icons.work, controllers[1]),
                      ),
                      Expanded(
                        child: _buildSection('الموارد الرئيسية\n(Key Resources)', Icons.storage, controllers[2]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildSection('قيمة العرض\n(Value Propositions)', Icons.star, controllers[3]),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildSection('علاقات العملاء\n(Customer Relationships)', Icons.chat, controllers[4]),
                      ),
                      Expanded(
                        child: _buildSection('القنوات\n(Channels)', Icons.local_shipping, controllers[5]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildSection('شرائح العملاء\n(Customer Segments)', Icons.people, controllers[6]),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: _buildSection('هيكل التكاليف\n(Cost Structure)', Icons.money, controllers[7]),
                ),
                Expanded(
                  child: _buildSection('مصادر الإيرادات\n(Revenue Streams)', Icons.attach_money, controllers[8]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 24,
                color: kPrimaryColor,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: 200, // عرض الحقل
              height: 100, // ارتفاع الحقل
              decoration: BoxDecoration(
                // لا حاجة لتعيين حدود هنا
                // إذا أردت، يمكنك إضافة لون خلفية أو أي خصائص أخرى
              ),
              child: Center(
                child: Text(
                  controller.text,
                  style: TextStyle(fontSize: 12), // حجم الخط
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}