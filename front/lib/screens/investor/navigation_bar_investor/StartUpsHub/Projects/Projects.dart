import 'package:flutter/material.dart';
import '../../../../../Controllers/ProjectController.dart';
import '../../../../basic/footer.dart';
import '../../../../basic/header.dart';
import '../../Drawerinvestor/Drawerinvestor.dart';
import '../../NavigationBarinvestor.dart';
import 'ProjectInformation.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProjectController projectController = ProjectController();

  bool _isSearchVisible = false; // للتحكم في ظهور قائمة البحث
  String? _selectedCity;
  String? _selectedField;
  String? _selectedStage;
  final List<dynamic> projects = [];
  getProjects() async {
    await projectController.getAllProjects().then((value) => projects.addAll(value));
    setState(() {

    });
  }
  @override
  void initState() {
    print('must be working ');
    getProjects();
    super.initState();
  }

  final List<String> cities = ['نابلس', 'جنين', 'قلقيلية', 'رام الله', 'طولكرم'];
  final List<String> fields = [
    'تعليمي',
    'تواصل اجتماعي',
    'تواصل وإعلام',
    'تجارة إلكترونية',
    'مالي وخدمات الدفع',
    'موسيقى وترفيه',
    'أمن إلكتروني',
    'صحة',
    'نقل وتوصيل',
    'تصنيع',
    'منصة إعلانية',
    'تسويق إلكتروني',
    'محتوى',
    'زراعة',
    'خدمات إعلانية',
    'إنترنت الأشياء',
    'ملابس',
    'طاقة',
    'أطفال',
    'برنامج كخدمة (SaaS)',
    'ذكاء اصطناعي',
    'تعليم آلة',
    'خدمات منزلية',
    'ألعاب',
    'تمويل جماعي',
    'هدايا',
  ];

  final List<String> stages = [
    'مرحلة دراسة الفكرة',
    'مرحلة التحقق والتخطيط',
    'مرحلة التمويل والتأمين',
    'مرحلة تأسيس الفريق والموارد',
    'مرحلة الاطلاق والنمو'
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D47),
      ),
      drawer: Drawerinvestor(scaffoldKey: _scaffoldKey), // استدعاء Drawer
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderScreen(), // استدعاء الهيدر
            NavigationBarinvestor(
              scaffoldKey: _scaffoldKey,
              onSelectContact: (value) {
                // منطق لتحديد جهة الاتصال
              },
            ),
            const SizedBox(height: 40),
            _buildSearchButton(),
            Row(
              children: [
                Expanded(
                  child: _buildContent(), // محتويات الصفحة
                ),
                _isSearchVisible ? _buildSearchSidebar() : SizedBox.shrink(), // قائمة البحث تظهر هنا
              ],
            ),
            const SizedBox(height: 40),
            Footer(),
          ],
        ),
      ),
    );
  }
  Widget _buildContent() {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: projects.map((project) => _buildProjectCard(project))
              .toList(),
        ),
      ],
    );
  }
  Widget _buildSearchHeader() {
    return GestureDetector(
      onTap: () => _showSearchDialog(),
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.green,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'بحث',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // إغلاق واجهة البحث عند الضغط خارج المستطيل
          },
          child: AlertDialog(
            backgroundColor: Colors.transparent, // اجعل الخلفية شفافة
            content: GestureDetector(
              onTap: () {}, // لا تفعل شيئًا عند الضغط داخل المستطيل
              child: _buildSearchSidebar(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('إغلاق'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchButton() {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSearchVisible = !_isSearchVisible; // عكس حالة الظهور
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(30), // زوايا دائرية
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'بحث',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSearchSidebar() {
    return Container(
      width: 300, // عرض محدد لمستطيل البحث
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // لون الخلفية
        borderRadius: BorderRadius.circular(12), // زوايا دائرية
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // لون الظل
            spreadRadius: 2, // مدى انتشار الظل
            blurRadius: 5, // درجة تشتت الظل
            offset: const Offset(0, 3), // موضع الظل
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'البحث',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Text('اختر المدينة', style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 150, // ارتفاع المحدد
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: cities.map((city) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // محاذاة العناصر إلى اليمين
                    children: [
                      Text(city), // نص المدينة
                      Checkbox(
                        value: _selectedCity == city, // تحقق مما إذا كانت المدينة مختارة
                        activeColor: Colors.orangeAccent, // اللون البرتقالي عند التحديد
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = city; // قم بتحديث المدينة المحددة
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text('حدد المجال', style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 150, // ارتفاع المحدد
            child: ListView(
              children: fields.map((field) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // محاذاة العناصر إلى اليمين
                    children: [
                      Text(field), // نص المجال
                      Checkbox(
                        value: _selectedField == field, // تحقق مما إذا كان المجال مختارًا
                        activeColor: Colors.orangeAccent, // اللون البرتقالي عند التحديد
                        onChanged: (value) {
                          setState(() {
                            _selectedField = field; // قم بتحديث المجال المحدد
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text('اختار المرحلة', style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 150, // ارتفاع المحدد
            child: ListView(
              children: stages.map((stage) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // محاذاة العناصر إلى اليمين
                    children: [
                      Text(stage),
                      Checkbox(
                        value: _selectedStage == stage, // تحقق مما إذا كانت المرحلة مختارة
                        activeColor: Colors.orangeAccent, // اللون البرتقالي عند التحديد
                        onChanged: (value) {
                          setState(() {
                            _selectedStage = stage; // قم بتحديث المرحلة المحددة
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(dynamic project) {
    return Container(
      width: 300,
      // عرض المربع
      height: 400,
      // ارتفاع المربع
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // تأثير الظل
          ),
        ],
      ),
      child: Column(
        children: [
          // الصورة
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              project['image']!,
              width: double.infinity,
              height: 200, // ارتفاع الصورة
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          // عنوان المشروع
          Text(
            project['title']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // وصف المشروع
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              project['description']!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          // زر "استثمر الآن"
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProjectInformationScreen()),
              );
              // أضف هنا وظيفة الزر
            },
            child: Text('تواصل الان'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(100, 36), // حجم الزر
            ),
          ),
        ],
      ),
    );
  }
}