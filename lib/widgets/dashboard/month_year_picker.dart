import 'package:flutter/material.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';

class MonthYearPicker extends StatefulWidget {
  final DateTime initialMonth;
  final Function(DateTime) onMonthSelected;

  const MonthYearPicker({
    super.key,
    required this.initialMonth,
    required this.onMonthSelected,
  });

  static Future<void> show(
    BuildContext context,
    DateTime currentMonth,
    Function(DateTime) onSelected,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MonthYearPicker(
        initialMonth: currentMonth,
        onMonthSelected: (d) {
          onSelected(d);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late int _selectedYear;

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agt',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialMonth.year;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilih Bulan',
                style: AppTheme.geist(size: 20, w: FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildYearSelector(),
          const SizedBox(height: 24),
          _buildMonthGrid(),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.textPrimary),
          onPressed: () => setState(() => _selectedYear--),
        ),
        const SizedBox(width: 16),
        Text(
          '$_selectedYear',
          style: AppTheme.geist(size: 24, w: FontWeight.w600),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppTheme.textPrimary),
          onPressed: () => setState(() => _selectedYear++),
        ),
      ],
    );
  }

  Widget _buildMonthGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final isSelected =
            widget.initialMonth.month == index + 1 &&
            widget.initialMonth.year == _selectedYear;
        return GestureDetector(
          onTap: () {
            widget.onMonthSelected(DateTime(_selectedYear, index + 1));
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.textPrimary : AppTheme.bgSecondary,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? null
                  : Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
            ),
            child: Text(
              _months[index],
              style: AppTheme.geist(
                size: 15,
                w: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.bgPrimary : AppTheme.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
