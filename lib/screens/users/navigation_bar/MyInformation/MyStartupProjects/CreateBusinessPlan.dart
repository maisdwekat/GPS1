import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // استيراد حزمة http
import '../../../../../constants.dart';
import 'BMCform.dart';

class CreateBusinessPlanScreen extends StatelessWidget {
  final TextEditingController _customersController = TextEditingController();
  final TextEditingController _valuePropositionController = TextEditingController();
  final TextEditingController _distributionChannelsController = TextEditingController();
  final TextEditingController _customerRelationshipsController = TextEditingController();
  final TextEditingController _revenueStreamsController = TextEditingController();
  final TextEditingController _keyResourcesController = TextEditingController();
  final TextEditingController _keyActivitiesController = TextEditingController();
  final TextEditingController _keyPartnersController = TextEditingController();
  final TextEditingController _costStructureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'إنشاء نموذج العمل التجاري',
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 16),
                _buildQuestionField(context, question: 'العملاء المستهدفون: من هم العملاء الذين تستهدفهم الشركة؟', controller: _customersController),
                _buildQuestionField(context, question: 'قيمة العرض: ما هي المنتجات أو الخدمات التي تقدمها الشركة وما القيمة التي تقدمها للعملاء؟', controller: _valuePropositionController),
                _buildQuestionField(context, question: 'قنوات التوزيع: كيف سيتم توصيل المنتجات أو الخدمات للعملاء؟', controller: _distributionChannelsController),
                _buildQuestionField(context, question: 'علاقات العملاء: كيف ستتفاعل الشركة مع عملائها وتبني علاقات معهم؟', controller: _customerRelationshipsController),
                _buildQuestionField(context, question: 'مصادر الإيرادات: كيف ستكسب الشركة المال؟ (مثل المبيعات، الاشتراكات، الإعلانات)', controller: _revenueStreamsController),
                _buildQuestionField(context, question: 'الموارد الرئيسية: ما هي الموارد الأساسية التي تحتاجها الشركة لتحقيق نموذج عملها؟', controller: _keyResourcesController),
                _buildQuestionField(context, question: 'الأنشطة الرئيسية: ما هي الأنشطة الأساسية التي يجب على الشركة القيام بها؟', controller: _keyActivitiesController),
                _buildQuestionField(context, question: 'الشركاء الرئيسيون: من هم الشركاء أو الموردون الذين يساعدون الشركة في تحقيق أهدافها؟', controller: _keyPartnersController),
                _buildQuestionField(context, question: 'هيكل التكاليف: ما هي التكاليف المرتبطة بتشغيل نموذج العمل؟', controller: _costStructureController),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildCancelButton(context),
                    SizedBox(width: 16),
                    _buildActionButton(context, label: 'تحويل الى خطة العمل', onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BMCformscreen()),
                      );
                    }),
                    SizedBox(width: 16),
                    _buildSaveButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionField(BuildContext context, {required String question, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            question,
            style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 80,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return Container(
      width: 220,
      height: 50,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'إلغاء',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {
          // استدعاء دالة إرسال البيانات هنا
          sendDataToBackend();
        },
        child: Text(
          'حفظ',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> sendDataToBackend() async {
    final response = await http.post(
      Uri.parse('YOUR_BACKEND_URL'),
      body: {
        'customers': _customersController.text,
        'valueProposition': _valuePropositionController.text,
        'distributionChannels': _distributionChannelsController.text,
        'customerRelationships': _customerRelationshipsController.text,
        'revenueStreams': _revenueStreamsController.text,
        'keyResources': _keyResourcesController.text,
        'keyActivities': _keyActivitiesController.text,
        'keyPartners': _keyPartnersController.text,
        'costStructure': _costStructureController.text,
      },
    );

    if (response.statusCode == 200) {
      print('تم إرسال البيانات بنجاح!');
      // يمكنك إضافة منطق لتوجيه المستخدم إلى شاشة أخرى إذا لزم الأمر
    } else {
      print('فشل في إرسال البيانات: ${response.statusCode}');
    }
  }
}