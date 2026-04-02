import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main/main_scaffold.dart';

// ─── THEME ───────────────────────────────────────────────────────
class _T {
  static const bg       = Color(0xFFFFFFFF);
  static const card     = Color(0xFFF8F9FA);
  static const border   = Color(0x1F000000);
  static const gold     = Color(0xFFB08900);
  static const goldDim  = Color(0x15B08900);
  static const emerald  = Color(0xFF059669);
  static const rose     = Color(0xFFE11D48);
  static const violet   = Color(0xFF7C3AED);
  static const text     = Color(0xFF0F172A);
  static const muted    = Color(0xFF64748B);
  static const dim      = Color(0xFFE2E8F0);

  static TextStyle geist({
    double size = 14,
    FontWeight w = FontWeight.w400,
    Color? color,
    double? spacing,
    double? height,
  }) =>
      GoogleFonts.getFont('Inter',
          fontSize: size,
          fontWeight: w,
          color: color ?? text,
          letterSpacing: spacing,
          height: height);

  static TextStyle mono({
    double size = 13,
    FontWeight w = FontWeight.w300,
    Color? color,
  }) =>
      GoogleFonts.getFont('Roboto Mono',
          fontSize: size, fontWeight: w, color: color ?? muted);
}

// ─── GLOBAL ICON WIDGET ──────────────────────────────────────────
class _GlobalIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _GlobalIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: 72,
          color: color,
        ),
      ),
    );
  }
}

// ─── ONBOARDING DATA ─────────────────────────────────────────────
class _Page {
  final String tag, title, subtitle, detail;
  final Color accent;
  final Widget Function() icon;

  const _Page({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.accent,
    required this.icon,
  });
}

final List<_Page> _pages = [
  _Page(
    tag: '01 / SELAMAT DATANG',
    title: 'Kendali\nPenuh atas\nUangmu',
    subtitle: 'Spendly',
    detail:
        'Satu tempat untuk semua keuanganmu — dari cashflow harian hingga target jangka panjang.',
    accent: _T.gold,
    icon: () => const _GlobalIcon(icon: Icons.account_balance_wallet_outlined, color: _T.gold),
  ),
  _Page(
    tag: '02 / CATAT OTOMATIS',
    title: 'Scan Struk,\nLangsung\nTercatat',
    subtitle: 'Receipt Scanner',
    detail:
        'Foto struk belanja, AI kami membaca dan mengkategorikan pengeluaran dalam hitungan detik.',
    accent: _T.emerald,
    icon: () => const _GlobalIcon(icon: Icons.document_scanner_outlined, color: _T.emerald),
  ),
  _Page(
    tag: '03 / ANALISIS CERDAS',
    title: 'AI yang\nMengerti\nPola Kamu',
    subtitle: 'AI Analyst',
    detail:
        'Setiap bulan, AI analyst memberi laporan mendalam: ke mana uangmu pergi dan cara mengoptimalkannya.',
    accent: _T.violet,
    icon: () => const _GlobalIcon(icon: Icons.auto_awesome_rounded, color: _T.violet),
  ),
  _Page(
    tag: '04 / INVOICE',
    title: 'Tagih Klien\nTanpa\nRibet',
    subtitle: 'Invoice Manager',
    detail:
        'Buat, kirim, dan pantau invoice freelance-mu. Tidak ada lagi pembayaran yang terlupakan.',
    accent: _T.rose,
    icon: () => const _GlobalIcon(icon: Icons.request_quote_outlined, color: _T.rose),
  ),
  _Page(
    tag: '05 / TARGET',
    title: 'Tabung\nLebih Cepat,\nLebih Pintar',
    subtitle: 'Budget & Goals',
    detail:
        'Set budget per kategori dan financial goals. Spendly akan mengingatkan sebelum kamu overspend.',
    accent: _T.gold,
    icon: () => const _GlobalIcon(icon: Icons.track_changes_rounded, color: _T.gold),
  ),
];

