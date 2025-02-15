import 'package:intl/intl.dart';

String dateFormater(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);

}
String ConvertDateAndFormate(String date) {

  DateTime dateTime = DateTime.parse(date);
  return DateFormat('yyyy-MM-dd').format(dateTime);

}

