import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main/main_scaffold.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    _ctrl.forward();

    // Navigate after 1 second
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const MainScaffold(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: const _SpendlyLogo(),
          ),
        ),
      ),
    );
  }
}

// ─── SPENDLY LOGO ────────────────────────────────────────────────
class _SpendlyLogo extends StatelessWidget {
  const _SpendlyLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 52,
          height: 52,
          child: CustomPaint(painter: _SMarkPainter()),
        ),
        const SizedBox(width: 12),
        Text(
          'spendly',
          style: GoogleFonts.sora(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -1.0,
          ),
        ),
      ],
    );
  }
}

class _SMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Top bar
    final top = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.08, w * 0.76, h * 0.24),
        Radius.circular(w * 0.06),
      ),
      top,
    );

    // Middle diagonal connector
    final mid = Paint()..color = Colors.white.withOpacity(0.75);
    final midPath = Path()
      ..moveTo(w * 0.12, h * 0.38)
      ..lineTo(w * 0.88, h * 0.38)
      ..lineTo(w * 0.62, h * 0.62)
      ..lineTo(w * 0.12, h * 0.62)
      ..close();
    canvas.drawPath(midPath, mid);

    // Bottom bar
    final bot = Paint()..color = Colors.white.withOpacity(0.55);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.68, w * 0.76, h * 0.24),
        Radius.circular(w * 0.06),
      ),
      bot,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}