class AgeGatingResult {
  final bool isEligibleForAgeFeatures;
  final String? ageRange;
  final List<String> requiredRegulatoryFeatures;

  const AgeGatingResult({
    required this.isEligibleForAgeFeatures,
    required this.ageRange,
    required this.requiredRegulatoryFeatures,
  });

  factory AgeGatingResult.fromMap(Map<dynamic, dynamic> map) {
    return AgeGatingResult(
      isEligibleForAgeFeatures: map['isEligibleForAgeFeatures'] == true,
      ageRange: map['ageRange'] as String?,
      requiredRegulatoryFeatures: List<String>.from(
        map['requiredRegulatoryFeatures'] ?? const [],
      ),
    );
  }

  bool get requiresDeclaredAgeRange =>
      requiredRegulatoryFeatures.contains('declaredAgeRangeRequired');

  bool get requiresParentalConsent => requiredRegulatoryFeatures.contains(
    'significantAppChangeRequiresParentalConsent',
  );

  bool get requiresAdultNotification => requiredRegulatoryFeatures.contains(
    'significantAppChangeRequiresAdultNotification',
  );

  @override
  String toString() {
    return 'AgeGatingResult('
        'isEligibleForAgeFeatures: '
        '$isEligibleForAgeFeatures, '
        'ageRange: $ageRange, '
        'requiredRegulatoryFeatures: '
        '$requiredRegulatoryFeatures'
        ')';
  }
}
