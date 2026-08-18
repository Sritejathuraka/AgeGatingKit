import 'package:flutter/material.dart';
import 'package:age_gating_kit/age_gating_kit.dart';
import 'package:age_gating_kit/models/age_gating_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AgeGatingResult? _ageResult;

  String _parentalConsentResult = 'Not requested';
  String _adultNotificationResult = 'Not shown';

  bool _loadingAge = false;
  bool _loadingParental = false;
  bool _loadingAdult = false;

  Future<void> _checkAge() async {
    setState(() {
      _loadingAge = true;
    });

    try {
      final result = await AgeGatingKit.checkAge();

      if (!mounted) return;

      setState(() {
        _ageResult = result;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _parentalConsentResult = 'Age check error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingAge = false;
        });
      }
    }
  }

  Future<void> _requestParentalConsent() async {
    setState(() {
      _loadingParental = true;
      _parentalConsentResult = 'Sending request...';
    });

    try {
      final result =
          await AgeGatingKit.requestParentalConsent(
        description:
            'This update adds new social and communication features.',
      );

      if (!mounted) return;

      setState(() {
        _parentalConsentResult =
            'Status: ${result['status']}\n'
            '${result['message'] ?? ''}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _parentalConsentResult = 'Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingParental = false;
        });
      }
    }
  }

  Future<void> _showAdultNotification() async {
    setState(() {
      _loadingAdult = true;
      _adultNotificationResult = 'Opening...';
    });

    try {
      final result =
          await AgeGatingKit.showAdultNotification(
        description:
            'This update adds new social and communication features.',
      );

      if (!mounted) return;

      setState(() {
        _adultNotificationResult =
            'Status: ${result['status']}\n'
            '${result['message'] ?? ''}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _adultNotificationResult = 'Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingAdult = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final requiresParentalConsent =
        _ageResult?.requiresParentalConsent ?? false;

    final requiresAdultNotification =
        _ageResult?.requiresAdultNotification ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AgeGatingKit Example'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Age Information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Eligible: '
                  '${_ageResult?.isEligibleForAgeFeatures ?? '-'}',
                ),

                const SizedBox(height: 8),

                Text(
                  'Age Range: '
                  '${_ageResult?.ageRange ?? '-'}',
                ),

                const SizedBox(height: 8),

                Text(
                  'Required Regulatory Features:\n'
                  '${_ageResult?.requiredRegulatoryFeatures.join('\n') ?? '-'}',
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed:
                      _loadingAge ? null : _checkAge,
                  child: Text(
                    _loadingAge
                        ? 'Checking...'
                        : 'Check Age',
                  ),
                ),

                const Divider(height: 48),

                const Text(
                  'Parental Consent',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  requiresParentalConsent
                      ? 'Required'
                      : 'Not Required',
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed:
                      requiresParentalConsent &&
                              !_loadingParental
                          ? _requestParentalConsent
                          : null,
                  child: Text(
                    _loadingParental
                        ? 'Requesting...'
                        : 'Request Parental Consent',
                  ),
                ),

                const SizedBox(height: 12),

                Text(_parentalConsentResult),

                const Divider(height: 48),

                const Text(
                  'Adult Notification',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  requiresAdultNotification
                      ? 'Required'
                      : 'Not Required',
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed:
                      requiresAdultNotification &&
                              !_loadingAdult
                          ? _showAdultNotification
                          : null,
                  child: Text(
                    _loadingAdult
                        ? 'Opening...'
                        : 'Show Adult Notification',
                  ),
                ),

                const SizedBox(height: 12),

                Text(_adultNotificationResult),
              ],
            ),
          ),
        ),
      ),
    );
  }
}