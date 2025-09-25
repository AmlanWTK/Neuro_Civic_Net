import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'tokenizer.dart';

class SentimentService {
  late Interpreter _interpreter;
  late Tokenizer _tokenizer;

  final int maxLen = 50; // must match training input length
  final List<String> labels = ["Negative", "Neutral", "Positive"];

  Future<void> init() async {
    // Load TFLite model with XNNPack delegate (CPU optimized)
    _interpreter = await Interpreter.fromAsset(
      'sentiment_model.tflite',
      options: InterpreterOptions()..addDelegate(XNNPackDelegate()),
    );

    // Load tokenizer from assets
    _tokenizer = Tokenizer();
    await _tokenizer.loadTokenizer("assets/tokenizer.json");

    print("✅ Sentiment model + tokenizer loaded");
  }

  Map<String, dynamic> predict(String text) {
    // Convert text to sequence of integers
    List<int> seq = _tokenizer.textToSequence(text);
    seq = _tokenizer.padSequence(seq, maxLen);

    // Prepare input tensor
    var input = Float32List.fromList(seq.map((e) => e.toDouble()).toList())
        .reshape([1, maxLen]);

    // Prepare output tensor
    var output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

    // Run inference
    _interpreter.run(input, output);

    // Get the label with highest confidence
    double maxVal = output[0].reduce((a, b) => a > b ? a : b);
    int idx = output[0].indexOf(maxVal);

    return {
      "label": labels[idx],
      "confidence": (maxVal * 100).toStringAsFixed(2) + "%"
    };
  }

  void close() {
    _interpreter.close();
  }
}
