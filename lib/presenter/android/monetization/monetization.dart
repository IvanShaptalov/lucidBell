import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_lucid_bell/model/data_structures/singletons_data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucid_bell/view/android/home_view/subscription/paywall.dart';
import 'package:flutter_lucid_bell/view/view.dart';

/// ===========================================[Subscription]=======================================
const entitlementId = 'premium';

const footerText = "premium access to all circle bell features";

const googleApiKey = 'goog_oQDYaSqLtKfNSzSoUdVdHQModcQ';

enum Store { appleStore, googlePlay }

class StoreConfig {
  final Store store;
  final String apiKey;
  static StoreConfig? _instance;

  factory StoreConfig({required Store store, required String apiKey}) {
    _instance ??= StoreConfig._internal(store, apiKey);

    return _instance!;
  }

  StoreConfig._internal(this.store, this.apiKey);

  static StoreConfig get instance {
    return _instance!;
  }

  static bool isForAppleStore() => _instance!.store == Store.appleStore;
  static bool isForGooglePlay() => _instance!.store == Store.googlePlay;

  static Future<bool> initStoreAsync() async {
    // if (Platform.isIOS || Platform.isMacOS) {
    //   StoreConfig(store: Store.appleStore, apiKey: appleApiKey);
    //   return;
    // }
    if (Platform.isAndroid) {
      StoreConfig(store: Store.googlePlay, apiKey: googleApiKey);
      var configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);
      await Purchases.configure(configuration);
      await Subscription.checkSubscriptionAsync();
      return true;
    }
    throw UnsupportedError('unsupported platform');
  }
}

class Subscription {
  static Future<bool> offerConditionAsync() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    if (customerInfo.entitlements.all[entitlementId] != null &&
        customerInfo.entitlements.all[entitlementId]!.isActive == true) {
      return true;
    }

    return false;
  }

  static Future<void> checkSubscriptionAsync() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    bool entitlementActive = customerInfo.entitlements.active.isNotEmpty;
    if (kDebugMode)
      print('entitlement active: $entitlementActive =======================');
    appData.subscriptionIsActive = entitlementActive;
  }

  static Future<void> showStore(context) async {
    if (!await Subscription.offerConditionAsync()) {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        // ignore: use_build_context_synchronously
        await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text("Error"),
                  content: Text(e.message.toString()),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'))
                  ],
                ));
      }
      if (offerings == null || offerings.current == null) {
        if (kDebugMode) print('offering null or current offer null');
      } else {
        // ignore: use_build_context_synchronously
        showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            backgroundColor:
                View.currentTheme.storeTheme.bottomSheetBackgroundColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (BuildContext context, setState) {
                return Paywall(offering: offerings!.current!);
              });
            });
      }
    }
  }
}

/// =======================================================[ADS]=====================================
class AdHelper {
  static InitializationStatus? status;
  static Duration loadTimeout = const Duration(seconds: 10);

  static bool get showAds {
    // if not active - show ads, else not show
    return !(appData.subscriptionIsActive);
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-4618505570484622/7719749288";
      return "ca-app-pub-3940256099942544/5224354917"; // test ad
    } /* else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } */
    else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-4618505570484622/9034746675";
      return "ca-app-pub-3940256099942544/6300978111"; // test ad
    } /* else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } */
    else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static Future<InitializationStatus> initAsync() async {
    status = await MobileAds.instance.initialize();
    return await MobileAds.instance.initialize();
  }
}
