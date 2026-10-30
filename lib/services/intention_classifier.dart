import 'package:focum/models/intention_category.dart';

class IntentionClassifier {
  IntentionCategory classify(
    String description,
    List<IntentionCategory> categories,
  ) {
    final normalizedDescription = _normalize(description);
    IntentionCategory? bestCategory;
    var bestScore = 0;

    for (final category in categories) {
      if (category.id == IntentionCategory.otherId) {
        continue;
      }

      var score = 0;
      for (final keyword in category.keywords) {
        if (normalizedDescription.contains(_normalize(keyword))) {
          score += 1;
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestCategory = category;
      }
    }

    if (bestCategory != null && bestScore > 0) {
      return bestCategory;
    }

    return categories.firstWhere(
      (category) => category.id == IntentionCategory.otherId,
      orElse: () => categories.last,
    );
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp('[àáâãäå]'), 'a')
        .replaceAll(RegExp('[èéêë]'), 'e')
        .replaceAll(RegExp('[ìíîï]'), 'i')
        .replaceAll(RegExp('[òóôõö]'), 'o')
        .replaceAll(RegExp('[ùúûü]'), 'u')
        .replaceAll('ñ', 'n')
        .replaceAll('ç', 'c')
        .replaceAll('ß', 'ss')
        .replaceAll('œ', 'oe')
        .replaceAll(RegExp('[\u0300-\u036f]'), '');
  }
}
