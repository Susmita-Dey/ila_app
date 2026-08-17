import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuoteService {
  final List<String> quotes;

  QuoteService(this.quotes);

  static Future<QuoteService> init() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/quotes.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final List<String> loadedQuotes = jsonList.cast<String>();
      return QuoteService(loadedQuotes);
    } catch (e) {
      // Fallback if asset loading fails
      return QuoteService([
        'Your body is not broken — it is asking to be understood.',
      ]);
    }
  }

  String getTodaysQuote() {
    if (quotes.isEmpty) return 'Have a wonderful day.';
    final now = DateTime.now();
    // Use day of year as seed
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return quotes[dayOfYear % quotes.length];
  }
}

// Global provider for the QuoteService. We'll initialize this during app startup or handle async loading.
final quoteServiceProvider = FutureProvider<QuoteService>((ref) async {
  return await QuoteService.init();
});
