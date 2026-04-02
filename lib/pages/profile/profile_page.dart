import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/utils/app_theme.dart';
import 'package:mobile_spendly/utils/formatters.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return Scaffold(
        backgroundColor: AppTheme.bgPrimary,
        appBar: AppBar(
          title: Text('Profil', style: AppTheme.geist(size: 17, w: FontWeight.w600)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.settings, size: 20),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Avatar Section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.bgSecondary,
                        border: Border.all(color: AppTheme.goldDim, width: 0.5),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          state.userName.isNotEmpty ? state.userName[0].toUpperCase() : 'U',
                          style: AppTheme.geist(size: 32, w: FontWeight.w700, color: AppTheme.gold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(state.userName, style: AppTheme.geist(size: 20, w: FontWeight.w700)),
                    Text('Premium Member ✦', style: AppTheme.geist(size: 12, color: AppTheme.gold, w: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary stats
                    Row(
                      children: [
                        _StatTile(
                            label: 'TOTAL TRANSAKSI',
                            value: '${state.transactions.length}',
                            icon: LucideIcons.receipt,
                            color: Colors.blueAccent),
                        const SizedBox(width: 16),
                        _StatTile(
                            label: 'SALDO BERSIH',
                            value: Fmt.idrCompact(state.totalBalance),
                            icon: LucideIcons.wallet,
                            color: state.totalBalance >= 0 ? AppTheme.emerald : AppTheme.rose),
                      ],
                    ),
                    const SizedBox(height: 32),

                    _sectionLabel('PENGATURAN AKUN'),
                    const SizedBox(height: 12),
                    _buildMenuCard([
                      _MenuItem(icon: LucideIcons.user, label: 'Edit Profil', onTap: () {}),
                      _MenuItem(icon: LucideIcons.lock, label: 'Keamanan & Privasi', onTap: () {}),
                      _MenuItem(icon: LucideIcons.bell, label: 'Notifikasi', onTap: () {}),
                    ]),

                    const SizedBox(height: 24),
                    _sectionLabel('DATA & LAPORAN'),
                    const SizedBox(height: 12),
                    _buildMenuCard([
                      _MenuItem(icon: LucideIcons.fileText, label: 'Export Laporan (PDF/CSV)', onTap: () {}),
                      _MenuItem(icon: LucideIcons.database, label: 'Sinkronisasi Data cloud', onTap: () {}),
                    ]),

                    const SizedBox(height: 24),
                    _sectionLabel('DUKUNGAN'),
                    const SizedBox(height: 12),
                    _buildMenuCard([
                      _MenuItem(icon: LucideIcons.helpCircle, label: 'Pusat Bantuan', onTap: () {}),
                      _MenuItem(icon: LucideIcons.star, label: 'Beri Penilaian', onTap: () {}),
                      _MenuItem(icon: LucideIcons.logOut, label: 'Keluar Akun', color: AppTheme.rose, onTap: () {}),
                    ]),

                    const SizedBox(height: 48),
                    Center(
                      child: Text(
                        'Spendly v1.0.4 PRO',
                        style: AppTheme.geist(size: 11, color: AppTheme.textMuted, spacing: 0.5),
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _sectionLabel(String label) => Text(
        label,
        style: AppTheme.geist(
          size: 10,
          w: FontWeight.w700,
          color: AppTheme.textMuted,
          spacing: 1.0,
        ),
      );

  Widget _buildMenuCard(List<_MenuItem> items) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (item.color ?? AppTheme.textPrimary).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, size: 18, color: item.color ?? AppTheme.textPrimary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(item.label,
                            style: AppTheme.geist(
                                size: 14,
                                w: FontWeight.w600,
                                color: item.color ?? AppTheme.textPrimary)),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.textMuted),
                    ],
                  ),
                ),
              ),
              if (e.key < items.length - 1)
                const Divider(height: 1, indent: 54, color: AppTheme.border),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 12),
            Text(label, style: AppTheme.geist(size: 9, w: FontWeight.w600, color: AppTheme.textMuted, spacing: 0.5)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value, style: AppTheme.mono(size: 17, w: FontWeight.w700, color: AppTheme.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.color});
}
