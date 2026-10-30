import 'package:flutter_test/flutter_test.dart';
import 'package:focum/models/intention_category.dart';
import 'package:focum/services/intention_classifier.dart';

void main() {
  group('IntentionClassifier', () {
    test('classifies work-related text', () {
      final classifier = IntentionClassifier();

      final result = classifier.classify(
        'Voy a contestar correos del trabajo',
        IntentionCategory.defaults,
      );

      expect(result.id, 'work');
    });

    test('falls back to other when text is unclear', () {
      final classifier = IntentionClassifier();

      final result = classifier.classify(
        'Solo voy a mirar una cosa',
        IntentionCategory.defaults,
      );

      expect(result.id, IntentionCategory.otherId);
    });
  });
}
