import 'package:flutter/material.dart';
import 'package:ggg_hhh/screens/users/homepageUsers/HomePageScreenUsers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // استيراد حزمة http
import '../../../../../Controllers/BMCcontroller.dart';
import '../../../../../constants.dart';
import 'BMCform.dart';

class CreateBusinessPlanScreen extends StatefulWidget {
  bool toUpdate = false;
  String id;

  CreateBusinessPlanScreen({super.key,required this.id});
  CreateBusinessPlanScreen.toUpdate({super.key,this.toUpdate=true,required this.id});

  @override
  State<CreateBusinessPlanScreen> createState() => _CreateBusinessPlanScreenState();
}

class _CreateBusinessPlanScreenState extends State<CreateBusinessPlanScreen> {
  final TextEditingController _customerSegmentsController = TextEditingController();

  final TextEditingController _valuePropositionsController = TextEditingController();

  final TextEditingController _channelsController = TextEditingController();

  final TextEditingController _customerRelationshipsController = TextEditingController();

  final TextEditingController _revenueStreamsController = TextEditingController();

  final TextEditingController _keyResourcesController = TextEditingController();

  final TextEditingController _keyActivitiesController = TextEditingController();

  final TextEditingController _keyPartnersController = TextEditingController();

  final TextEditingController _costStructureController = TextEditingController();
  var data;
  final BMCcontroller _bmcController = BMCcontroller();
  initState() {
    super.initState();
    widget.toUpdate?_loadBusinessCanva():null;
  }
  Future<void> _loadBusinessCanva() async {
    final result = await _bmcController.getBusinessCanva(widget.id);
    if (result != null && result['success']) {
       data = result['data'];

      // تحديث المحتوى الخاص بالأقسام بناءً على البيانات المسترجعة
      _keyPartnersController.text=data['keyPartners'].first.toString();
      _keyActivitiesController.text=data['keyActivities'].first.toString();
      _keyResourcesController.text=data['keyResources'].first.toString();
      _valuePropositionsController.text=data['valuePropositions'].first.toString();
      _customerRelationshipsController.text=data['customerRelationships'].first.toString();
      _channelsController.text=data['channels'].first.toString();
      _customerSegmentsController.text=data['customerSegments'].first.toString();
      _costStructureController.text=data['costStructure'].first.toString();
      _revenueStreamsController.text=data['revenueStreams'].first.toString();

      setState(() {});
    } else {
      // معالجة الأخطاء أو عرض رسالة للمستخدم
      print(result?['message']);
    }
  }

  Future<void> _saveBusinessCanva() async {
    print('بدء عملية حفظ البيانات...'); // رسالة بداية العملية

    print('البيانات المرسلة:');
    print('Key Partners: ${_keyPartnersController.text}');
    print('Key Activities: ${_keyActivitiesController.text}');
    print('Key Resources: ${_keyResourcesController.text}');
    print('Value Propositions: ${_valuePropositionsController.text}');
    print('Customer Relationships: ${_customerRelationshipsController.text}');
    print('Channels: ${_channelsController.text}');
    print('Customer Segments: ${_customerSegmentsController.text}');
    print('Cost Structure: ${_costStructureController.text}');
    print('Revenue Streams: ${_revenueStreamsController.text}');

    await _bmcController.addBusinessCanva(
      projectId: widget.id,
      keyPartners: _keyPartnersController.text,
      keyActivities: _keyActivitiesController.text,
      keyResources: _keyResourcesController.text,
      valuePropositions: _valuePropositionsController.text,
      customerRelationships: _customerRelationshipsController.text,
      channels: _channelsController.text,
      customerSegments: _customerSegmentsController.text,
      costStructure: _costStructureController.text,
      revenueStreams: _revenueStreamsController.text,
    );

    print('تم حفظ البيانات بنجاح!'); // رسالة نجاح
  }
  Future<void> _updateBusinessCanva() async {
    print('بدء عملية حفظ البيانات...'); // رسالة بداية العملية

    await _bmcController.updateBusinessCanva(
      projectId: data['projectId'],
      keyPartners: _keyPartnersController.text,
      keyActivities: _keyActivitiesController.text,
      keyResources: _keyResourcesController.text,
      valuePropositions: _valuePropositionsController.text,
      customerRelationships: _customerRelationshipsController.text,
      channels: _channelsController.text,
      customerSegments: _customerSegmentsController.text,
      costStructure: _costStructureController.text,
      revenueStreams: _revenueStreamsController.text,
    );

    print('تم حفظ البيانات بنجاح!'); // رسالة نجاح
  }

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
                _buildQuestionField(context, question: 'العملاء المستهدفون: من هم العملاء الذين تستهدفهم الشركة؟', controller: _customerSegmentsController),
                _buildQuestionField(context, question: 'قيمة العرض: ما هي المنتجات أو الخدمات التي تقدمها الشركة وما القيمة التي تقدمها للعملاء؟', controller: _valuePropositionsController),
                _buildQuestionField(context, question: 'قنوات التوزيع: كيف سيتم توصيل المنتجات أو الخدمات للعملاء؟', controller: _channelsController),
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => BMCformscreen()),
                      // );
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

          print('زر الحفظ تم الضغط عليه!'); // طباعة رسالة عند الضغط على الزر
          if(widget.toUpdate == true){
            _updateBusinessCanva();
          }
          else {
            _saveBusinessCanva();
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homepagescreen()),

          );
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
}