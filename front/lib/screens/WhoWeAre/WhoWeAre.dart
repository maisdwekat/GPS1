import 'package:flutter/material.dart';
import 'package:ggg_hhh/screens/basic/header.dart';
import '../basic/footer.dart';
import '../users/navigation_bar/DrawerUsers/DrawerUsers.dart';
import '../users/navigation_bar/NavigationBarUsers.dart';
import 'package:google_fonts/google_fonts.dart'; // تأكد من استيراد مكتبة Google Fonts

class WhoWeAreScreen extends StatefulWidget {
  const WhoWeAreScreen({super.key});

  @override
  _WhoWeAreScreenState createState() => _WhoWeAreScreenState();
}

class _WhoWeAreScreenState extends State<WhoWeAreScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            NavigationBarUsers(
              onSelectContact: (value) {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            const SizedBox(height: 40),
            Directionality(
              textDirection: TextDirection.rtl, // تعيين اتجاه النص إلى اليمين
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20), // إضافة حواف جانبية
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // محاذاة الفقرة إلى أقصى اليمين
                  children: [
                    Text(
                      'حاضنة ستارت أب',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold, // استخدام bold للعناوين
                      ),
                      textAlign: TextAlign.right, // محاذاة العنوان إلى اليمين
                    ),
                    const SizedBox(height: 10), // إضافة مسافة بين العنوان والفقرة
                    Text(
                      'تعتبر حاضنة ستارت أب الخيار المثالي لرواد الأعمال الذين يرغبون في تحويل أفكارهم إلى مشاريع ناجحة\n. '
                          'تقدم الحاضنة دعمًا شاملًا يشمل التمويل، التوجيه من خبراء، ودورات تدريبية متخصصة.\n '
                          'كما توفر بيئة عمل تحفيزية للتعاون والابتكار، وتتيح لك التواصل مع شبكة من المستثمرين للحصول على التمويل اللازم.\n '
                          'باختيارك حاضنة ستارت أب، تستثمر في مستقبلك كريادي. انضم إلينا وابدأ رحلتك نحو النجاح!\n',
                      style: GoogleFonts.poppins(
                        fontSize: 16, // حجم الخط للفقرة
                        color: Colors.black,
                        fontWeight: FontWeight.normal, // استخدام normal للفقرة
                      ),
                      textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                    ),

                    ///////////////////////////
                    Text(
                      'رؤيتنا',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold, // استخدام bold للعناوين
                      ),
                      textAlign: TextAlign.right, // محاذاة العنوان إلى اليمين
                    ),
                    const SizedBox(height: 10), // إضافة مسافة بين العنوان والفقرة
                    Text(
                      'نسعى لتمكين الأفراد من إطلاق مشاريعهم الخاصة من الصفر وتوفير الفرص للمستثمرين\n. '
                          'دعم هذه المشاريع وتحقيق عوائد مميزة.\n ',
                          style: GoogleFonts.poppins(
                        fontSize: 16, // حجم الخط للفقرة
                        color: Colors.black,
                        fontWeight: FontWeight.normal, // استخدام normal للفقرة
                      ),
                      textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                    ),
                     /////////////////////////////////////////////////
                    Text(
                      'ما نقدمه',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold, // استخدام bold للعناوين
                      ),
                      textAlign: TextAlign.right, // محاذاة العنوان إلى اليمين
                    ),
                    const SizedBox(height: 10), // إضافة مسافة بين العنوان والفقرة
                    Text(
                      ' - إطلاق المشاريع: يمكن للمستخدمين بدء مشاريعهم من خلال اتباع مراحل محددة ودورات تدريبية  \n '
                          'مصممة خصيصًا لتطوير مهاراتهم\n '
                          '- إضافة المشاريع: بعد تطوير فكرتهم، يمكن للمستخدمين إضافة مشاريعهم إلى حاضنتنا لتلقي  \n '
                          'الدعم من المستثمرين\n'
                          '- طرح الأفكار: لدينا نظام يتيح للمستخدمين طرح أفكار جديدة للحصول على تمويل من المستثمرين  \n '
                          'المهتمين \n '
                          '- فرص التدريب: نقدم دورات متخصصة تساعد المستخدمين على تطوير مهاراتهم في ريادة الأعمال\n ',

                      style: GoogleFonts.poppins(
                        fontSize: 16, // حجم الخط للفقرة
                        color: Colors.black,
                        fontWeight: FontWeight.normal, // استخدام normal للفقرة
                      ),
                      textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                    ),
                    const SizedBox(height: 10), // إضافة مسافة بين العنوان والفقرة

                    Text(
                      'توفر منصتنا للمستثمرين فرصة استكشاف المشاريع والأفكار المطروحة، والتواصل مباشرة مع أصحاب \n '
                          'المشاريع للاستثمار في الأفكار التي يجدونها واعدة.\n ',
                      style: GoogleFonts.poppins(
                        fontSize: 16, // حجم الخط للفقرة
                        color: Colors.black,
                        fontWeight: FontWeight.normal, // استخدام normal للفقرة
                      ),
                      textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                    ),
                    const SizedBox(height: 10), // إضافة مسافة بين العنوان والفقرة

                    Text(
                      'قيمنا',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold, // استخدام bold للعناوين
                      ),
                      textAlign: TextAlign.right, // محاذاة العنوان إلى اليمين
                    ),
                    const SizedBox(height: 10), // إضافة مسافة بين العنوان والفقرة

                    ////////////////////////////////////

                    Text(
                      'الابتكار: نحن نشجع على التفكير الإبداعي ونقدم الدعم اللازم لتحويل الأفكار إلى واقع\n '
                          'الشراكة: نؤمن بقوة الشراكة بين رواد الأعمال والمستثمرين لتحقيق النجاح المشترك\n '
                          'التعلم المستمر: نحن ملتزمون بتوفير فرص التعليم والتطوير لكل من رواد الأعمال والمستثمرين.\n ',
                      style: GoogleFonts.poppins(
                        fontSize: 16, // حجم الخط للفقرة
                        color: Colors.black,
                        fontWeight: FontWeight.normal, // استخدام normal للفقرة
                      ),
                      textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                    ),

                    //////////////////////////////////

                  ],
                ),
              ),
            ),
            const SizedBox(height: 40), // إضافة مسافة أسفل النص
            Footer(),
          ],
        ),
      ),
    );
  }
}