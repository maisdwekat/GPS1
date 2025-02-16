import 'package:flutter/material.dart';
import '../../../../../Controllers/ProjectController.dart';
import '../../../../../Widget/rating_widget.dart';
import '../../../../basic/footer.dart';
import '../../../../basic/header.dart';
import '../../../../investor/navigation_bar_investor/Drawerinvestor/Drawerinvestor.dart';
import '../../../../investor/navigation_bar_investor/NavigationBarinvestor.dart';
import '../../DrawerUsers/DrawerUsers.dart';
import '../../NavigationBarUsers.dart';
import 'ProjectInformation.dart';
import 'package:ggg_hhh/responsive.dart';

class ProjectsScreen extends StatefulWidget {
  bool isInvestor = false;
  ProjectsScreen({super.key});
  ProjectsScreen.investor({super.key, this.isInvestor=true});

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
   List<dynamic> filteredProjects   = [];

  getProjects() async {
    await projectController.getAllProjects().then((value) => projects.addAll(value));
    setState(() {

    });
  }
  getFilteredProjects(){
    print(_isSearchVisible);
    print(_selectedCity);
    print(_selectedField);
    print(_selectedStage);
    filteredProjects=projects;

    if(_isSearchVisible){
      if(_selectedCity!=null){

        filteredProjects=filteredProjects.where((element) => element['location']==_selectedCity,).toList();

      }
      if(_selectedField!=null){
        filteredProjects=filteredProjects.where((element) => element['category']==_selectedField,).toList();
      }
      if(_selectedStage!=null){
        filteredProjects=filteredProjects.where((element) => element['current_stage']==_selectedStage,).toList();

      }
      setState(() {

      });
    }

  }
  @override
  void initState() {
    print('must be working ');
    getProjects();
    getFilteredProjects();

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
        backgroundColor: const Color(0xFF0A1D47),
      ),
      drawer:widget.isInvestor?Drawerinvestor(scaffoldKey: _scaffoldKey): DrawerUsers(scaffoldKey: _scaffoldKey),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HeaderScreen(),
                  widget.isInvestor?NavigationBarinvestor(scaffoldKey: _scaffoldKey, onSelectContact: (String ) {  },):NavigationBarUsers(
                    onSelectContact: (value) {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  const SizedBox(height: 20),
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
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: filteredProjects.map((project) => _buildProjectCard(project)).toList(),
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
                          getFilteredProjects();

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
                            getFilteredProjects();
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
                            _selectedStage = stage;
                            getFilteredProjects();// قم بتحديث المرحلة المحددة
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
      height: 400,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              project['image']!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project['title']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              project['description']!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if(widget.isInvestor){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectInformationScreen.toInvestor(projectId: project['_id'],)),
                );
              }
              else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectInformationScreen(projectId: project['_id'],)),
                );
              }

            },
            child: Text(widget.isInvestor?'تواصل الان':'المزيد من المعلومات'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 36),
            ),
          ),
          SizedBox(height: 15),
          RatingWidget(selectedStar:project['averageRating']as double ),

        ],
      ),
    );
  }
}