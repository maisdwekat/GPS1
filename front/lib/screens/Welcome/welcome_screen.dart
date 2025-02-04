import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../screens/login/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget  {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  final List<Map<String, String>> _items = [
    {
      'image': 'assets/images/111.jpg',
      'text': 'أهلاً بك في منصتنا! سجل الآن للحصول على المزيد من المعلومات.',

    },
    {
      'image': 'assets/images/welcome1.jpg',
      'text': '!ابدأ رحلتك الريادية اليوم\nانطلق نحو تحقيق حلمك بإنشاء مشروعك الخاص',

    },
    {

      'image': 'assets/images/home2.jpeg',
      'text': 'هل لديك فكرة مبتكرة؟\nنحن هنا لمساعدتك في تحويلها إلى واقع',
    },
    {
      'image': 'assets/images/welcome2.jpg',
      'text': ' فرصتك للتميز في عالم الأعمال!\n انطلق بمشروعك وكن جزءًا من الحاضنة الأكثر دعمًا',
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _nextPage);
  }

  void _nextPage() {
    _currentPage++;
    if (_currentPage >= _items.length) {
      _currentPage = 0;
    }
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    Future.delayed(const Duration(seconds: 5), _nextPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageCarousel(),
            const SizedBox(height: 40),
            _buildTextWithImage(),
            const SizedBox(height: 20),
            _buildTextWiththreeImage(),
            const SizedBox(height: 40),
            _buildMotivationText(),
            const SizedBox(height: 40),
            _buildRegisterButton(),
            const SizedBox(height: 40),
            _buildFAQSection(),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                _items[index]['image']!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              );
            },
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black54, // ظل أسود شفاف
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _items[_currentPage]['text']!,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_currentPage == 0) // زر "سجل الآن" يظهر فقط في الصفحة الأولى
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        width: 120, // تحديد عرض الزر
                        child: ElevatedButton(
                          onPressed: () {
                            // أضف وظيفة الزر هنا
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                          ),
                          child: const Text('سجل الآن'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 5,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLoginButton(),
              ClipRRect(
                child: Image.asset(
                  'assets/images/start ups hub-03.png',
                  width: 160,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Center( // لضبط النقاط في المنتصف
            child: SmoothPageIndicator(
              controller: _pageController,
              count: _items.length,
              effect: const WormEffect(
                activeDotColor: Colors.orangeAccent,
                dotColor: Colors.white,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildTextWithImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        children: [
          // الصورة على اليسار تأخذ ثلثي الشاشة
          Expanded(
            flex: 2, // تحديد الثلثين
            child: Container(
              height: 400, // ارتفاع ثابت للصورة
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/welcomepage2.PNG'), // استبدل بمسار الصورة الخاصة بك
                  fit: BoxFit.cover, // أو BoxFit.fill لجعل الصورة تملأ المساحة
                ),
              ),
            ),
          ),
          const SizedBox(width: 16), // إضافة مسافة بين الصور
          // النص
          Expanded(
            flex: 1, // تحديد الثلث
            child: SingleChildScrollView( // إضافة Scroll إذا كان النص طويلًا
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // محاذاة العناصر إلى اليمين
                children: [
                  // العنوان
                  Text(
                    'لماذا حاضنة ستارت أب؟',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold, // استخدام bold للعناوين
                    ),
                    textAlign: TextAlign.right, // محاذاة العنوان إلى اليمين
                  ),
                  const SizedBox(height: 8), // مسافة بين العنوان والفقرة
                  // الفقرة الجديدة
                  Text(
                    'تعتبر حاضنة ستارت أب الخيار المثالي لرواد الأعمال الذين يرغبون في تحويل أفكارهم إلى مشاريع ناجحة. '
                        'تقدم الحاضنة دعمًا شاملًا يشمل التمويل، التوجيه من خبراء، ودورات تدريبية متخصصة. '
                        'كما توفر بيئة عمل تحفيزية للتعاون والابتكار، وتتيح لك التواصل مع شبكة من المستثمرين للحصول على التمويل اللازم. '
                        'باختيارك حاضنة ستارت أب، تستثمر في مستقبلك كريادي. انضم إلينا وابدأ رحلتك نحو النجاح!',
                    style: GoogleFonts.poppins(
                      fontSize: 16, // حجم الخط للفقرة
                      color: Colors.black,
                      fontWeight: FontWeight.normal, // استخدام normal للفقرة
                    ),
                    textAlign: TextAlign.justify, // توزيع النص بشكل متساوي
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextWiththreeImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        children: [
          // الصورة الأولى
          Expanded(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center, // محاذاة النص في المركز
                  children: [
                    Image.asset(
                      'assets/images/green.jpg', // استبدل بمسار الصورة الأولى
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0), // إضافة padding للنص
                      child: Text(
                        '55',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold, // جعل النص داخل الصورة bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // مسافة بين الصورة والنص السفلي
                Text(
                  'عدد الشركات المستفيدة',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // جعل النص السفلي bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16), // مسافة بين الصور
          // الصورة الثانية
          Expanded(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/orange.png', // استبدل بمسار الصورة الثانية
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0), // إضافة padding للنص
                      child: Text(
                        '107',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold, // جعل النص داخل الصورة bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // مسافة بين الصورة والنص السفلي
                Text(
                  'عدد المشاريع الناشئة',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // جعل النص السفلي bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16), // مسافة بين الصور
          // الصورة الثالثة
          Expanded(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/blue.png', // استبدل بمسار الصورة الثالثة
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0), // إضافة padding للنص
                      child: Text(
                        '78',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold, // جعل النص داخل الصورة bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // مسافة بين الصورة والنص السفلي
                Text(
                  'عدد الشركات المستفيدة',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // جعل النص السفلي bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          'تسجيل الدخول',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMotivationText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'هل أنت مستعد لتحويل فكرتك المبتكرة إلى عمل مزدهر؟',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: const Color(0xE2122088),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'انضم إلى *مركز الشركات الناشئة* اليوم!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              // هنا يمكنك إضافة وظيفة الزر
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xE2122088),
              padding: const EdgeInsets.symmetric(vertical: 15.0),
            ),
            child: const Text('سجل الآن'),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    final List<Map<String, String>> faqs = [
      {
        'question': 'ما هي حاضنة ستارت أب؟',
        'answer': 'حاضنة ستارت أب هي برنامج يهدف لدعم رواد الأعمال.'
      },
      {
        'question': 'كيف يمكنني التقديم؟',
        'answer': 'يمكنك التقديم عبر الموقع الرسمي لحاضنة ستارت أب.'
      },
      {
        'question': 'ما هي المزايا المقدمة؟',
        'answer': 'تقدم الحاضنة تمويلًا، تدريبًا، وتوجيهًا من خبراء.'
      },
      {
        'question': 'هل هناك رسوم للتسجيل؟',
        'answer': 'لا توجد رسوم للتسجيل في الحاضنة.'
      },
      {
        'question': 'ما هي فترة البرنامج؟',
        'answer': 'تستمر فترة البرنامج لمدة 6 أشهر.'
      },
      {
        'question': 'كيف يمكنني التواصل معكم؟',
        'answer': 'يمكنك التواصل معنا عبر البريد الإلكتروني أو الهاتف.'
      },
    ];

    List<bool> isExpanded = List.generate(faqs.length, (_) => false);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end, // محاذاة العمود إلى اليمين
            children: [
              Column(
                children: List.generate(faqs.length, (index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded[index] = !isExpanded[index];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          color: const Color(0xE2122088),
                          width: 400, // عرض ثابت
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // توزيع الأيقونة والنص
                            children: [
                              Icon(
                                isExpanded[index] ? Icons.remove : Icons.add,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  faqs[index]['question']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // عرض الجواب مباشرة تحت السؤال
                      if (isExpanded[index])
                        Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.white,
                          width: 300, // يجب أن يتطابق مع عرض السؤال
                          child: Text(
                            faqs[index]['answer']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
//footer
  Widget _buildFooter() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset(
            'assets/images/image400400.png',
            height: 100,
          ),
          const SizedBox(height: 10),
          Text(
            'نحن نحتضن مشروعك مجانًا، ونقدم لك الإرشادات، ثم نساعدك في الحصول على التمويل.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF0A1D47),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'اتصل بنا\n'
                'فلسطين – نابلس\n'
                'البريد الإلكتروني: StartupsHub@gmail.com\n'
                'الهاتف: 97022945845+\n'
                'الفاكس: 97022946947+\n'
                'حقوق الطبع والنشر © 2024',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          // أزرار التواصل الاجتماعي
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.facebook),
                onPressed: () {
                  // رابط فيسبوك
                },
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.instagram),
                onPressed: () {
                  // رابط إنستجرام
                },
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.twitter),
                onPressed: () {
                  // رابط تويتر
                },
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.linkedin),
                onPressed: () {
                  // رابط لينكدإن
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}