
import 'package:flutter_test/flutter_test.dart';
import 'package:neurocivicnet/main.dart';
import 'package:neurocivicnet/sentiment_analysis/sentiment_service.dart';

void main() {
  testWidgets('App loads with SentimentService', (WidgetTester tester) async {
    // Create a fake SentimentService
    final sentimentService = SentimentService();
    await sentimentService.init();

    // Pump the widget with dependency
    await tester.pumpWidget(MyApp(sentimentService));

    // Just check if app title exists (instead of counter test)
    expect(find.text("Sentiment Analysis"), findsOneWidget);
  });
}
