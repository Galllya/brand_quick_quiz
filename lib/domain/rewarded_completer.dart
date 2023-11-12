import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdCompleter {
  RewardedAd? rewardedAd;
  final Completer completer;
  final String? adName;

  RewardedAdCompleter({
    this.rewardedAd,
    required this.completer,
    this.adName = 'Not set',
  });
}