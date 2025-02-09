import 'package:intl/intl.dart';

String dateFormater(DateTime date) {
  return DateFormat('yyyy-MMMM-dd').format(date);

}
String ConvertDateAndFormate(String date) {

  DateTime dateTime = DateTime.parse(date);
  return DateFormat('yyyy-MMMM-dd').format(dateTime);

}

