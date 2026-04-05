import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:mobile_spendly/widgets/shared/currency_display.dart';
import 'package:mobile_spendly/widgets/dashboard/month_year_picker.dart';

import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/pages/transactions/transaction_detail_page.dart';
import 'package:mobile_spendly/widgets/dashboard/calendar_tab.dart';
import 'package:mobile_spendly/widgets/dashboard/monthly_tab.dart';
import 'package:mobile_spendly/widgets/dashboard/summary_tab.dart';

// ─── DASHBOARD PAGE ───────────────────────────────────────────────
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _activeTabIndex = 0; // 0: Harian, 1: Kalender, 2: Bulanan, etc.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Consumer<AppState>(
        builder: (context, state, _) {
          final stats = state.monthlyStats;
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _Header(state: state),
              _DateSelectorRow(
                state: state,
                activeIndex: _activeTabIndex,
                onTabChanged: (i) => setState(() => _activeTabIndex = i),
              ),
              _SummaryBar(stats: stats),
              _buildContent(state),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(AppState state) {
    switch (_activeTabIndex) {
      case 0:
        return _GroupedTransactionList(state: state);
      case 1:
        return CalendarTab(
          transactions: state.transactions,
          focusedMonth: state.selectedMonth,
          onMonthChanged: (m) => state.setMonth(m),
        );
      case 2:
        return MonthlyTab(
          transactions: state.transactions,
          stats: state.monthlyStats,
        );
      case 3:
        return SummaryTab(transactions: state.transactions);
      case 4:
        return SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, size: 48, color: AppTheme.gold),
                const SizedBox(height: 16),
                Text(
                  'Analisis AI',
                  style: AppTheme.geist(size: 18, w: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  state.latestAIInsight,
                  textAlign: TextAlign.center,
                  style: AppTheme.geist(
                    size: 14,
                    color: AppTheme.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return _GroupedTransactionList(state: state);
    }
  }
}

// ─── HEADER ──────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final AppState state;
  const _Header({required this.state});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.of(context).padding.top + 20,
        24,
        0,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Fmt.greeting().toUpperCase(),
                    style: AppTheme.geist(
                      size: 9,
                      w: FontWeight.w500,
                      color: AppTheme.textMuted,
                      spacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          state.userName,
                          style: AppTheme.geist(
                            size: 26,
                            w: FontWeight.w500,
                            spacing: -0.3,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '✦',
                          style: AppTheme.geist(size: 16, color: AppTheme.gold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _AvatarCircle(name: state.userName),
          ],
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String name;
  const _AvatarCircle({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.bgSecondary,
        border: Border.all(color: AppTheme.goldDim, width: 0.5),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: AppTheme.geist(
            size: 16,
            w: FontWeight.w500,
            color: AppTheme.gold,
          ),
        ),
      ),
    );
  }
}

// ─── DATE SELECTOR ROW ───────────────────────────────────────────
class _DateSelectorRow extends StatelessWidget {
  final AppState state;
  final int activeIndex;
  final Function(int) onTabChanged;

  const _DateSelectorRow({
    required this.state,
    required this.activeIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: AppTheme.textMuted,
                  ),
                  onPressed: () => state.previousMonth(),
                ),
                GestureDetector(
                  onTap: () {
                    MonthYearPicker.show(context, state.selectedMonth, (
                      newMonth,
                    ) {
                      state.setMonth(newMonth);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.bgSecondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Fmt.monthYear(state.selectedMonth).toUpperCase(),
                          style: AppTheme.geist(size: 15, w: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: AppTheme.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.chevron_right,
                    color: AppTheme.textMuted,
                  ),
                  onPressed: () => state.nextMonth(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TabItem(
                    label: 'Harian',
                    isActive: activeIndex == 0,
                    onTap: () => onTabChanged(0),
                  ),
                  _TabItem(
                    label: 'Kalender',
                    isActive: activeIndex == 1,
                    onTap: () => onTabChanged(1),
                  ),
                  _TabItem(
                    label: 'Bulanan',
                    isActive: activeIndex == 2,
                    onTap: () => onTabChanged(2),
                  ),
                  _TabItem(
                    label: 'Ringkasan',
                    isActive: activeIndex == 3,
                    onTap: () => onTabChanged(3),
                  ),
                  _TabItem(
                    label: 'Deskripsi',
                    isActive: activeIndex == 4,
                    onTap: () => onTabChanged(4),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTheme.border),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: isActive
              ? const Border(bottom: BorderSide(color: AppTheme.rose, width: 2))
              : null,
        ),
        child: Text(
          label,
          style: AppTheme.geist(
            size: 14,
            w: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppTheme.textPrimary : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }
}

// ─── SUMMARY BAR ──────────────────────────────────────────────────
class _SummaryBar extends StatelessWidget {
  final Map<String, double> stats;
  const _SummaryBar({required this.stats});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.bgSecondary.withOpacity(0.3),
          border: const Border(
            bottom: BorderSide(color: AppTheme.border, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SumColumn(
              label: 'Pendapatan',
              value: stats['income'] ?? 0,
              color: Colors.blueAccent,
            ),
            _SumColumn(
              label: 'Pengeluaran',
              value: stats['expense'] ?? 0,
              color: AppTheme.rose,
            ),
            _SumColumn(
              label: 'Total',
              value: stats['net'] ?? 0,
              color: AppTheme.textPrimary,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SumColumn extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isBold;
  const _SumColumn({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTheme.geist(size: 11, color: AppTheme.textMuted)),
        const SizedBox(height: 4),
        CurrencyDisplay(
          amount: value,
          style: AppTheme.mono(
            size: 13,
            w: isBold ? FontWeight.w700 : FontWeight.w500,
          ).copyWith(color: color),
        ),
      ],
    );
  }
}

// ─── GROUPED TRANSACTION LIST ─────────────────────────────────────
class _GroupedTransactionList extends StatelessWidget {
  final AppState state;
  const _GroupedTransactionList({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.transactions.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'Belum ada transaksi',
            style: AppTheme.geist(color: AppTheme.textMuted),
          ),
        ),
      );
    }

    // Sort and Group transactions by Date
    final Map<String, List<Transaction>> grouped = {};
    for (var tx in state.transactions) {
      final dateKey =
          '${tx.date.day.toString().padLeft(2, '0')} ${Fmt.weekday(tx.date)}';
      grouped.putIfAbsent(dateKey, () => []).add(tx);
    }

    final keys = grouped.keys.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final dateKey = keys[index];
        final txs = grouped[dateKey]!;

        final dayIncome = txs
            .where((t) => t.type == TransactionType.income)
            .fold(0.0, (s, t) => s + (t.amount));
        final dayExpense = txs
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (s, t) => s + (t.amount));
        final netBalance = dayIncome - dayExpense;

        return Column(
          children: [
            _DateHeader(dateKey: dateKey, netBalance: netBalance),
            ...txs.map((tx) => _DailyItem(tx: tx)),
          ],
        );
      }, childCount: keys.length),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String dateKey;
  final double netBalance;
  const _DateHeader({required this.dateKey, required this.netBalance});

  @override
  Widget build(BuildContext context) {
    final parts = dateKey.split(' ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppTheme.bgSecondary.withOpacity(0.5),
      child: Row(
        children: [
          Text(parts[0], style: AppTheme.geist(size: 19, w: FontWeight.w700)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              parts[1],
              style: AppTheme.geist(
                size: 10,
                color: AppTheme.textPrimary,
                w: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          Text(
            Fmt.idr(netBalance),
            style: AppTheme.mono(
              size: 13,
              w: FontWeight.w600,
              color: netBalance >= 0 ? Colors.blueAccent : AppTheme.rose,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyItem extends StatelessWidget {
  final Transaction tx;
  const _DailyItem({required this.tx});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigation using MaterialPageRoute for now
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TransactionDetailPage(tx: tx)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.border, width: 0.3),
          ),
        ),
        child: Row(
          children: [
            Text(
              'Other',
              style: AppTheme.geist(size: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: AppTheme.geist(size: 15, w: FontWeight.w500),
                  ),
                  Text(
                    'Cash',
                    style: AppTheme.geist(size: 11, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
            Text(
              Fmt.idr(tx.amount),
              style: AppTheme.mono(
                size: 13,
                color: tx.type == TransactionType.income
                    ? Colors.blueAccent
                    : AppTheme.rose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
