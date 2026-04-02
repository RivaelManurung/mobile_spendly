import 'package:flutter/material.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';

class CurrencyDisplay extends StatelessWidget {
  final double amount;
  final bool isNegative;
  final TextStyle? style;
  final String? prefix;

  const CurrencyDisplay({
    super.key,
    required this.amount, 
    this.isNegative = false, 
    this.style,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    String formatted = Fmt.idr(amount);
    if (prefix != null) formatted = '$prefix$formatted';
    
    return Text(
      formatted,
      style: style ?? AppTheme.fontMono.copyWith(
        fontSize: 24, 
        color: isNegative ? AppTheme.rose : AppTheme.emerald
      ),
    );
  }
}
