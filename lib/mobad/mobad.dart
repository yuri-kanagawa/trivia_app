import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

//String getTestAdInterstitialUnitId(){
//  print("test");
//  String testBannerUnitId = "";
//
//  if (MobileAds.instance == null) {
//    print("initialize:AdMob");
//    MobileAds.instance.initialize();
//  }
//
//  if(Platform.isAndroid) {
//    // Android のとき
//    testBannerUnitId = "ca-app-pub-3940256099942544/1033173712";
//  } else if(Platform.isIOS) {
//    // iOSのとき
//    testBannerUnitId = "ca-app-pub-3940256099942544/4411468910";
//    //testBannerUnitId = "ca-app-pub-4442813724554686~3490246111";
//  }
//  return testBannerUnitId;
//}

class Adcount {
  //10回のカウントを行う
  //int count;
  static counter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('counter');
    print(count);
    if (count == null) {
      prefs.setInt('counter', 1);
      count = prefs.getInt('counter');
    }

    if (count > 9) {
      prefs.setInt('counter', 1);
      AdmobService.showInterstitialAd();
    } else {
      count++;
      prefs.setInt('counter', count);
    }
  }
}

class AdmobService {
  static InterstitialAd _interstitialAd;

  static String get iOSInterstitialAdUnitID => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/4411468910'
      : 'ca-app-pub-3940256099942544/4411468910';

  static initialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static InterstitialAd _createInterstitialAd() {
    return InterstitialAd(
      adUnitId: iOSInterstitialAdUnitID,
      request: AdRequest(),
      listener: AdListener(
          onAdLoaded: (Ad ad) => {_interstitialAd.show()},
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('Ad failed to load: $error');
          },
          onAdOpened: (Ad ad) => print('Ad opened.'),
          onAdClosed: (Ad ad) => {_interstitialAd.dispose()},
          onApplicationExit: (Ad ad) => {_interstitialAd.dispose()}),
    );
  }

  static void showInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;

    if (_interstitialAd == null) _interstitialAd = _createInterstitialAd();

    _interstitialAd.load();
  }
}
