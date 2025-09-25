import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Tokenizer {
  late Map<String, int> _wordIndex;

  Future<void> loadTokenizer(String path) async {
    String data = await rootBundle.loadString(path);
    _wordIndex = Map<String, int>.from(json.decode(data));
  }

  List<int> textToSequence(String text) {
    final words = text.toLowerCase().split(RegExp(r"\s+"));
    return words.map((w) => _wordIndex[w] ?? 0).toList();
  }

  List<int> padSequence(List<int> seq, int maxLen) {
    if (seq.length > maxLen) {
      return seq.sublist(0, maxLen);
    } else if (seq.length < maxLen) {
      return List<int>.filled(maxLen - seq.length, 0) + seq;
    }
    return seq;
  }
}
