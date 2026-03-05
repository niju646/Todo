String formatDate(DateTime? dt) {
  if (dt == null) return "Unknown date";
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return "${months[dt.month - 1]} ${dt.day}, ${dt.year}";
}

String formatTime(DateTime? dt) {
  if (dt == null) return "";
  final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final min = dt.minute.toString().padLeft(2, '0');
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  return "$hour:$min $period";
}