// ─── MAIN SCREEN ─────────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pc = PageController();
  int _cur = 0;

  late AnimationController _fadeCtrl;
  late AnimationController _floatCtrl;
  late Animation<double> _fade;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _floatCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat(reverse: true);

    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _float = CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut);

    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _pc.dispose();
    _fadeCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_cur < _pages.length - 1) {
      _fadeCtrl.reset();
      _pc.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic);
      _fadeCtrl.forward();
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const MainScaffold(),
          transitionsBuilder: (_, a, __, child) => FadeTransition(
            opacity: a,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  void _skip() {
    _pc.animateToPage(_pages.length - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_cur];
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _T.bg,
      body: Stack(
        children: [
          // Ambient glow background
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
            top: -100,
            left: _cur.isEven ? -60 : size.width * 0.3,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: page.accent.withOpacity(0.06),
              ),
            ),
          ),

          // Page content
          PageView.builder(
            controller: _pc,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (i) => setState(() => _cur = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _PageContent(
              page: _pages[i],
              float: _float,
              fade: _fade,
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomBar(
              cur: _cur,
              total: _pages.length,
              accent: page.accent,
              onNext: _next,
              onSkip: _skip,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PAGE CONTENT ────────────────────────────────────────────────
class _PageContent extends StatelessWidget {
  final _Page page;
  final Animation<double> float;
  final Animation<double> fade;

  const _PageContent({
    required this.page,
    required this.float,
    required this.fade,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        // Adjust icon and text sizes based on available height
        final iconScale = screenHeight < 600 ? 0.7 : 1.0;
        final titleSize = screenHeight < 600 ? 32.0 : 42.0;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 160),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag line
                    FadeTransition(
                      opacity: fade,
                      child: Text(
                        page.tag,
                        style: _T.mono(size: 10, color: page.accent.withOpacity(0.7)),
                      ),
                    ),

                    SizedBox(height: screenHeight < 600 ? 16 : 32),

                    // Floating icon
                    AnimatedBuilder(
                      animation: float,
                      builder: (_, __) => Transform.translate(
                        offset: Offset(0, -10 + float.value * 20),
                        child: Center(
                          child: Transform.scale(
                            scale: iconScale,
                            child: page.icon(),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight < 600 ? 24 : 40),

                    // Title
                    FadeTransition(
                      opacity: fade,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                            parent: fade, curve: Curves.easeOutCubic)),
                        child: Text(
                          page.title,
                          style: _T.geist(
                            size: titleSize,
                            w: FontWeight.w300,
                            spacing: -1.2,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle badge
                    FadeTransition(
                      opacity: fade,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: page.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: page.accent.withOpacity(0.2), width: 0.5),
                        ),
                        child: Text(
                          page.subtitle,
                          style: _T.mono(size: 10, color: page.accent),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Detail text
                    FadeTransition(
                      opacity: fade,
                      child: Text(
                        page.detail,
                        style: _T.geist(
                          size: 15,
                          color: _T.muted,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── BOTTOM BAR ──────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final int cur, total;
  final Color accent;
  final VoidCallback onNext, onSkip;

  const _BottomBar({
    required this.cur,
    required this.total,
    required this.accent,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = cur == total - 1;

    return Container(
      padding: EdgeInsets.fromLTRB(
          28, 20, 28, MediaQuery.of(context).padding.bottom + 28),
      decoration: BoxDecoration(
        color: _T.bg,
        border: Border(top: BorderSide(color: _T.border, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dots
          Row(
            children: List.generate(total, (i) {
              final active = i == cur;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                margin: const EdgeInsets.only(right: 6),
                height: 3,
                width: active ? 28 : 6,
                decoration: BoxDecoration(
                  color: active ? accent : _T.dim,
                  borderRadius: BorderRadius.circular(99),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              if (!isLast)
                GestureDetector(
                  onTap: onSkip,
                  child: Text(
                    'Lewati',
                    style: _T.geist(size: 14, color: _T.muted),
                  ),
                ),
              const Spacer(),
              _NextButton(
                isLast: isLast,
                accent: accent,
                onTap: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatefulWidget {
  final bool isLast;
  final Color accent;
  final VoidCallback onTap;

  const _NextButton({
    required this.isLast,
    required this.accent,
    required this.onTap,
  });

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isLast ? 32 : 22,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: widget.accent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isLast ? 'Mulai Sekarang' : 'Lanjut',
                style: _T.geist(
                  size: 14,
                  w: FontWeight.w500,
                  color: Colors.white,
                  spacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                widget.isLast
                    ? Icons.arrow_forward_rounded
                    : Icons.arrow_forward_rounded,
                size: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}