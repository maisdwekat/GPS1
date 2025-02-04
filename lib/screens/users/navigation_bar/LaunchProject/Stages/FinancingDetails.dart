import 'package:flutter/material.dart';

import '../../../../../constants.dart';

class FinancingDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor, // استخدام اللون المخصص
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // السهم باللون الأبيض
          onPressed: () {
            Navigator.pop(context); // العودة إلى الصفحة السابقة
          },
        ),
        title: Container(
          alignment: Alignment.centerRight, // محاذاة النص إلى اليمين
          child: Text(
            'معلومات أكثر عن التمويل والتأمين ',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.right, // محاذاة النص داخل الحاوية
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // محاذاة النص إلى اليمين
            children: [
              Text(
                'الخطوة 7: اتخاذ قرار بشأن تمويل مشروعك الناشئ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 10),
              Text(
                'عندما تفكر في كيفية بناء شركة ناشئة، فمن الطبيعي أن تتساءل أين يمكنك العثور على التمويل\n\n'
                    'ابدأ بتقييم قطاع شركتك الناشئة، وإمكانات النمو، ومدى التحكم الذي ترغب في مشاركته. غالبًا ما يساعدك الجمع بين خيارات البحث المختلفة في مراحل مختلفة من دورة حياة عملك على تحسين النمو والصحة المالية',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),

              // عرض الصورة مباشرة بعد الشرح
              Center(
                child: Image.asset(
                  'assets/images/step.PNG',
                  width: 1100,
                  height: 600,
                ),
              ),

              // الخطوة 7
              Text(
                'الخطوة 7: إنشاء الميزانية والتوقعات المالية',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 10),
              Text(
                'لكي تتمكن من التخطيط لأنشطتك المستقبلية بشكل فعال، عليك أن تعرف وضعك المالي. اتبع الخطوات التالية لإنشاء خطة مالية واقعية\n\n'
                    '1. **تقدير التكاليف الأولية:** مثل الرسوم القانونية، والإيجار، والمرافق، وتكاليف إعداد أنظمة تكنولوجيا المعلومات، وتطوير المنتجات، والتسويق\n\n'
                    '2. **مصاريف تشغيل المشروع:** بما في ذلك رواتب الموظفين والمدفوعات مقابل الخدمات الخارجية، بالإضافة إلى التكاليف المستمرة للحفاظ على استمرارية عملك\n\n'
                    '3. **توقع الإيرادات:** استخدم أبحاث السوق الخاصة بك لتكوين تخمين مدروس حول المبيعات المستقبلية\n\n'
                    '4. **إنشاء البيانات المالية:** بما في ذلك بيان الدخل، والميزانية العمومية، وبيان التدفق النقدي\n\n'
                    'من المستحسن أن تدرج في ميزانيتك صندوق طوارئ بنسبة تتراوح بين 10% إلى 20%.',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 100), // تقليل الفراغ في الأسفل
            ],
          ),
        ),
      ),
    );
  }
}