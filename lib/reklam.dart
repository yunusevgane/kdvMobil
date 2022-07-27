import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

/// This example demonstrates anchored adaptive banner ads.
class BannerReklam extends StatefulWidget {
  @override
  _BannerReklamState createState() => _BannerReklamState();
}

class _BannerReklamState extends State<BannerReklam> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-9410328109595500/5335807686'
          : 'ca-app-pub-9410328109595500/5335807686',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              if (_anchoredAdaptiveAd != null && _isLoaded)
                Container(
                  color: Colors.white,
                  width: _anchoredAdaptiveAd!.size.width.toDouble(),
                  height: _anchoredAdaptiveAd!.size.height.toDouble(),
                  child: AdWidget(ad: _anchoredAdaptiveAd!),
                )
            ],
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }
}
