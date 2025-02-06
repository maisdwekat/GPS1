import 'package:flutter/material.dart';
import '../../../../../Controllers/BMCcontroller.dart';
import '../../../../../constants.dart';
import '../../LaunchProject/Stages/Stage2.dart';
import 'MyStartupProjects.dart'; // تأكد من استيراد ملف الثوابت

class BMCformscreen extends StatefulWidget {
  @override
  _BMCformscreenState createState() => _BMCformscreenState();
}

class _BMCformscreenState extends State<BMCformscreen> {
  final List<TextEditingController> _controllers = List.generate(9, (index) => TextEditingController());
  final BMCcontroller _bmcController = BMCcontroller();

  @override
  void initState() {
    super.initState();
    _loadBusinessCanva();
  }

  Future<void> _loadBusinessCanva() async {
    final result = await _bmcController.getBusinessCanva("6790e05564da1d62885f5e00");
    if (result != null && result['success']) {
      var data = result['data'];

      // تحديث المحتوى الخاص بالأقسام بناءً على البيانات المسترجعة
      _controllers[0].text = (data['keyPartners'] as List<dynamic>).join(", ") ?? "";
      _controllers[1].text = (data['keyActivities'] as List<dynamic>).join(", ") ?? "";
      _controllers[2].text = (data['keyResources'] as List<dynamic>).join(", ") ?? "";
      _controllers[3].text = (data['valuePropositions'] as List<dynamic>).join(", ") ?? "";
      _controllers[4].text = (data['customerRelationships'] as List<dynamic>).join(", ") ?? "";
      _controllers[5].text = (data['channels'] as List<dynamic>).join(", ") ?? "";
      _controllers[6].text = (data['customerSegments'] as List<dynamic>).join(", ") ?? "";
      _controllers[7].text = (data['costStructure'] as List<dynamic>).join(", ") ?? "";
      _controllers[8].text = (data['revenueStreams'] as List<dynamic>).join(", ") ?? "";

      setState(() {});
    } else {
      // معالجة الأخطاء أو عرض رسالة للمستخدم
      print(result?['message']);
    }
  }

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'نموذج العمل التجاري',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Center(
                child: BusinessModelCanvas(controllers: _controllers),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(context, label: 'تنزيل', onPressed: () {
                    // هنا يمكنك إضافة وظيفة زر التنزيل في المستقبل
                  }),
                  _buildActionButton(context, label: 'حفظ', onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyStartupProjectsScreen()),
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
              child: TextField(
                controller: controller,
                maxLines: null, // يسمح بإظهار عدة أسطر
                decoration: InputDecoration(
                  border: InputBorder.none, // إزالة الحدود من TextField
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12), // حجم الخط
              ),
            ),
          ),
        ],
      ),
    );
  }
}