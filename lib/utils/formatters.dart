import 'package:intl/intl.dart';

class Fmt {
  static final _idr = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String idr(double amount) => _idr.format(amount);

  static String idrCompact(double amount) {
    if (amount >= 1000000000) {
      return 'Rp ${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return idr(amount);
  }

  static String date(DateTime d) => DateFormat('dd MMM yyyy', 'id_ID').format(d);
  
  static String monthYear(DateTime d) => DateFormat('MMMM yyyy', 'id_ID').format(d);
  
  static String currentMonthYear() => DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now());
  
  static String dateShort(DateTime d) => DateFormat('d MMM', 'id_ID').format(d);
  static String dayName(DateTime d) => DateFormat('EEEE', 'id_ID').format(d);
  static String time(DateTime d) => DateFormat('HH:mm').format(d);
  static String weekday(DateTime d) => DateFormat('EEE', 'id_ID').format(d);

  static String greeting() {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat pagi';
    if (h < 15) return 'Selamat siang';
    if (h < 18) return 'Selamat sore';
    return 'Selamat malam';
  }
}
