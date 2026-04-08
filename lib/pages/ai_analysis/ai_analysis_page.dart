import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_spendly/state/app_state.dart';
import 'package:mobile_spendly/utils/app_theme.dart';

class AIAnalysisPage extends StatefulWidget {
  const AIAnalysisPage({super.key});

  @override
  State<AIAnalysisPage> createState() => _AIAnalysisPageState();
}

class _AIAnalysisPageState extends State<AIAnalysisPage> {
  final TextEditingController _questionCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(LucideIcons.sparkles, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 12),
            Text('AI Financial Analyst', style: AppTheme.geist(size: 17, w: FontWeight.w700)),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, size: 18),
            onPressed: () => context.read<AppState>().refreshAIInsight(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AppState>(
              builder: (context, state, child) {
                return ListView(
                  controller: _scrollCtrl,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildAIModule(
                      title: 'INSIGHT KEUANGAN ANDA',
                      content: state.latestAIInsight,
                      isLoading: state.isAIAnalysing,
                    ),
                    const SizedBox(height: 32),
                    if (state.isAIAnalysing)
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
                            ),
                            const SizedBox(height: 16),
                            Text('Menganalisis data...', style: AppTheme.geist(size: 12, color: AppTheme.textMuted)),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 100),
                  ],
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildAIModule({required String title, required String content, required bool isLoading}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(LucideIcons.zap, size: 14, color: Colors.blueAccent),
              ),
              const SizedBox(width: 12),
              Text(title, style: AppTheme.geist(size: 10, w: FontWeight.w800, color: AppTheme.textMuted, spacing: 1.0)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            content,
            style: AppTheme.geist(
              size: 15,
              height: 1.7,
              color: AppTheme.textPrimary,
              w: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: AppTheme.bgPrimary,
        border: Border(top: BorderSide(color: AppTheme.border.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: AppTheme.bgSecondary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                controller: _questionCtrl,
                style: AppTheme.geist(size: 14, w: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Tanyakan sesuatu tentang keuanganmu...',
                  hintStyle: AppTheme.geist(size: 14, color: AppTheme.textMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _handleSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(color: AppTheme.textPrimary, shape: BoxShape.circle),
              child: const Icon(LucideIcons.send, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    if (_questionCtrl.text.isEmpty) return;
    
    final question = _questionCtrl.text;
    _questionCtrl.clear();
    
    context.read<AppState>().refreshAIInsight(userQuestion: question);
    
    FocusScope.of(context).unfocus();
    // No need to scroll if we replace the main insight, but good for UX
    _scrollCtrl.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}
