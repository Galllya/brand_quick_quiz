import 'dart:async';
import 'dart:developer';
import 'package:brand_quick_quiz/domain/interstitial_loader.dart';
import 'package:brand_quick_quiz/domain/rewarded_completer.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService {
  final _reloadDuration = const Duration(seconds: 1);

  final _interstitials = <String, InterstitialLoader>{};
  RewardedAdCompleter? _rewardedAdCompleter;

  Future<void> loadInterstitial(
    String adId, {
    String? adName,
    int timeout = 5000,
  }) async {
    if (adId.isEmpty) return;
    InterstitialLoader? currentInterLoader = _interstitials[adId];

    void onTimeout() {
      currentInterLoader?.lastTimeout = timeout;
      Future.delayed(
        Duration(milliseconds: timeout),
        () {
          if (currentInterLoader != null &&
              !currentInterLoader.completer.isCompleted) {
            currentInterLoader.completer.completeError(
              'Inter Ad loading timeout (${timeout}ms) - $adId',
            );

            return;
          }
        },
      );
    }

    // Check if current loader exists
    if (currentInterLoader is InterstitialLoader) {
      if (currentInterLoader.wasShown &&
          !currentInterLoader.completer.isCompleted) {
        currentInterLoader.completer
            .completeError('Inter load request repeated');
        _disposeInterstitial(adId);
        return;
      }
      // Set new timeout only if there was no timeout in previous request
      if (currentInterLoader.lastTimeout == 0 && timeout > 0) onTimeout();
      return currentInterLoader.completer.future;
    }

    final newInterLoader =
        InterstitialLoader(completer: Completer(), adName: adName);
    currentInterLoader = newInterLoader;
    _interstitials[adId] = currentInterLoader;

    InterstitialAd.load(
      adUnitId: adId,
      request: const AdRequest(httpTimeoutMillis: 5000),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) async {
          newInterLoader.interstitialAd = ad;
          if (newInterLoader.completer.isCompleted) {
            _disposeInterstitial(adId);
          } else {
            newInterLoader.completer.complete();
          }
        },
        onAdFailedToLoad: (LoadAdError error) async {
          log('InterstitialAd ($adName - $adId) failed to load: $error');

          if (!newInterLoader.completer.isCompleted) {
            newInterLoader.completer.complete();
          }
          await _disposeInterstitial(adId);
        },
      ),
    );

    if (timeout > 0) {
      onTimeout();
    } else {
      newInterLoader.lastTimeout = 0;
    }

    return newInterLoader.completer.future;
  }

  void showInterstitial(String adId, {required VoidCallback? callback}) {
    if (adId.isEmpty) {
      callback?.call();
      return;
    }

    final interLoader = _interstitials[adId];
    if (interLoader == null || interLoader.interstitialAd == null) {
      callback?.call();
      return;
    }

    try {
      interLoader.wasShown = true;
      interLoader.interstitialAd?.fullScreenContentCallback =
          FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          log('$ad onAdShowedFullScreenContent.');
          callback?.call();
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) async {
          log('$ad onAdDismissedFullScreenContent.');
          await _disposeInterstitial(adId);
        },
        onAdFailedToShowFullScreenContent:
            (InterstitialAd ad, AdError error) async {
          log('$ad onAdFailedToShowFullScreenContent: $error');
          callback?.call();
          await _disposeInterstitial(adId);
        },
        onAdImpression: (InterstitialAd ad) {
          log('$ad impression occurred.');
        },
      );
      interLoader.interstitialAd?.show();
    } on Exception catch (e) {
      log('Inter (${interLoader.adName} - $adId) failed to show - $e');

      callback?.call();
    }
  }

  Future<void> _disposeInterstitial(String adId) async {
    await _interstitials[adId]?.interstitialAd?.dispose();
    _interstitials.remove(adId);

    log('Interstitial $adId disposed');
  }

  Future<void> showRewarded(String adId, {VoidCallback? callback}) async {
    if (_rewardedAdCompleter == null) {
      loadRewarded(adId);
      callback?.call();
    }

    if (_rewardedAdCompleter!.completer.isCompleted) {
      try {
        _rewardedAdCompleter!.rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView _, RewardItem __) {
            callback?.call();
          },
        );
      } on Exception catch (e) {
        log('Rewarded (${_rewardedAdCompleter!.adName} - $adId) failed to show - $e');

        rethrow;
      }
    }
  }

  Future<void> loadRewarded(String? adId, {String? adName}) async {
    if (adId == null ||
        adId.isEmpty ||
        _rewardedAdCompleter is RewardedAdCompleter) return;
    final rewardedAd =
        RewardedAdCompleter(completer: Completer(), adName: adName);
    _rewardedAdCompleter = rewardedAd;

    RewardedAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAdCompleter?.rewardedAd = ad;
          _rewardedAdCompleter?.rewardedAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) {
              log('$ad onAdShowedFullScreenContent.');
            },
            onAdDismissedFullScreenContent: (RewardedAd ad) async {
              log('$ad onAdDismissedFullScreenContent.');
              await _disposeRewarded(adId);
            },
            onAdFailedToShowFullScreenContent:
                (RewardedAd ad, AdError error) async {
              log('$ad onAdFailedToShowFullScreenContent: $error');
              await _disposeRewarded(adId, reloadAd: false);
            },
            onAdImpression: (RewardedAd ad) {
              log('$ad impression occurred.');
            },
          );
          rewardedAd.completer.complete();
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('RewardedAd failed to load: $error');

          if (!rewardedAd.completer.isCompleted) {
            rewardedAd.completer.complete();
          }
          _disposeRewarded(adId, reloadAd: false);
        },
      ),
    );

    return rewardedAd.completer.future;
  }

  Future<void> _disposeRewarded(String adId, {bool reloadAd = false}) async {
    _rewardedAdCompleter?.rewardedAd?.dispose();

    _rewardedAdCompleter = null;

    log('Rewarded Ad disposed');

    if (reloadAd) {
      Timer(_reloadDuration, () => loadRewarded(adId));
    }
  }

  Future<void> showAppOpen(String adId) async {
    await AppOpenAd.load(
      adUnitId: adId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          log('$ad loaded');

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              log('$ad onAdShowedFullScreenContent');
            },
            onAdFailedToShowFullScreenContent: (ad, error) async {
              log('$ad onAdFailedToShowFullScreenContent: $error');
              await ad.dispose();
            },
            onAdDismissedFullScreenContent: (ad) async {
              log('$ad onAdDismissedFullScreenContent');

              await ad.dispose();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          log('AppOpenAd failed to load: $error');
        },
      ),
    );
  }
}
