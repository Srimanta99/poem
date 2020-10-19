import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';

class ShowAdd{
 static  bool isAdclose=true;
 static InterstitialAd add;
 static  const oneSec = const Duration(seconds: 25);
  static void showalnstatialAdd(BuildContext context) async{
    isAdclose=false;
    if(add==null){
      createInterstitialAd()..load()..show();
    }
      else {
        add
//      createInterstitialAd()
//        ..load()
        ..show();

    }
  }

  static const MobileAdTargetingInfo _mobileAdTargetingInfo=MobileAdTargetingInfo(
      testDevices: <String>[],
      keywords: <String>['Book','game'],
      nonPersonalizedAds: true
  );

 static InterstitialAd createInterstitialAd() {
     isAdclose=false;
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        //Change Interstitial AdUnitId with Admob ID
        targetingInfo: _mobileAdTargetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
          if(event== MobileAdEvent.closed){
            isAdclose=true;
            createInterstitialLoadAd();
          }
        });
  }


 static  createInterstitialLoadAd() {
   isAdclose=true;
   if(add==null) {
      add = InterstitialAd(
         adUnitId: InterstitialAd.testAdUnitId,
         //Change Interstitial AdUnitId with Admob ID
         targetingInfo: _mobileAdTargetingInfo,
         listener: (MobileAdEvent event) {
           print("IntersttialAd $event");
           if (event == MobileAdEvent.closed) {
             isAdclose = true ;
             add=null;
             createInterstitialLoadAd();
           }
         });
      add.load();
   }

 }


}
