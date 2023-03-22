import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucid_bell/model/singletons_data.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/constant.dart';
import 'package:flutter_lucid_bell/view/android/home_view/subscription/paywall.dart';
import 'package:flutter_lucid_bell/view/view.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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
    if (kDebugMode) print('entitlement active: $entitlementActive =======================');
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
