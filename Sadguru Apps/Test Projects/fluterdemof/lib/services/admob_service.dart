import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdMs {
  static String getAdMobAppId() {
    if (Platform.isIOS) {
      return "";
    } else if (Platform.isAndroid) {
      //    return "ca-app-pub-8815607260664500~3292293461";
      return "ca-app-pub-8815607260664500~2287196347";
    } else {
      return "";
    }
  }

  static String getBannerAdId() {
    if (Platform.isIOS) {
      return "";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      return "";
    }
  }

  static String getInterCesticalAdId() {
    if (Platform.isIOS) {
      return "";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      return "";
    }
  }

  static String getRewardAdId() {
    if (Platform.isIOS) {
      return "";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else {
      return "";
    }
  }

/*
  static BannerAd _homeBannerAd;

  static BannerAd _getHomePageBannerAd() {
    return BannerAd(adUnitId: _getAdMobAppId(), size: AdSize.smartBanner);
  }

  static void showHomeBannerAd() {
    if (_homeBannerAd == null) {
      _homeBannerAd = _getHomePageBannerAd();

      _homeBannerAd
        ..load()
        ..show(anchorType: AnchorType.bottom);
    }
  }
  */
/*
  static void hideHomeBannerAd() async {
    await _homeBannerAd.dispose();
    _homeBannerAd = null;
  }
  */
}
