import 'package:flutter/material.dart';
import 'package:ggg_hhh/Widget/bmc_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../Controllers/ProjectController.dart';
import '../../../../../Controllers/token_controller.dart';
import '../../../../../Investments/RequestFormUpdate.dart';
import '../../../../../Investments/UserInvestmentRequests.dart';
import '../../../../../Widget/DeletionAndModificationRequestsWidget.dart';
import '../../../../../Widget/ExistinginvestorsWidget.dart';
import '../../../../../Widget/InvestmentRequests_widget.dart';
import '../../../../../Widget/notes_widget.dart';
import '../../../../../Widget/user_information_header.dart';
import '../../../../ChatForInquiries/ChatForInquiries.dart';
import '../../../../../Investments/Request_form.dart';
import '../MyAccount.dart';
import '../MyIdeas/MyIdeas.dart';
import 'CreateBusinessPlan.dart';
import 'MyStartupProjects.dart';

class PreviewProjectScreen extends StatefulWidget {
  @override
  _PreviewProjectScreenState createState() => _PreviewProjectScreenState();
  final String projectId;

   PreviewProjectScreen({super.key, required this.projectId});
}

class _PreviewProjectScreenState extends State<PreviewProjectScreen> {
  String _profileImage = '';
  Widget? _selectedContent; // تغيير إلى نوع Widget?
  String? selectedCity; // متغير لتخزين المدينة المختارة
  String? selectedProjectField; // لتخزين مجال المشروع
  String? selectedStage; // لتخزين المرحلة الحالية
  bool? selectedVisibility; // لتخزين الرؤية (خاص = false / عام = true)
  final TextEditingController titleController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? creationDate; // لتخزين تاريخ الإنشاء (يمكن أن يكون نصًا)
  String? isoDate; // لتخزين التاريخ بالتنسيق المطلوب
  DateTime dateTime = DateTime.now();
  final TextEditingController shortDescriptionController =
  TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  int shortDescriptionLength = 0;
  int summaryLength = 0;
  final ImagePicker _picker = ImagePicker();
  String? imagePath; // Path of the selected image
  // Uint8List imageBytes = Uint8List(0); // Bytes of the selected image
  // http.MultipartFile? imageFile; // Multipart file for the image


  @override
  void initState() {
    super.initState();
    _selectedContent = Container();
    getdata();
  }

  final TokenController token = TokenController();

  getdata() async {
    var data = await ProjectController().getprojectById(widget.projectId!);
    print('it must get one project');

    setState(() {
      titleController.text = data!['title'];
      websiteController.text = data['website'];
      emailController.text = data['email'];
      shortDescriptionController.text = data['description'];
      summaryController.text = data['summary'];
      creationDate = data['date'];
      selectedCity = data['location'];
      selectedProjectField = data['category'];
      selectedStage = data['current_stage'];
      selectedVisibility = data['isPublic'];
      imagePath = data['image'];
    });
    print(data);
    print('it must get one project');
  }

  void _updateContent(Widget content) {
    setState(() {
      _selectedContent = content; // تعيين المحتوى كـ Widget
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D47),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            UserInformationHeader(),
            Divider(color: Color(0xFF0A1D47)),
            _buildNavigationBar(),
            Divider(color: Color(0xFF0A1D47)),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Color(0xFF0A1D47),
      height: 30,
    );
  }


  Widget _buildNavigationBar() {
    return Container(
      height: 50,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem('أفكاري', MyIdeasScreen()),
          _buildNavItem('مشاريعي الناشئة', MyStartupProjectsScreen()),
          _buildNavItem('حسابي', ProfileScreen()),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(title, style: TextStyle(color: Color(0xFF001F3F))),
      ),
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
        _buildActionItem('طلبات الحذف والتعديل ', () {
          _updateContent(_buildDeletionAndModificationRequestsContent());
        }),
        _buildActionItem('المستثمرين الحاليين', () {
          _updateContent(_buildExistinginvestorsContent()); // تعيين كـ Widget
        }),
        _buildActionItem('طلبات الاستثمار', () {
          _updateContent(_buildInvestmentRequestsContent()); // تعيين كـ Widget
        }),
        _buildActionItem('الملاحظات', () {
          _updateContent(_buildProjectNotesContent()); // تعيين كـ Widget
        }),
        _buildActionItem('نموذج العمل التجاري', () {
          _updateContent(
              _buildBusinessModelContent(context)); // تعيين كـ Widget
        }),
        _buildActionItem('سير المشروع', () {
          _updateContent(_buildProjectProgressContent()); // تعيين كـ Widget
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
          _buildAboutSection('صاحب المشروع', 'أحمد محمد', 20, 18),
          _buildAboutSection(
            'البريد الإلكتروني',
            GestureDetector(
              onTap: () {
                _showChatDialog(context);
              },
              child: Text(
                'ahmed@example.com',
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
              'الموقع الالكتروني ',
              GestureDetector(
                onTap: () {},
                child: Text(
                  'www.example.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline, // إضافة خط تحت النص
                  ),
                ),
              ),
              16,
              14),
          _buildProgressSection('تاريخ الإنشاء', '2024', 20, 18),
          _buildAboutSection(
              'نبذة عن المشروع',
              'يطمح المشروع إلى تحقيق نتائج ملموسة تسهم في تحسين العمليات المختلفة...',
              16,
              14),
        ],
      ),
    );
  }

