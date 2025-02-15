import 'package:flutter/material.dart';

import '../Controllers/BMCcontroller.dart';
import '../constants.dart';
import '../screens/users/navigation_bar/MyInformation/MyStartupProjects/BMCform.dart';
import '../screens/users/navigation_bar/MyInformation/MyStartupProjects/MyStartupProjects.dart';

class BmcWidget extends StatefulWidget {
  String id;
   BmcWidget({super.key,required this.id});
   BmcWidget.pre({ this.isPre = true, required this.id});
   bool isPre = false ;

  @override
  State<BmcWidget> createState() => _BmcWidgetState();
}

class _BmcWidgetState extends State<BmcWidget> {
   List<TextEditingController> _controllers =[];

   final BMCcontroller _bmcController = BMCcontroller();
   @override
   void initState() {
     super.initState();
     _loadBusinessCanva();
     print (_controllers);
   }

  Future<void> _loadBusinessCanva() async {
    final result = await _bmcController.getBusinessCanva(widget.id);
    if (result != null && result['success']) {
      var data = result['data'];

      // تحديث المحتوى الخاص بالأقسام بناءً على البيانات المسترجعة
      _controllers.add(TextEditingController(text: data['keyPartners'].first.toString()));
      _controllers.add(TextEditingController(text: data['keyActivities'].first.toString()));
      _controllers.add(TextEditingController(text: data['keyResources'].first.toString()));
      _controllers.add(TextEditingController(text: data['valuePropositions'].first.toString()));
      _controllers.add(TextEditingController(text: data['customerRelationships'].first.toString()));
      _controllers.add(TextEditingController(text: data['channels'].first.toString()));
      _controllers.add(TextEditingController(text: data['customerSegments'].first.toString()));
      _controllers.add(TextEditingController(text: data['costStructure'].first.toString()));
      _controllers.add(TextEditingController(text: data['revenueStreams'].first.toString()));

      setState(() {});
    } else {
      // معالجة الأخطاء أو عرض رسالة للمستخدم
      print(result?['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
    _controllers.isEmpty? Center(child: CircularProgressIndicator(),):
      Column(
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
        widget.isPre? SizedBox():
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
    );
  }
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