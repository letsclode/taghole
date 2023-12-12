import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat.yMMMMd().add_jm().format(date);
}
