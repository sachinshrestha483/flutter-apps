//import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluterdemof/services/admob_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:admob_flutter/admob_flutter.dart';
import "package:firebase_admob/firebase_admob.dart";
//void main() => runApp(MyApp());

FirebaseAnalytics analytics;

void main() async {
  // analytics = FirebaseAnalytics();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdMs.getAdMobAppId());
  }

  final _auth = FirebaseAuth.instance;
// Banner
  BannerAd _bannerAd;

  // TODO: Implement _loadBannerAd()
  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(
        anchorType: AnchorType.top,
        anchorOffset: 100.0,
      );
  }

  //final admobservice = AdMobService();
//Interital Ad

  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady;

  void _loadInterstitialAd() {
    _interstitialAd.load(); // load
  }

  // TODO: Implement _onInterstitialAdEvent()
  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        setState(() {
          _isInterstitialAdReady = true;
        });
        _isInterstitialAdReady = true;
        _loadInterstitialAd();
        break;
      case MobileAdEvent.failedToLoad:
        setState(() {
          _isInterstitialAdReady = false;
        });
        _isInterstitialAdReady = false;
        _loadInterstitialAd();
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        break;
      default:
      // do nothing
    }
  }

//

// Reward Add

  bool _isRewardedAdReady;

  // TODO: Implement _loadRewardedAd()
  void _loadRewardedAd() {
    RewardedVideoAd.instance.load(
      targetingInfo: MobileAdTargetingInfo(),
      adUnitId: AdMs.getRewardAdId(),
    );
  }

  // TODO: Implement _onRewardedAdEvent()
  void _onRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          _isRewardedAdReady = true;
        });
        _loadRewardedAd();
        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          _isRewardedAdReady = false;
        });
        _loadRewardedAd();
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          _isRewardedAdReady = false;
        });
        print('Failed to load a rewarded ad');
        break;
      case RewardedVideoAdEvent.rewarded:
        break;
      default:
      // do nothing
    }
  }

  ///

  @override
  void initState() {
    //   AdMobService.showHomeBannerAd();

    super.initState();

    _bannerAd = BannerAd(
      adUnitId: AdMs.getBannerAdId(),
      size: AdSize.banner,
    );

    // TODO: Load a Banner Ad
    _loadBannerAd();

// Reward Ad

    _isRewardedAdReady = false;

    // TODO: Set Rewarded Ad event listener
    RewardedVideoAd.instance.listener = _onRewardedAdEvent;

    // TODO: Load a Rewarded Ad
    _loadRewardedAd();

// Intertial Ad

    _isInterstitialAdReady = false;

    // TODO: Initialize _interstitialAd
    _interstitialAd = InterstitialAd(
      adUnitId: AdMs.getInterCesticalAdId(),
      listener: _onInterstitialAdEvent,
    );

    _loadInterstitialAd();
  }

  @override
  void dispose() {
    // TODO: Dispose BannerAd object
    _bannerAd?.dispose();

    //super.dispose();

    _interstitialAd?.dispose();

    // super.dispose();

    RewardedVideoAd.instance.listener = null;

    super.dispose();
  }

  String email;
  String password;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Demo App'),
            backgroundColor: Colors.green[100],
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
// Ad Here

                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Enter a email'),
                    onChanged: (value) {
                      email = value;
                      print(value);
                    },
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Enter a Password'),
                    onChanged: (value) {
                      password = value;
                      print(value);
                    },
                  ),
                  MaterialButton(
                    onPressed: () async {
                      RewardedVideoAd.instance.show();
/*
                      try {
                        var newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          print('Created New User');
                        }
                      } catch (e) {
                        print(e);
                      }

                      print(email);
                      print(password);
                    
                    */
                    },
                    color: Colors.green[100],
                    child: Text('Submit'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      RewardedVideoAd.instance.show();
                    },
                    child: Text("Reward Ad "),
                    color: Colors.blueAccent,
                  ),
                  MaterialButton(
                    onPressed: () {
                      _loadInterstitialAd();

                      if (_isInterstitialAdReady) {
                        print("Showing the Ad");
                        _interstitialAd.show();
                      } else {
                        print("Hiding The Ad");
                        _interstitialAd.show();
                      }
                    },
                    child: Text("Intertial Ad"),
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ))),
    );
  }
}
