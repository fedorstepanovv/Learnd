import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String timeAgo() {
    final currentDate = DateTime.now();
    if(currentDate.difference(this).inDays > 1) {
      return DateFormat.yMMMd().format(this);
    }
    return timeago.format(this);
  }
}