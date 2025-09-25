import 'package:flutter/material.dart';
import 'package:neurocivicnet/sentiment_analysis/sentiment_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sentimentService = SentimentService();
  await sentimentService.init();

  runApp(MyApp(sentimentService));
}

class MyApp extends StatelessWidget {
  final SentimentService sentimentService;
  const MyApp(this.sentimentService, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentiment Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text("Sentiment Analysis")),
        body: Center(
          child: SentimentInput(sentimentService: sentimentService),
        ),
      ),
    );
  }
}

class SentimentInput extends StatefulWidget {
  final SentimentService sentimentService;
  const SentimentInput({super.key, required this.sentimentService});

  @override
  State<SentimentInput> createState() => _SentimentInputState();
}

class _SentimentInputState extends State<SentimentInput> {
  final TextEditingController _controller = TextEditingController();
  String? result;

  void analyze() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final prediction = widget.sentimentService.predict(text);
    setState(() {
      result = "${prediction['label']} (${prediction['confidence']})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: _controller, decoration: const InputDecoration(labelText: "Enter text")),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: analyze, child: const Text("Analyze")),
          if (result != null) ...[
            const SizedBox(height: 20),
            Text("Result: $result", style: const TextStyle(fontSize: 18))
          ]
        ],
      ),
    );
  }
}
