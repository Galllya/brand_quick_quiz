import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialLoader {
  InterstitialAd? interstitialAd;
  final String? adName;
  final Completer completer;
  int? lastTimeout;
  bool wasShown;

  InterstitialLoader({
    this.interstitialAd,
    required this.completer,
    this.lastTimeout,
    this.adName = 'Not set',
    this.wasShown = false,
  });
}
