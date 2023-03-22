import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_lucid_bell/model/singletons_data.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/constant.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/subscription.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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