  Widget _buildAboutSection(String title, dynamic content, double titleSize,
      double contentSize) {
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

  Widget _buildProgressSection(String title, String year, double titleSize,
      double contentSize) {
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
  Widget _buildProjectProgressContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 10),
          _buildProgressSectionWithProgress(
              'المرحلة الحالية', 'مرحلة التحقق والتخطيط', 20, 18, 0.4),
        ],
      ),
    );
  }

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

  ////////////////////////////////////////////////////

  Widget _buildBusinessModelContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        // استخدم عمود لمحاذاة العناصر رأسياً
        mainAxisAlignment: MainAxisAlignment.end, // لمحاذاة المحتوى إلى الأسفل
        children: [
          Container(
            width: 800,
            height: 400,
            child: BmcWidget.pre(isPre: true, id: widget.projectId),
          ),
          SizedBox(height: 10), // إضافة مسافة بين الصورة والزر
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreateBusinessPlanScreen.toUpdate(
                            id: widget.projectId)),
              );
            },
            child: Text('تعديل'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 50), // تحديد الطول والعرض للزر
            ),
          ),
        ],
      ),
    );
  }

////////////////////////////////////////////////////

  Widget _buildProjectNotesContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        // استخدم عمود لمحاذاة العناصر رأسياً
        mainAxisAlignment: MainAxisAlignment.end, // لمحاذاة المحتوى إلى الأسفل
        children: [
          Container(
            width: 800,
            height: 400,
            child: NotesWidget(),
          ),
          SizedBox(height: 10), // إضافة مسافة بين الصورة والزر
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////
  Widget _buildInvestmentRequestsContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        // استخدم عمود لمحاذاة العناصر رأسياً
        mainAxisAlignment: MainAxisAlignment.end, // لمحاذاة المحتوى إلى الأسفل
        children: [
          Container(
            width: 800,
            height: 400,
            child: InvestmentRequestsWidget(),
          ),
          SizedBox(height: 10), // إضافة مسافة بين الصورة والزر
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////

  Widget _buildExistinginvestorsContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        // استخدم عمود لمحاذاة العناصر رأسياً
        mainAxisAlignment: MainAxisAlignment.end, // لمحاذاة المحتوى إلى الأسفل
        children: [
          Container(
            width: 800,
            height: 400,
            child: Existinginvestorswidget(),
          ),
          SizedBox(height: 10), // إضافة مسافة بين الصورة والزر
        ],
      ),
    );
  }

///////////////////////////////////////////

  Widget _buildDeletionAndModificationRequestsContent() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        // استخدم عمود لمحاذاة العناصر رأسياً
        mainAxisAlignment: MainAxisAlignment.end, // لمحاذاة المحتوى إلى الأسفل
        children: [
          Container(
            width: 800,
            height: 400,
            child: DeletionAndModificationRequestsWidget(),
          ),
          SizedBox(height: 10), // إضافة مسافة بين الصورة والزر
        ],
      ),
    );
  }

////////////////////////////////////////////////////////
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
                image: AssetImage('assets/images/p1 (2).jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            'اسم المشروع',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'مجال المشروع',
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
            'وصف مختصر',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Container(
            width: 150,
            height: 2,
            color: Color(0xFFE0E0E0),
          ),

          Text(
            'حالة المشروع',
            style: TextStyle(fontSize: 14, color: Colors.green),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}