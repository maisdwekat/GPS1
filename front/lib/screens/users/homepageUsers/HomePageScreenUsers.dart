import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/ProjectController.dart';
import 'package:ggg_hhh/Controllers/ideaController.dart';
import '../../../Controllers/CoursesController.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../basic/footer.dart';
import '../../basic/header.dart';
import '../../investor/navigation_bar_investor/Drawerinvestor/Drawerinvestor.dart';
import '../../investor/navigation_bar_investor/NavigationBarinvestor.dart';
import '../navigation_bar/DrawerUsers/DrawerUsers.dart';
import '../navigation_bar/MyInformation/MyIdeas/PreviewIdea.dart';
import '../navigation_bar/NavigationBarUsers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../navigation_bar/StartUpsHub/Courses/Courses.dart';
import '../navigation_bar/StartUpsHub/Projects/ProjectInformation.dart';
class homepagescreen extends StatefulWidget {
  bool toInvestor = false;
   homepagescreen({super.key});
   homepagescreen.toInvestor({super.key,  this.toInvestor=true});


  @override
  _homepagescreenState createState() => _homepagescreenState();
}

class _homepagescreenState extends State<homepagescreen> {
  final CoursesController coursesController = CoursesController(); // إنشاء مثيل من CoursesController
  final ProjectController projectController = ProjectController(); // إنشاء مثيل من ProjectController
  final IdeaController ideaController = IdeaController();
  List<dynamic>? _courses;
   List<dynamic>? _projects ;
   List<dynamic>? _ideas ;



  @override

  void initState() {

    fetchLatestCourses(); // استدعاء الدالة لجلب آخر 5 دورات عند بدء الصفحة

    super.initState();
  }

  Future<void> fetchLatestCourses() async {
    _projects=await projectController.getAllProjects();
    _courses=await coursesController.getAllCourses();
    _ideas=await ideaController.getAllIdeas();
    print(_ideas);
    print('_courses');
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(backgroundColor: Color(0xFF0A1D47),foregroundColor: Colors.white,),
      drawer: DrawerUsers(scaffoldKey: _scaffoldKey),
      body: _buildBody(),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(backgroundColor: Color(0xFF0A1D47)),
      drawer: DrawerUsers(scaffoldKey: _scaffoldKey),
      body: _buildBody(),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(backgroundColor: Color(0xFF0A1D47)),
      drawer:widget.toInvestor?Drawerinvestor(scaffoldKey: _scaffoldKey): DrawerUsers(scaffoldKey: _scaffoldKey),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderScreen(),
         widget.toInvestor?NavigationBarinvestor(scaffoldKey: _scaffoldKey, onSelectContact: (String ) {  },): NavigationBarUsers(
            onSelectContact: (value) {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),          const SizedBox(height: 20),
          _buildInfoCard(),
          const SizedBox(height: 40),
          _buildInfoCardForIdeas(),
          const SizedBox(height: 40),
          _buildCoursesSection(),
          const SizedBox(height: 20),
          Footer(),
        ],
      ),
    );
  }







  Widget _buildCoursesSection() {
    return Column(
      children: [
        _buildSectionHeader('أكثر الدورات طلبا'), // عنوان قسم الدورات

        _courses==null?Center(
          child: CircularProgressIndicator(),
        ): CarouselSlider.builder(
    itemCount: _courses!.length,
    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
      
      return GestureDetector(
        onTap: () {
          // الانتقال إلى صفحة تفاصيل الدورة عند الضغط على المربع
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoursesScreen(), // استبدل هذا بالصفحة الخاصة بك
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _courses![itemIndex]['nameOfEducationalCourse'], // تأكد من أن لديك مفتاح 'nameOfEducationalCourse' في البيانات
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              // وصف الدورة
              Text(
                _courses![itemIndex]['description'], // تأكد من أن لديك مفتاح 'description' في البيانات
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );;
            
    }, options: CarouselOptions(
    height: 100,
    aspectRatio: 16/9,
    viewportFraction: 0.30,
    initialPage: 0,
    enableInfiniteScroll: true,
    reverse: true,
    autoPlay: true,
    autoPlayInterval: Duration(seconds: 3),
    autoPlayAnimationDuration: Duration(milliseconds: 800),
    autoPlayCurve: Curves.fastOutSlowIn,
    enlargeCenterPage: true,
    enlargeFactor: 0.3,
    scrollDirection: Axis.horizontal,
       disableCenter: true,

    ),
      
    )
      ],
    );
  }



  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard() {
   return Column(
     children: [
       _buildSectionHeader('أكثر المشاريع الرائجة'), // عنوان قسم الدورات

       _projects==null? Center(child: CircularProgressIndicator(),

   ): CarouselSlider.builder(
      itemCount: _projects!.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {

        return GestureDetector(
          onTap: () {
            // انتقل إلى صفحة تفاصيل المشروع عند الضغط على المربع
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectInformationScreen(projectId: _projects![itemIndex]['_id'],), // استبدل هذا بالصفحة الخاصة بك
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.28,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // صورة المشروع
                Container(
                  width: 180,
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(_projects![itemIndex]['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // اسم المشروع
                Text(
                  _projects![itemIndex]['title'], // تأكد من أن لديك مفتاح 'title' في البيانات
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                // وصف المشروع
                Text(
                  _projects![itemIndex]['description'], // تأكد من أن لديك مفتاح 'description' في البيانات
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );

      }, options: CarouselOptions(
      height: 300,
      aspectRatio: 16/9,
      viewportFraction: 0.30,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: true,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 3),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      enlargeFactor: 0.3,
      scrollDirection: Axis.horizontal,
      disableCenter: true,

    ),

    )]);}
  Widget _buildInfoCardForIdeas() {
    return Column(
      children:[
        _buildSectionHeader('أكثر الأفكار الرائجة'),
        _ideas==null?Center(child: CircularProgressIndicator()): CarouselSlider.builder(
        itemCount: _ideas!.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {

          return GestureDetector(
            onTap: () {
              // انتقل إلى صفحة تفاصيل الفكرة عند الضغط على المربع
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewIdeaScreen.toInfo(ideaId: _ideas![itemIndex]['_id'],role: widget.toInvestor? 'investor' : 'user',), // استبدل هذا بالصفحة الخاصة بك
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.28,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // صورة الفكرة
                  Container(
                    width: 180,
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(_ideas![itemIndex]['image'] ?? 'assets/images/defaultimg.jpeg'), // استخدم الصورة المحددة أو الصورة الافتراضية
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // اسم الفكرة
                   Text(
                    _ideas![itemIndex]['description'],
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8), // مسافة قبل الأيقونات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // أيقونة التعليقات
                      Column(
                        children: [
                          Icon(Icons.comment, color: kPrimaryColor),
                          Text(
                            '${_ideas![itemIndex]['comments'].length ?? 0  }', // عدد التعليقات
                            style: TextStyle(fontSize: 12), // حجم النص
                          ),
                        ],
                      ),
                      // أيقونة الإعجاب
                      Column(
                        children: [
                           Icon(Icons.favorite_border, color: kPrimaryColor),

                          Text(
                            '${_ideas![itemIndex]['likes'].length ?? 0}', // عدد الإعجابات
                            style: TextStyle(fontSize: 12), // حجم النص
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );

        }, options: CarouselOptions(
        height: 300,
        aspectRatio: 16/9,
        viewportFraction: 0.30,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
        disableCenter: true,

      ),

      ),]
    );
  }

}