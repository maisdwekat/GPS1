import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:ggg_hhh/Controllers/ProjectController.dart';

class RatingWidget extends StatefulWidget {
   bool isInvestor = false;
   double selectedStar;
   String? projectId;
   RatingWidget({super.key,required this.selectedStar});
   RatingWidget.toInvestor({super.key, this.isInvestor=true,required this.selectedStar,required this.projectId});


  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  @override
  Widget build(BuildContext context) {
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: List.generate(5, (index) {
    //     return GestureDetector(
    //       onTap: () {
    //         setState(() {
    //           widget.selectedStar = index + 1; // تعيين رقم النجمة المحددة
    //         });
    //       },
    //       child: Icon(
    //         Icons.star,
    //         color: index < widget.selectedStar ? Colors.orange : Colors.grey[350],
    //         // تغيير اللون حسب التحديد
    //         size: 30,
    //       ),
    //     );
    //   }),
    // );;
    ProjectController projectController = ProjectController();
    return RatingStars(
      value: widget.selectedStar,
      onValueChanged:widget.isInvestor? (v)async {
        //
        await projectController.addRatting(widget.projectId!, v);
        setState(() {
          widget.selectedStar = v;

        });

      }:(v){},
      starBuilder: (index, color) => Icon(
        Icons.star,
        color: color,
        size: 26,
      ),
      starCount: 5,
      starSize: 20,
      valueLabelColor: const Color(0xff9b9b9b),
      valueLabelTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontSize: 12.0),
      valueLabelRadius: 10,
      maxValue: 5,
      starSpacing: 3,
      maxValueVisibility: true,
      valueLabelVisibility: true,
      animationDuration: Duration(milliseconds: 1000),
      valueLabelPadding:
      const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      valueLabelMargin: const EdgeInsets.only(right: 8),
      starOffColor: const Color(0xffe7e8ea),
      starColor: Colors.yellow,
    );
  }
}
