import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/ProjectController.dart';
import 'package:ggg_hhh/Controllers/token_controller.dart';
import 'package:ggg_hhh/Widget/bmc_widget.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../../Controllers/date_controller.dart';
import '../../../../../Investments/InvestmentModel.dart';
import '../../../../../Widget/rating_widget.dart';
import '../../../../ChatForInquiries/ChatForInquiries.dart';
import '../../../../basic/footer.dart';
import '../../../../basic/header.dart';
import '../../../../investor/navigation_bar_investor/Drawerinvestor/Drawerinvestor.dart';
import '../../../../investor/navigation_bar_investor/NavigationBarinvestor.dart';
import '../../DrawerUsers/DrawerUsers.dart';
import '../../NavigationBarUsers.dart';

class ProjectInformationScreen extends StatefulWidget {
  String projectId;
  bool isInvestor = false;
  ProjectInformationScreen({required this.projectId});
  ProjectInformationScreen.toInvestor({required this.projectId,this.isInvestor=true});

  @override
  _ProjectInformationScreenState createState() =>
      _ProjectInformationScreenState();
}

class _ProjectInformationScreenState extends State<ProjectInformationScreen> {
  TokenController tokenController = TokenController();

  Widget? _selectedContent; // تغيير إلى نوع Widget?
  ProjectController projectController = ProjectController();
  dynamic project;
  double? _selectedStar ; // لتحفظ رقم النجمة المحددة
  String? userId;
  getId() async {
    String? token = await tokenController.getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    userId = decodedToken['id'];

  }

  getproject() async {
    List <dynamic> rattingList;

    project = await projectController.getSpecificProject(widget.projectId);
    if(project!=null){
      rattingList=project['ratings'] as List;
      setState(() {});
      _selectedStar=rattingList.where((element) => element['investor']==userId).first['rating'] as double?;
    }
    setState(() {});

  }

  void _updateContent(Widget content) {
    setState(() {
      _selectedContent = content; // تعيين المحتوى كـ Widget
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getId();
    getproject();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D47),
      ),
      drawer: widget.isInvestor?Drawerinvestor(scaffoldKey: _scaffoldKey):DrawerUsers(scaffoldKey: _scaffoldKey), // استدعاء Drawer
      body: project == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  HeaderScreen(), // استدعاء الهيدر
                  widget.isInvestor? NavigationBarinvestor(
                    scaffoldKey: _scaffoldKey,
                    onSelectContact: (value) {
                      // منطق لتحديد جهة الاتصال
                    },
                  ):NavigationBarUsers(
                    onSelectContact: (value) {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  const SizedBox(height: 40),
                  _buildMainContent(),
                  const SizedBox(height: 40),
                  Footer(),
                ],
              ),
            ),
    );
  }

  void _showChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              bottom: 0, // لتحديد موقعها من الأسفل
              left: 0, // لتحديد موقعها من اليسار
              child: Container(
                width: 400,
                height: 600, // يمكنك تعديل الحجم كما تحتاج
                child: ChatForInquiriesScreen(id: '',), // استبدل هذا بالمحتوى الخاص بك
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildProjectDetails(),
            ),
            SizedBox(width: 20),
            _buildProjectSummary(),
          ],
        ),
        SizedBox(height: 20),
        widget.isInvestor?_buildActionButtons():Container(),
      ],
    );
  }
  Widget _buildActionButton(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // إضافة وظيفة عند الضغط
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 8),
        _buildActionButton('تنزيل نموذج الاستثمار', () {
          // وظيفة تنزيل نموذج الاستثمار
        }),
        SizedBox(width: 8),
        _buildActionButton('استفسر الآن', () {
          _showChatDialog(context); // استدعاء نافذة الدردشة هنا
        }),
        SizedBox(width: 8),
        _buildActionButton('تقديم طلب استثمار', () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InvestmentRequestFormScreen()),
          );
          // وظيفة تقديم طلب استثمار
        }),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProjectDetails() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(15),
      ),
      height: 700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'عنوان المشروع الرئيسي',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 20),
          _buildProjectActions(),
          SizedBox(height: 20),
          // عرض المحتوى المحدد بناءً على الضغط
          if (_selectedContent != null) ...[
            _selectedContent!, // استخدام ! لأننا نعرف أنه ليس null هنا
            SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildProjectActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionItem('نموذج العمل التجاري', () {
          _updateContent(
              _buildBusinessModelContent(context)); // تعيين كـ Widget
        }),
        _buildActionItem('حول', () {
          _updateContent(_buildAboutContent()); // تعيين كـ Widget
        }),
      ],
    );
  }

