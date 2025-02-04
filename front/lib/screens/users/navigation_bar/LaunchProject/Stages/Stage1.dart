import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../constants.dart';
import 'IdeaStudyDetails.dart';
import 'Stage2.dart';

class StudyTheIdeaScreen extends StatefulWidget {

  const StudyTheIdeaScreen({super.key});

  @override
  _StudyTheIdeaScreenState createState() => _StudyTheIdeaScreenState();
}

class _StudyTheIdeaScreenState extends State<StudyTheIdeaScreen> {
  final List<bool> _isChecked = List<bool>.filled(4, false); // عدد المهام
  int _completedTasks = 0; // عدد المهام المكتملة

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
          // Image Section
          Column(
            children: [
              Image.asset(
                'assets/images/Stage1.jpg',
                width: 500, // Adjusted width for better layout
                height: 500,
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Questions Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end, // Align to the right
              children: [
                Text(
                  'مرحلة دراسة الفكرة',
                  style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 15),
                Text(
                  ':المهام المطلوب انجازها',
                  style: GoogleFonts.poppins(fontSize: 24),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 20),

                // Updated Questions for user input
                _buildTaskCard('وصف الفكرة', 'وضح الفكرة بشكل واضح وموجز ومعرفة المنتج أو الخدمة التي ترغب في تقديمها', 0),
                const SizedBox(height: 8),
                _buildTaskCard('تحديد القيمة المضافة', 'كيف ستحل هذه الفكرة مشكلة قائمة أو تلبي حاجة معينة في السوق', 1),
                const SizedBox(height: 8),
                _buildTaskCard('تحليل السوق', 'دراسة السوق المستهدف لفهم حجمه، ونموه، وخصائصه', 2),
                const SizedBox(height: 8),
                _buildTaskCard('تحليل المنافسين', 'من هم المنافسون الرئيسيون؟ ما هي نقاط قوتهم وضعفهم', 3),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IdeaStudyDetailsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    iconColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(150, 40),
                  ),
                  child: Text('معلومات أكثر عن دراسة الفكرة'),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlanningScreen()),
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
                ),
              ],
            ),
          ),
        ],
      ),
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
                    _completedTasks += _isChecked[index] ? 1 : -1; // زيادة أو تقليل المهام المكتملة
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