import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:mobile_spendly/pages/transactions/transaction_detail_page.dart';

class CalendarTab extends StatefulWidget {
  final List<Transaction> transactions;
  final DateTime focusedMonth;
  final Function(DateTime) onMonthChanged;

  const CalendarTab({
    super.key,
    required this.transactions,
    required this.focusedMonth,
    required this.onMonthChanged,
  });

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  List<Transaction> _getEventsForDay(DateTime day) {
    return widget.transactions.where((tx) => isSameDay(tx.date, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: true,
      child: Column(
        children: [
          _buildCalendar(),
          const Divider(height: 1, color: AppTheme.border),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: widget.focusedMonth,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
        });
      },
      onPageChanged: (focusedDay) {
        widget.onMonthChanged(focusedDay);
      },
      calendarFormat: CalendarFormat.month,
      headerVisible: false,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppTheme.goldDim,
          shape: BoxShape.circle,
        ),
        todayTextStyle: AppTheme.geist(
          color: AppTheme.gold,
          w: FontWeight.w700,
        ),
        selectedDecoration: const BoxDecoration(
          color: AppTheme.textPrimary,
          shape: BoxShape.circle,
        ),
        markerDecoration: const BoxDecoration(
          color: AppTheme.rose,
          shape: BoxShape.circle,
        ),
        markerSize: 5,
      ),
      eventLoader: _getEventsForDay,
    );
  }

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay!);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 48,
              color: AppTheme.textMuted.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada transaksi di hari ini',
              style: AppTheme.geist(color: AppTheme.textMuted, size: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final tx = events[index];
        return _buildTransactionTile(context, tx);
      },
    );
  }

  Widget _buildTransactionTile(BuildContext context, Transaction tx) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TransactionDetailPage(tx: tx)),
        ),
        title: Text(
          tx.title,
          style: AppTheme.geist(size: 15, w: FontWeight.w600),
        ),
        subtitle: Text(
          tx.categoryId.toUpperCase(),
          style: AppTheme.geist(size: 11, color: AppTheme.textMuted),
        ),
        trailing: Text(
          Fmt.idr(tx.amount),
          style: AppTheme.mono(
            size: 14,
            w: FontWeight.w700,
            color: tx.type == TransactionType.income
                ? Colors.blueAccent
                : AppTheme.rose,
          ),
        ),
      ),
    );
  }
}
