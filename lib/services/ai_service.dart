import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_spendly/models/transaction.dart';
import 'package:mobile_spendly/models/financial_goal.dart';

class AIService {
  static const String _apiKey = 'AIzaSyCcjkqOQrZIOAkferjt0Arkzzr6_pafLIE';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  
  Future<String> getFinancialInsight({
    required List<Transaction> transactions,
    required List<FinancialGoal> goals,
    required double monthlyBudget,
    String? userQuestion,
  }) async {
    // Basic Rate-Limit Prevention: Add a small delay if called too rapidly
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      final summary = _generateContextSummary(transactions, goals, monthlyBudget);
      
      String prompt = "";
      if (userQuestion != null) {
        prompt = "Konteks keuangan: $summary\nPertanyaan: $userQuestion\nJawab singkat, padat, dan solutif (maksimal 2 paragraf).";
      } else {
        prompt = "Analisis data ini: $summary\nBerikan 3 poin insight singkat untuk membantu saya berhemat. Gunakan bahasa Indonesia yang ramah.";
      }

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": prompt}]}],
          "generationConfig": {
            "temperature": 0.4, // More focused responses
            "maxOutputTokens": 800,
          }
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        }
        return "AI memberikan respons kosong. Silakan coba lagi.";
      } else if (response.statusCode == 429) {
        return "Terlalu banyak permintaan (Rate Limit). Tunggu 10 detik lalu klik Refresh kembali.";
      } else if (response.statusCode == 503) {
        return "Server Google sedang sangat sibuk. Silakan coba beberapa saat lagi.";
      } else {
        return "Gangguan API (${response.statusCode}). Mohon periksa kembali koneksi Anda.";
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        return "Koneksi ke AI Analyst lambat. Silakan coba lagi nanti.";
      }
      return "Terjadi kendala teknis. AI Analyst saat ini tidak tersedia.";
    }
  }

  String _generateContextSummary(List<Transaction> txs, List<FinancialGoal> goals, double budget) {
    double income = txs.where((t) => t.type == TransactionType.income).fold(0, (s, t) => s + t.amount);
    double expense = txs.where((t) => t.type == TransactionType.expense || t.type == TransactionType.goal).fold(0, (s, t) => s + t.amount);
    
    // Use helper for formatting in prompt to avoid AI confusion
    String format(double val) => "Rp ${val.toStringAsFixed(0)}";

    String txSummary = txs.take(20).map((t) => "- ${t.date.day}/${t.date.month}: ${t.title} (${t.type.name}) ${format(t.amount)}").join("\n");
    String goalSummary = goals.map((g) => "- ${g.title}: Progres ${(g.currentAmount/g.targetAmount*100).toStringAsFixed(1)}% (Terkumpul ${format(g.currentAmount)} dari ${format(g.targetAmount)})").join("\n");

    return """
Status Keuangan (Satuan Rupiah):
- Total Pemasukan: ${format(income)}
- Total Pengeluaran: ${format(expense)}
- Sisa Saldo: ${format(income - expense)}
- Anggaran Bulanan: ${format(budget)}

Riwayat 20 Transaksi Terakhir:
$txSummary

Financial Goals:
$goalSummary
""";
  }
}
