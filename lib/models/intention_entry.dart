enum IntentionInputMethod {
  wheel('wheel'),
  voice('voice');

  const IntentionInputMethod(this.value);

  final String value;

  static IntentionInputMethod fromValue(String value) {
    return values.firstWhere(
      (method) => method.value == value,
      orElse: () => IntentionInputMethod.wheel,
    );
  }
}

class IntentionEntry {
  const IntentionEntry({
    required this.timestamp,
    required this.category,
    required this.description,
    required this.inputMethod,
  });

  final DateTime timestamp;
  final String category;
  final String? description;
  final IntentionInputMethod inputMethod;

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'category': category,
      'description': description,
      'inputMethod': inputMethod.value,
    };
  }

  factory IntentionEntry.fromJson(Map<String, dynamic> json) {
    return IntentionEntry(
      timestamp: DateTime.parse(json['timestamp'] as String),
      category: json['category'] as String,
      description: json['description'] as String?,
      inputMethod: IntentionInputMethod.fromValue(
        json['inputMethod'] as String? ?? IntentionInputMethod.wheel.value,
      ),
    );
  }
}
