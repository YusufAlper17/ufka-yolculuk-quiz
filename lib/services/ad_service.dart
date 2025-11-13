import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial ID
    }
    return 'ca-app-pub-8106663637110231/4511624522'; // Gerçek Interstitial ID
  }

  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdReady = false;
  static bool _isInterstitialAdLoading = false;
  static int _numInterstitialLoadAttempts = 0;
  static int maxFailedLoadAttempts = 3;

  static Future<bool> loadInterstitialAd() async {
    if (_isInterstitialAdLoading) return false;
    if (_isInterstitialAdReady) return true;
    
    _isInterstitialAdLoading = true;
    
    try {
      await InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
            _isInterstitialAdLoading = false;
            _numInterstitialLoadAttempts = 0;
            debugPrint('Interstitial reklam başarıyla yüklendi');

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                debugPrint('Interstitial reklam kapatıldı');
                _isInterstitialAdReady = false;
                ad.dispose();
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('Interstitial reklam gösterimi başarısız: $error');
                _isInterstitialAdReady = false;
                ad.dispose();
                loadInterstitialAd();
              },
              onAdShowedFullScreenContent: (ad) {
                debugPrint('Interstitial reklam gösterildi');
              },
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint('Interstitial reklam yüklenemedi: $error');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            _isInterstitialAdReady = false;
            _isInterstitialAdLoading = false;
            
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              loadInterstitialAd();
            }
          },
        ),
      );
      
      // Reklam yüklenene veya maksimum deneme sayısına ulaşana kadar bekle
      int attempts = 0;
      while (!_isInterstitialAdReady && attempts < 5) {
        await Future.delayed(const Duration(seconds: 1));
        attempts++;
      }
      
      return _isInterstitialAdReady;
    } catch (e) {
      debugPrint('Reklam yükleme hatası: $e');
      _isInterstitialAdLoading = false;
      return false;
    }
  }

  static Future<bool> showInterstitialAd() async {
    if (!_isInterstitialAdReady || _interstitialAd == null) {
      // Reklam hazır değilse yüklemeyi dene
      final isLoaded = await loadInterstitialAd();
      if (!isLoaded) return false;
    }

    if (_isInterstitialAdReady && _interstitialAd != null) {
      try {
        await _interstitialAd!.show();
        return true;
      } catch (e) {
        debugPrint('Reklam gösterme hatası: $e');
        return false;
      }
    }
    return false;
  }
} 