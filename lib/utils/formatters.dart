import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Fmt {
  static final _idr = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final _num = NumberFormat.decimalPattern('id_ID');

  static String idr(double amount) => _idr.format(amount);
  static String number(double amount) => _num.format(amount);

  static String idrCompact(double amount) {
    if (amount >= 1000000000) {
      return 'Rp ${number(amount / 1000000000)}M';
    } else if (amount >= 1000000) {
      return 'Rp ${number(amount / 1000000)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${number(amount / 1000)}rb';
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

class ThousandSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    double value = double.tryParse(cleanText) ?? 0;
    
    final formatter = NumberFormat.decimalPattern('id_ID');
    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
