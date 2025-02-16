import 'package:flutter/material.dart';
import 'package:ggg_hhh/constants.dart';
import 'package:ggg_hhh/screens/Login/components/Otp_Verification_Screen.dart';
import 'package:ggg_hhh/screens/Login/components/forgot_password.dart';
import 'package:ggg_hhh/screens/Signup/signup_screen.dart';
import 'package:ggg_hhh/screens/Welcome/welcome_screen.dart';
import 'package:ggg_hhh/screens/dashboard/Dashboard.dart';
import 'package:ggg_hhh/screens/investor/homepageinvestor/HomePageScreeninvestor.dart';
import 'package:ggg_hhh/screens/users/homepageUsers/HomePageScreenUsers.dart';
import 'package:ggg_hhh/screens/users/navigation_bar/MyInformation/MyStartupProjects/AddStartupProject.dart';

void main() => runApp(const MyApp());



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'StartUps Hub',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: WelcomeScreen(),
    );
  }
}
