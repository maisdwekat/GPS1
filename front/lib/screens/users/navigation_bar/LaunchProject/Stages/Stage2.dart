import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../constants.dart';
import '../../MyInformation/MyStartupProjects/CreateBusinessPlan.dart';
import 'PlanningDetails.dart';
import 'Stage1.dart';
import 'Stage3.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  final List<bool> _isChecked = List<bool>.filled(8, false);
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
            const SizedBox(height: 20), // فراغ أعلى الشاشة
            const SizedBox(height: 8), // فراغ بين العنوان والشريط
            // شريط التقدم بمحاذاة اليسار
            Align(
              alignment: Alignment.topLeft, // محاذاة الشريط إلى أعلى اليسار
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 40.0), // تعديل المسافات
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // إضافة عنوان "مؤشر الإنجاز"
                    Text(
                      'مؤشر الإنجاز',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8), // فراغ بين العنوان والشريط
                    Container(
                      width: 500, // طول الشريط
                      height: 20,  // ارتفاع الشريط
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // زوايا دائرية
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4), // فراغ بين الشريط والنسبة
                    // عرض النسبة تحت الشريط
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%', // النسبة تحت الشريط
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // فراغ بين الشريط والصورة
            _buildIdeaStudySection(),
            const SizedBox(height: 40), // فراغ في الأسفل
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
          // الصورة على اليسار
          Container(
            width: 250, // تحديد عرض الصورة
            child: Image.asset(
              'assets/images/Stage2.jpg',
              fit: BoxFit.cover, // ملاءمة الصورة
            ),
          ),
          // النص على اليمين
          Expanded( // استخدام Expanded للسماح بالتوزيع المناسب
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'مرحلة التحقق والتخطيط',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'التحقق من صحة الفكرة -',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 20),
                _buildTaskCard(
                  'تشكيل فرضيات أساسية',
                  'حول من هم عملاؤك المستهدفون، والمشكلات التي يواجهونها، وكيف يمكن لمنتجك أو خدمتك حل هذه المشكلات',
                  0,
                ),
                const SizedBox(height: 8),
                _buildTaskCard(
                  'اجمع المعلومات الداعمة',
                  'استخدم التقارير والدراسات الصناعية لدعم فرضياتك، وفكر في إجراء استطلاعات الرأي والمقابلات ومجموعات التركيز مع جمهورك المستهدف.',
                  1,
                ),
                const SizedBox(height: 20),
                Text(
                  'إنشاء خطة العمل -',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),
                _buildTask(
                  'قم بانشاء خطة العمل',
                  'تساعد خطة العمل الرسمية في رسم خريطة لبناء شركة ناشئة وضمان تواصل فعال مع الفريق والمستثمرين، وفهم جدوى النمو والتخفيف من المخاطر.',
                  2,
                ),
                const SizedBox(height: 40),
                Text(
                  'سجل عملك -',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 8),
                _buildChecklist(),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlanningDetailsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    iconColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(150, 40),
                  ),
                  child: Text('معلومات أكثر عن التحقق والتخطيط'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FinancingScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(150, 40),
                      ),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      label: Text('المرحلة التالية', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StudyTheIdeaScreen()),
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
                const SizedBox(height: 10), // مسافة بين الأزرار

              ],
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildTask(String title, String description, int index) {
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
                    _completedTasks += _isChecked[index] ? 1 : -1; // Update completed tasks count
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
          const SizedBox(height: 12), // فراغ قبل الزر
        ],
      ),
    );
  }

  Widget _buildChecklist() {
    return Column(
      children: [
        _buildTaskCard(
          'اختيار اسم لشركتك الناشئة؛',
          'يجب أن يكون الاسم فريدًا وسهل التذكر ويتوافق مع القوانين المحلية.',
          3,
        ),
        const SizedBox(height: 8),
        _buildTaskCard(
          'الحصول على رقم تعريف صاحب العمل',
          'يعد هذا ضروريًا لتوظيف الموظفين وفتح حسابات مصرفية تجارية ودفع الضرائب.',
          4,
        ),
        const SizedBox(height: 8),
        _buildTaskCard(
          'تسجيل عملك لدى الدولة',
          'تسجيل العمل يوفر لك الحماية القانونية ويحتم عليك الحصول على التراخيص اللازمة.',
          5,
        ),
        const SizedBox(height: 8),
        _buildTaskCard(
          'فتح حساب بنكي تجاري',
          'يفصل الحساب أموالك الشخصية عن أموال العمل ويسهل إدارة المعاملات المالية.',
          6,
        ),
        const SizedBox(height: 8),
        _buildTaskCard(
          'تأمين التأمين.',
          'التأمين يحمي عملك من المخاطر المحتملة ويعزز ثقة العملاء في خدماتك.',
          7,
        ),
      ],
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
                    _completedTasks += _isChecked[index] ? 1 : -1; // Update completed tasks count
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