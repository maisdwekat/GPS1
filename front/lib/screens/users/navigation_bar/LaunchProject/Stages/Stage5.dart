import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../constants.dart';
import '../../MyInformation/MyStartupProjects/AddStartupProject.dart';
import '../../../homepageUsers/HomePageScreenUsers.dart';
import 'LaunchAndGrowthDetails.dart';
import 'Stage4.dart';

class LaunchAndGrowthScreen extends StatefulWidget {

  const LaunchAndGrowthScreen({super.key});

  @override
  _LaunchAndGrowthScreenState createState() => _LaunchAndGrowthScreenState();
}

class _LaunchAndGrowthScreenState extends State<LaunchAndGrowthScreen> {
  final List<bool> _isChecked = [false, false, false, false];
  int _completedTasks = 0;

  @override
  Widget build(BuildContext context) {
    double progress = _completedTasks / _isChecked.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
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
            const SizedBox(height: 20),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مؤشر الإنجاز',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 500,
                      height: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildIdeaStudySection(),
            const SizedBox(height: 40),
            _buildNextButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeaStudySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/Stage5.jpg',
            width: 500,
            height: 500,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'مرحلة الإطلاق والنمو',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                ':المهام المطلوب انجازها',
                style: GoogleFonts.poppins(fontSize: 24),
              ),
              const SizedBox(height: 8),
              _buildTaskCard('إطلاق المنتج', 'طرح المنتج في السوق بشكل رسمي', 0),
              const SizedBox(height: 8),
              _buildTaskCard('مراقبة وقياس الأداء', 'متابعة أداء المنتج في السوق وقياس النتائج', 1),
              const SizedBox(height: 8),
              _buildTaskCard('التعديل إذا لزم الأمر', 'إجراء تغييرات على المنتج أو الاستراتيجية بناءً على الملاحظات والنتائج', 2),
              const SizedBox(height: 8),
              _buildTaskCard('النمو والتوسع', 'العمل على توسيع نطاق المشروع وزيادة حجم الأعمال', 3),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LaunchAndGrowthDetailsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  iconColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: Size(150, 40),
                ),
                child: Text('معلومات أكثر عن الإطلاق والنمو '),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TeamFormationScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(150, 40),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('المرحلة السابقة', style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        width: 200,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            _navigateToConfirmationScreen();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'التالي',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  void _navigateToConfirmationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          onConfirm: _navigateToProjectAddedScreen,
        ),
      ),
    );
  }

  void _navigateToProjectAddedScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectAddedScreen()), // الانتقال إلى صفحة إضافة المشروع
    );
  }

  void _navigateToProjectCreation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddStartupProjectScreen()),
    );
  }

  Widget _buildTaskCard(String title, String description, int index) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isChecked[index] = !_isChecked[index];
                    _completedTasks += _isChecked[index] ? 1 : -1;
                  });
                },
                child: Icon(
                  _isChecked[index] ? Icons.check_box : Icons.check_box_outline_blank,
                  color: _isChecked[index] ? Colors.orangeAccent : Colors.grey,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmationScreen({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'هل أنت متأكد أنك أنهيت الخطوات السابقة لمشروعك،\nلتنتقل إلى مرحلة التمويل أو الاحتضان الخاص؟',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('ليس بعد'),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => ProjectAddedScreen()), // الانتقال إلى صفحة ProjectAddedScreen
                      );
                    },
                    child: Text('نعم'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class ProjectAddedScreen extends StatelessWidget {
  const ProjectAddedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'إمكانك الآن إضافة مشروعك إلى قائمة المشاريع الريادية.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Row( // استخدام Row لوضع الأزرار بجانب بعضها
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => homepagescreen()), // الانتقال إلى صفحة الهوم
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                    ),
                    child: Text('ليس الآن'),
                  ),

                  const SizedBox(width: 20), // إضافة مساحة بين الأزرار

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddStartupProjectScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                    ),
                    child: Text('إنشاء مشروع جديد'),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}