import 'package:flutter/material.dart';
import '../../../../../constants.dart';

class IdeaStudyDetailsScreen extends StatelessWidget {
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
            'معلومات أكثر عن دراسة الفكرة',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.right, // محاذاة النص داخل الحاوية
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // محاذاة العناصر إلى اليمين
            children: [
              Text(
                'الخطوة 1: البحث عن اتجاهات السوق',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 16),
              Text(
                ' حتى لو كنت واثقًا من أن فكرتك هي بالضبط ما يحتاجه العالم، فلن يضرك إعادة التحقق. هذه الخطوة مفيدة أيضًا إذا لم تكن لديك فكرة محددة بعد، حيث ستساعدك على تحديد الفرص المتاحة لبدء مشروع ناجح.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 16),
              Text(
                ': إليك ما يجب عليك فعله',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 8),
              Text(
                ' ابحث عن المطالب الناشئة وتوقع الاتجاه الذي يتجه إليه السوق •\n'
                    ' فهم المنتجات والخدمات التي تكتسب شعبية ولماذا •\n'
                    ' تحليل المجالات التي لا يتم فيها تلبية احتياجات المستهلكين بشكل كامل •\n'
                    'حدد المنتجات والخدمات التي يتلاشى الطلب عليها لتجنب الاستثمار في تلك المجالات •',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 16),
              Text(
                'الخطوة 2: تبادل الأفكار حول مفاهيم الأعمال',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 8),
              Text(
                'مع استكشافك للإمكانيات، حان الوقت لإطلاق العنان لإبداعك وتدوين الأفكار المحتملة التي يمكن لشركتك الناشئة تطويرها. في هذه المرحلة، ركز على الكمية وليس على جودة الأفكار',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 16),
              Text(
                ' : فيما يلي بعض التقنيات التي تساعدك على إجراء العصف الذهني بشكل فعال ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 8),
              Text(
                ' الخريطة الذهنية: ابدأ بمفهوم مركزي وتوسع إلى موضوعات فرعية، واستكشف جوانب أو مكونات مختلفة لفكرة ما •\n'
                    ' كتابة الأفكار: اجمع صديقًا أو مجموعة من الأشخاص الذين تثق في آرائهم وتقدرها. اطلب منهم كتابة أفكارهم على الورق، ثم مرر الورقة إلى الشخص التالي الذي يضيف المزيد من الأفكار •\n'
                    'حل المشكلات: التركيز على المشكلات المحددة التي يواجهها العملاء المحتملون •',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 16),
              Text(
                'الخطوة 3: تحديد فكرة مربحة',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 8),
              Text(
                'بعد جلسة العصف الذهني، قم بتحليل الأفكار. اختر الأفكار الواعدة وقم بتوسيعها أو دمجها مع أفكار أخرى لاستكشاف أوجه التآزر المحتملة أو الزوايا الجديدة',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 8),
              Text(
                ': كقاعدة عامة، يجب أن تتمتع الفكرة الناجحة بالخصائص التالية',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 8),
              Text(
                ' حل مشكلة واسعة النطاق •\n'
                    ' تقديم قيمة فريدة •\n'
                    ' أن تكون قابلة للتنفيذ من الناحية الفنية والمالية •',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.right, // محاذاة النص إلى اليمين
              ),
              SizedBox(height: 100),

            ],
          ),
        ),
      ),
    );
  }
}