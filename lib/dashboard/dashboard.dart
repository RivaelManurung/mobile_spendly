import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Helper untuk Staggered Animation
  Animation<double> _createAnimation(double begin, double end) {
    return CurvedAnimation(
      parent: _animController,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // HEADER
                  FadeTransition(
                    opacity: _createAnimation(0.0, 0.4),
                    child: _buildHeader(colorScheme),
                  ),
                  const SizedBox(height: 32),

                  // BALANCE CARD
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_createAnimation(0.2, 0.6)),
                    child: FadeTransition(
                      opacity: _createAnimation(0.2, 0.6),
                      child: _buildBalanceCard(colorScheme),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // QUICK ACTIONS
                  FadeTransition(
                    opacity: _createAnimation(0.4, 0.8),
                    child: _buildQuickActions(colorScheme),
                  ),
                  const SizedBox(height: 36),

                  // RECENT TRANSACTIONS HEADER
                  FadeTransition(
                    opacity: _createAnimation(0.5, 0.9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                          ),
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),

            // TRANSACTIONS LIST (Menggunakan SliverList agar optimal)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Animasi list yang muncul bergantian
                    final animationStart = 0.6 + (index * 0.05).clamp(0.0, 0.4);
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(_createAnimation(animationStart, 1.0)),
                      child: FadeTransition(
                        opacity: _createAnimation(animationStart, 1.0),
                        child: _transactionMockData[index],
                      ),
                    );
                  },
                  childCount: _transactionMockData.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Rivael',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: colorScheme.primaryContainer,
          backgroundImage: const NetworkImage(
            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E3192).withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.white.withOpacity(0.8)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '\$12,450.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Number',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '**** **** **** 3456',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              // Mengganti Icon biasa dengan logo mastercard/visa style
              Row(
                children: [
                  CircleAvatar(radius: 12, backgroundColor: Colors.redAccent.withOpacity(0.8)),
                  Transform.translate(
                    offset: const Offset(-10, 0),
                    child: CircleAvatar(radius: 12, backgroundColor: Colors.orangeAccent.withOpacity(0.8)),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(Icons.arrow_upward_rounded, 'Send', const Color(0xFFFF9800), colorScheme),
        _buildActionButton(Icons.arrow_downward_rounded, 'Receive', const Color(0xFF009688), colorScheme),
        _buildActionButton(Icons.account_balance_wallet_rounded, 'Top Up', const Color(0xFF2196F3), colorScheme),
        _buildActionButton(Icons.grid_view_rounded, 'More', const Color(0xFF9C27B0), colorScheme),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, ColorScheme colorScheme) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            highlightColor: color.withOpacity(0.1),
            splashColor: color.withOpacity(0.2),
            child: Ink(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: colorScheme.brightness == Brightness.light 
                    ? color.withOpacity(0.1) 
                    : color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // Memisahkan widget item ke class tersendiri adalah best practice
  final List<Widget> _transactionMockData = const [
    TransactionTile(
      icon: Icons.fastfood_rounded,
      title: 'McDonald\'s',
      date: 'Today, 12:30 PM',
      amount: '-\$15.50',
      iconColor: Colors.orange,
    ),
    TransactionTile(
      icon: Icons.work_rounded,
      title: 'Upwork Salary',
      date: 'Yesterday, 09:00 AM',
      amount: '+\$850.00',
      iconColor: Colors.green,
    ),
    TransactionTile(
      icon: Icons.apple_rounded,
      title: 'Apple Store',
      date: '28 Mar 2026, 16:45',
      amount: '-\$120.00',
      iconColor: Colors.grey,
    ),
    TransactionTile(
      icon: Icons.subscriptions_rounded,
      title: 'Netflix',
      date: '28 Mar 2026, 10:00',
      amount: '-\$14.99',
      iconColor: Colors.red,
    ),
  ];
}

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final Color iconColor;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = amount.startsWith('+');
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isIncome ? Colors.green : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
