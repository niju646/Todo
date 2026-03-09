import 'package:intl/intl.dart';

class Helper {
  String shortDay(int weekday) {
    const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return days[weekday - 1];
  }

  String get greeting {
    final h = DateTime.now().hour;
    if (h < 12) return "Good morning";
    if (h < 17) return "Good afternoon";
    return "Good evening";
  }

  String formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    final day = DateFormat('EEEE').format(dateTime);
    final month = DateFormat('MMMM').format(dateTime);
    final dayNum = DateFormat('d').format(dateTime);
    final year = DateFormat('yyyy').format(dateTime);
    return '$day, $month $dayNum, $year';
  }
}
