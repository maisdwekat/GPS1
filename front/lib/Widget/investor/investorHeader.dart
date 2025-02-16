import 'package:flutter/material.dart';

import '../../screens/investor/navigation_bar_investor/MyInformation/MyAccount.dart';
import '../../screens/investor/navigation_bar_investor/MyInformation/MyInvestments.dart';
import '../../screens/investor/navigation_bar_investor/MyInformation/calendar.dart';
import 'headerItem.dart';

class Investorheader extends StatelessWidget {
  const Investorheader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 2,
          color: Color(0xFF0A1D47),
        ),
        Container(
          color: Colors.grey[200],
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Headeritem(title:'التقويم',screen: Calender(),),
              Headeritem(title:'استثماراتي',screen: MyInvestmentsScreen(),),
              Headeritem(title:'حسابي',screen: ProfileScreeninvestor(),),
            ],
          ),
        ),
        Container(
          height: 2,
          color: Color(0xFF0A1D47),
        )
      ],
    );
  }
}
