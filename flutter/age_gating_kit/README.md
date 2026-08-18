# AgeGatingKit

Cross-platform age assurance for Flutter.

## Features

- iOS Declared Age Range
- iOS AgeGatingKit
- iOS PermissionKit
- Parental consent
- Significant app update acknowledgement

- Android age signals
- Age range handling
- Regulatory requirements

## Installation

dependencies:
  age_gating_kit: ^1.0.0

## Usage

final result = await AgeGatingKit.checkAge();

print(result.isEligibleForAgeFeatures);
print(result.ageRange);
print(result.requiredRegulatoryFeatures);

