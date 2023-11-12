import 'dart:developer';
import 'package:brand_quick_quiz/values/constants.dart';
import 'package:flutter/foundation.dart';
import '../services/admob_service.dart';

mixin AdmobMixin {
  final _admobService = AdmobService();

  Future<void> loadInterstitial(
    AdIdKey adId, {
    int timeout = 5000,
    int delay = 0,
    VoidCallback? callback,
  }) async {
    try {
      final loader = _admobService.loadInterstitial(
        _getAdIdValue(adId),
        adName: adId.name,
        timeout: delay + timeout,
      );
      await Future.delayed(Duration(milliseconds: delay));
      await loader;
      callback?.call();
    } catch (e) {
      log(e.toString());
    }
  }

  void showInterstitial(AdIdKey adId, {VoidCallback? callback}) =>
      _admobService.showInterstitial(_getAdIdValue(adId), callback: callback);

  Future<void> loadAndShowInterstitial(
    AdIdKey adId, {
    VoidCallback? callback,
    int timeout = 5000,
    int delay = 0,
  }) async {
    await loadInterstitial(adId, timeout: timeout, delay: delay);
    showInterstitial(adId, callback: callback);
  }

  Future<void> showAppOpen(AdIdKey adId) async =>
      await _admobService.showAppOpen(_getAdIdValue(adId));

  Future<void> loadRewarded(AdIdKey adId, {VoidCallback? callback}) =>
      _admobService.loadRewarded(
        _getAdIdValue(adId),
        adName: adId.name,
      );

  Future<void> showRewarded(AdIdKey adId,
      {required VoidCallback callback}) async {
    try {
      await _admobService.showRewarded(
        _getAdIdValue(adId),
        callback: callback,
      );
    } catch (e) {
      log('Rewarded: ${e.toString()}');
    }
  }

  String _getAdIdValue(AdIdKey adIdKey) =>
      kDebugMode ? adIdKey.testId : adIdKey.prodId;
}

enum AdIdKey {
  inter_quiz_end(
    testId: Constants.testInterstitialId,
    prodId: Constants.prodInterstitialId,
  ),
  app_open(
    testId: Constants.testAppOpenId,
    prodId: Constants.prodAppOpenId,
  ),
  rewarded(
    testId: Constants.testRewardedId,
    prodId: Constants.prodRewardedId,
  );

  final String testId;
  final String prodId;

  const AdIdKey({required this.testId, required this.prodId});
}
