import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/ideaController.dart';
import '../../../../../constants.dart';
import '../../../../basic/footer.dart';
import '../../../../basic/header.dart';
import '../../../../investor/navigation_bar_investor/NavigationBarinvestor.dart';
import '../../DrawerUsers/DrawerUsers.dart';
import '../../MyInformation/MyIdeas/PreviewIdea.dart';
import '../../NavigationBarUsers.dart';

class IdeasScreen extends StatefulWidget {
  bool isInvestor = false;

  IdeasScreen({super.key});

  IdeasScreen.invstor({super.key, this.isInvestor=true});

  @override
  _IdeasScreenState createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController =
      TextEditingController(); // إضافة متحكم للبحث

  List<dynamic> ideas = [];
  IdeaController idea = IdeaController();

  getAllIdea() async {
    ideas = await idea.getAllIdeas();
    setState(() {});
  }

  @override
  void initState() {
    getAllIdea();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF0A1D47),
      ),
      drawer: DrawerUsers(scaffoldKey: _scaffoldKey), // استدعاء Drawer
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderScreen(), // استدعاء الهيدر
            widget.isInvestor?NavigationBarinvestor(scaffoldKey: _scaffoldKey, onSelectContact: (String ) {  },):NavigationBarUsers(
              onSelectContact: (value) {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            const SizedBox(height: 20),
            // مستطيل البحث
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft, // محاذاة إلى أقصى اليسار
                child: Container(
                  height: 50,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[100], // لون الخلفية
                    borderRadius: BorderRadius.circular(8.0),
                    border:
                        Border.all(color: Colors.orangeAccent), // لون الحدود
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.orangeAccent, // لون الأيقونة
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'بحث...',
                            border: InputBorder.none, // بدون حدود
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children:
                  ideas.map((idea) => _buildInfoCardForIdeas(idea)).toList(),
            ),
            const SizedBox(height: 40),
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCardForIdeas(dynamic item) {
    return Container(
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
          // صورة موحدة لكل الأفكار
          Container(
            width: 180,
            height: 120,
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: AssetImage('assets/images/defaultimg.jpeg'),
                // المسار للصورة الموحدة
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // وصف الفكرة
          Text(
            item['description'],
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8), // مسافة قبل الأيقونات
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // محاذاة العناصر إلى اليسار
            children: [
              // أيقونة التعليقات
              Column(
                children: [
                  Icon(Icons.comment, color: kPrimaryColor),
                  Text(
                    '${item['comments'].length}', // عدد التعليقات
                    style: TextStyle(fontSize: 12), // حجم النص
                  ),
                ],
              ),
              const SizedBox(width: 20), // مسافة بين الأيقونات
              // أيقونة الإعجاب
              Column(
                children: [
                  Icon(
                    Icons.favorite,
                    color: kPrimaryColor, // تغيير اللون حسب حالة الإعجاب
                  ),
                  Text(
                    '${item['likes'].length}', // عدد الإعجابات
                    style: TextStyle(fontSize: 12), // حجم النص
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8), // مسافة قبل الزر
          // زر المزيد من المعلومات
          ElevatedButton(
            onPressed: () {
              if (widget.isInvestor) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PreviewIdeaScreen.toInfo(
                            ideaId: item['_id'],
                            role: 'investor',
                          )),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PreviewIdeaScreen.toInfo(
                            ideaId: item['_id'],
                            role: 'user',
                          )),
                );
              }
            },
            child: Text('المزيد من المعلومات'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor, // لون النص
            ),
          ),
        ],
      ),
    );
  }
}