////////////////////////////////////////////////////

  Widget _buildAboutContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAboutSection('صاحب المشروع', project['name'], 20, 18),
          _buildAboutSection(
            'البريد الإلكتروني',
            GestureDetector(
              onTap: () {
                _showChatDialog(context);
              },
              child: Text(
                project['email'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
              ),
            ),
            16,
            16,
          ),
          _buildAboutSection(
              ' الموقع الالكتروني ',
              GestureDetector(
                onTap: () {
                  // يمكنك إضافة وظيفة هنا لفتح الموقع عند الضغط
                },
                child: Text(
                  project['website'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline, // إضافة خط تحت النص
                  ),
                ),
              ),
              16,
              14),
          _buildProgressSection(
              'تاريخ الإنشاء', ConvertDateAndFormate(project['date']), 20, 18),
          _buildProgressSectionWithProgress(
              'المرحلة الحالية', project['current_stage'], 20, 18, 0.4),
          _buildAboutSection('نبذة عن المشروع', project['summary'], 16, 14),
        ],
      ),
    );
  }

  Widget _buildAboutSection(
      String title, dynamic content, double titleSize, double contentSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 10),
        content is Widget
            ? content
            : Text(
                content,
                style: TextStyle(fontSize: contentSize),
                textAlign: TextAlign.right,
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
        SizedBox(height: 10),
      ],
    );
  }

////////////////////////////////////////////////////

  Widget _buildProgressSectionWithProgress(String title, String content,
      double titleSize, double contentSize, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(fontSize: contentSize),
          textAlign: TextAlign.right,
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: 10),
        Container(
          width: 200, // عرض الشريط المحدد
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300], // لون الخلفية
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Container(
                width: 200 * progress, // حساب العرض بناءً على النسبة
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green, // لون الشريط المكتمل
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildProgressSection(
      String title, String year, double titleSize, double contentSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 10),
        // عرض السنة فقط
        Text(
          year, // استخدم السنة التي تم تمريرها
          style: TextStyle(fontSize: contentSize),
          textAlign: TextAlign.right,
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  ////////////////////////////////////////////////////

  Widget _buildBusinessModelContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // لمحاذاة المحتوى إلى اليمين
        children: [
          Container(
            width: 600, // عرض الصورة 600
            height: 300, // يمكنك ضبط الارتفاع حسب الحاجة
            decoration: BoxDecoration(
              color: Colors.white, // لون خلفية المربع
              borderRadius: BorderRadius.circular(10), // زوايا دائرية للمربع
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // زوايا دائرية للصورة
                child: BmcWidget.pre(
                  id: widget.projectId,
                  isPre: true,
                )),
          ),
        ],
      ),
    );
  }

////////////////////////////////////////////////////
  Widget _buildActionItem(String title, Function action) {
    return GestureDetector(
      onTap: () {
        action(); // استدعاء الدالة
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF001F3F)),
        ),
      ),
    );
  }

  Widget _buildProjectSummary() {
    return Container(
      width: 250,
      height: 350,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 10, left: 20),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  project['image'],
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            project['title'].toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            project['category'],
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Container(
            width: 150,
            height: 2,
            color: Color(0xFFE0E0E0),
          ),
          SizedBox(height: 15),
          Text(
            project['description'],
            style: TextStyle(fontSize: 14, color: Colors.green),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
         widget.isInvestor? RatingWidget.toInvestor(selectedStar: _selectedStar??0,projectId: widget.projectId,):SizedBox(), // إضافة النجوم هنا

        ],
      ),
    );
  }


}
