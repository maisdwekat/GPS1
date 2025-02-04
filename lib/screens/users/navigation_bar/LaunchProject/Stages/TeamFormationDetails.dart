import 'package:flutter/material.dart';

import '../../../../../constants.dart';

class TeamFormationDetailsScreen extends StatelessWidget {
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
            'معلومات أكثر عن تأسيس الفريق والموارد ',
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
                'الخطوة 9. بناء فريق',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 10),
              Text(
                'بمجرد تحديد كيفية بناء شركة ناشئة، تأكد من أن لديك المزيج الصحيح من المهارات والخبرة والتوافق الثقافي \n'
                    ' يمكن أن يعزز هذا بشكل كبير من أداء شركتك وابتكارها',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
          SizedBox(height: 10),
          Text(
                '\n\n : فيما يلي استراتيجية شائعة لتجنيد الأشخاص المناسبين ',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 18),
          ),

              SizedBox(height: 10),
              Text(
                'حدد احتياجاتك من حيث الأدوار والمسؤوليات اللازمة لتحقيق أهداف عملك. ضع في اعتبارك المهارات وأنواع الشخصيات التي ستكمل عملية بدء * \n'
                    'التشغيل لديك وتحسن ديناميكيات الفريق',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'ركز على المناصب الرئيسية التي تعتبر حاسمة لنجاح شركتك الناشئة، مثل رئيس قسم التكنولوجيا ، ورئيس قسم العمليات *\n'
                    'ورئيس قسم التسويق , يجب أن يكون كل عضو في الفريق الأساسي متعدد المهارات بما يكفي لتولي أدوار متعددة',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'تقديم الحوافز . في حين أنك قد لا تنافس الشركات الكبرى من حيث الراتب، إلا أنه يمكنك تقديم مزايا أخرى مثل الأسهم، وظروف العمل المرنة *\n'
                    ' وفرص النمو المهني السريع ',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'استخدم التدريبات والأدوار المؤقتة لتقييم الموظفين المحتملين بدوام كامل * \n',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'استعن بمصادر خارجية لأداء أدوار متخصصة. بالنسبة للمهام غير الأساسية مثل تطوير مواقع الويب ، فكر في الاستعانة بمصادر خارجية لشركة  * \n'
                    'تطوير برمجيات موثوقة. سيسمح هذا لفريقك الأساسي بالتركيز على تطوير المنتجات والتسويق والمبيعات',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
               Text(
                 'الاستعانة بمصادر خارجية أو الاحتفاظ بالداخل؟',
                   style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                     color: kPrimaryColor,
                   ),
                    textAlign: TextAlign.right,
               ),

              Center(
                child: Image.asset(
                  'assets/images/step9.PNG',
                  width: 1100,
                  height: 400,
                ),
              ),
              SizedBox(height: 40),

              Text(
                'الخطوة 10. إنشاء منتج قابل للتنفيذ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 10),
              Text(
                'المنتج القابل للتطبيق بالحد الأدنى (MVP) هو أبسط شكل للمنتج الذي يمكن طرحه في السوق. فهو يحتوي على ما يكفي من الميزات لجذب المستخدمين \n'
                    ' الأوائل وإثبات صحة مفهوم المنتج في وقت مبكر من دورة التطوير.',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'يتم استخدام هذا النهج على نطاق واسع لتطوير الشركات الناشئة لأنه يوفر الوقت والموارد من خلال التركيز على الوظائف الأساسية التي تلبي احتياجات \n'
                    'العملاء دون إضافات غير ضرورية',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),

              SizedBox(height: 10),
              Text(
                '\n\n  لدينا دليل كامل مخصص لفوائد MVP وكيفية تطويره، هنا سنوضح الخطوات الرئيسية',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),

              SizedBox(height: 10),
              Text(
                'حدد الميزات الأساسية التي تعالج بشكل مباشر المشكلة الرئيسية لقاعدة المستخدمين الأولية لديك  * \n',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'قم بتصميم وبناء المنتج القابل للتنفيذ ، مع الحفاظ على بساطته وسهولة استخدامه. والهدف هو بناء ما يكفي فقط لطلب ملاحظات قيمة، وليس إتقانه  *\n',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'اختبر المنتج مع مستخدمين حقيقيين . استخدم مجموعة صغيرة من المختبرين التجريبيين الذين يمثلون سوقك المستهدف. اجمع وحلل سلوك *\n'
                    ' المستخدمين وردود أفعالهم لفهم ما ينجح وما لا ينجح ',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'التكرار بناءً على التعليقات الواردة، وإضافة الميزات أو تعديلها أو إزالتها * \n',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'الاستعداد للتوسع . بمجرد التحقق من صحة مفهوم المنتج ووجود دليل واضح على الطلب في السوق، ستكون جاهزًا لتحسين المنتج القابل للتنفيذ  * \n'
                    'للاستخدام على نطاق أوسع وتعزيز ميزات المنتج',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),

              Text(
                'الخطوة 10. إنشاء منتج قابل للتنفيذ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                'إن مفتاح إنشاء استراتيجية تسويق فعّالة بميزانية منخفضة هو الاستفادة من التكتيكات الفعّالة من حيث التكلفة والتي تعمل على تعظيم التأثير  * \n'
                    ' فيما يلي العديد من الأفكار حول كيفية إنشاء استراتيجية ترويج للشركات الناشئة بميزانية محدودة',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              ),

              SizedBox(height: 20),
              Text(
                'تسويق المحتوى',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('- المدونات: شارك الأفكار والتوجيهات وأخبار الصناعة لجذب جمهورك وإشراكه؛'),
              Text('- الفيديوهات: قم بإنشاء مقاطع فيديو بسيطة ومفيدة باستخدام أدوات مثل هاتفك الذكي أو برنامج تحرير الفيديو المجاني؛'),
              Text('- الرسوم البيانية: تقديم معلومات قيمة بطريقة جذابة بصريًا باستخدام أدوات التصميم الجرافيكي المجانية؛'),
              SizedBox(height: 20),
              Text(
                'التسويق عبر وسائل التواصل الاجتماعي',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('- اختر المنصات التي يكون فيها جمهورك المستهدف أكثر نشاطًا؛'),
              Text('- انشر بانتظام وتفاعل مع المتابعين؛'),
              Text('- استخدم علامات التصنيف بشكل استراتيجي لزيادة ظهورك؛'),
              SizedBox(height: 20),
              Text(
                'التسويق عبر البريد الإلكتروني',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('- قم ببناء قائمة بريد إلكتروني من خلال تقديم شيء ذي قيمة؛'),
              Text('- استخدم حملات البريد الإلكتروني للترويج لعملك؛'),
              SizedBox(height: 20),
              Text(
                'تحسين محركات البحث (SEO)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('- قم بتحسين موقع الويب الخاص بك والمحتوى الخاص بك لمحركات البحث؛'),
              Text('- ركز على الكلمات الرئيسية الطويلة؛'),
              SizedBox(height: 20),
              Text(
                'الشراكات والتشبيك',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('- التعاون مع الشركات الأخرى؛'),
              Text('- حضور أو المشاركة في الفعاليات المجتمعية؛'),
              SizedBox(height: 20),
              Text(
                'برامج الإحالة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('- شجع عملاءك الراضين على إحالة عملاء جدد؛'),
              SizedBox(height: 20),
              Text(
                'العلاقات العامة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('- كتابة بيانات صحفية أو مقالات؛'),
              Text('- المشاركة في أنشطة المجتمع المحلي؛'),
              SizedBox(height: 20),
              Text(
                'التسويق الحربي',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('- استخدم تكتيكات غير تقليدية؛'),
            SizedBox(height: 40),

            Text(
              'لإنشاء استراتيجية تسويقية فعالة، يمكنك اتباع الخطوات التالية:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              ' حدد أهدافك *',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('مثل زيادة الوعي بالعلامة التجارية، وتوليد العملاء المحتملين، وتعزيز تفاعل العملاء.'),
            SizedBox(height: 10),
          Text(
            ' افهم جمهورك *',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('من خلال تحديد هوية عملائك، وما يحتاجون إليه، وأين يمكنك الوصول إليهم.'),
          SizedBox(height: 10),
        Text(
          'اختر الاستراتيجيات المناسبة *',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text('بناءً على أهدافك وجمهورك. ركز على تلك التي تستفيد من نقاط قوتك وتتطلب الحد الأدنى من الإنفاق.'),
        SizedBox(height: 10),
    Text(
    ' حدد ميزانية  *',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text('لإدارة التكاليف بشكل فعال. خصص الأموال بناءً على العائد المحتمل لكل استراتيجية.'),
    SizedBox(height: 10),
    Text(
    ' خطط لخطواتك *',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text('من خلال تقسيم كل استراتيجية إلى خطوات قابلة للتنفيذ. خطط لمواضيع المحتوى، وجدول منشورات الوسائط الاجتماعية، وحدد تسلسلات البريد الإلكتروني.'),
    SizedBox(height: 10),
    Text(
    ' استخدم أدوات مجانية أو منخفضة التكلفة *',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text('لتنفيذ استراتيجياتك، مثل أدوات جدولة الوسائط الاجتماعية مثل Buffer، أو أدوات التصميم مثل Canva، أو منصات التسويق عبر البريد الإلكتروني مثل Mailchimp.'),
    SizedBox(height: 10),
    Text(
    ' قم بقياس جهودك التسويقية *',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text('مقارنة بأهدافك باستخدام أدوات مثل Google Analytics وتحليلات الوسائط الاجتماعية. كن مستعدًا لتعديل استراتيجيتك بناءً على ما تخبرك به البيانات حول ما ينجح وما لا ينجح.'),
    SizedBox(height: 10),
    Text(
    ' استمر في تحسين وتوسيع استراتيجياتك * ',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    Text('مع تعلم المزيد حول ما يناسب عملك ومع نموك.'),
              SizedBox(height: 100), // تقليل الفراغ في الأسفل
            ],
          ),
        ),
      ),
    );
  }
}