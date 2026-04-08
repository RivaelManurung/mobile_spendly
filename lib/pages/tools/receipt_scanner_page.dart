import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_spendly/utils/app_theme.dart';

class ReceiptScannerPage extends StatefulWidget {
  const ReceiptScannerPage({super.key});

  @override
  State<ReceiptScannerPage> createState() => _ReceiptScannerPageState();
}

class _ReceiptScannerPageState extends State<ReceiptScannerPage> with SingleTickerProviderStateMixin {
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated Camera View
          Positioned.fill(
            child: Container(
              color: Colors.grey[900],
              child: const Center(child: Icon(LucideIcons.camera, size: 64, color: Colors.white30)),
            ),
          ),

          // Scan Line Animation
          AnimatedBuilder(
            animation: _scanController,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * 0.2 + (_scanController.value * MediaQuery.of(context).size.height * 0.5),
                left: 40,
                right: 40,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.5), blurRadius: 20, spreadRadius: 4)],
                  ),
                ),
              );
            },
          ),

          // Overlay UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: const Icon(LucideIcons.x, color: Colors.white), onPressed: () => Navigator.pop(context)),
                      const Icon(LucideIcons.zap, color: Colors.white),
                    ],
                  ),
                  const Column(
                    children: [
                      Text('Posisikan Struk di Dalam Bingkai', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('AI akan membaca data otomatis', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _cameraButton(LucideIcons.image),
                      _shutterButton(),
                      _cameraButton(Icons.history),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shutterButton() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
      child: Container(width: 64, height: 64, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
    );
  }

  Widget _cameraButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white),
    );
  }
}
