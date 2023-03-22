import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/model/data_structures/singletons_data.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/monetization.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';
import 'package:flutter_lucid_bell/view/view.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Paywall extends StatefulWidget {
  final Offering offering;
  const Paywall({required this.offering, super.key});

  @override
  State<Paywall> createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    print(
        '${widget.offering.availablePackages.length} ===================== available');
    return SizedBox(
      child: SingleChildScrollView(
        child: SafeArea(
            child: Wrap(
          children: <Widget>[
            const Center(
              child: Text(
                'Circle Bell Premium',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 24),
              ),
            ),
            const Padding(
                padding:
                    EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
                child: SizedBox.shrink()
                ),
            SizedBox(
              height: SizeConfig.getMediaHeight(context) * 0.3,
              width: SizeConfig.getMediaWidth(context) * 1,
              child: ListView.builder(
                  itemCount: widget.offering.availablePackages.length,
                  itemBuilder: (BuildContext context, int index) {
                    var myProductList = widget.offering.availablePackages;
                    return Card(
                        color: View.currentTheme.storeTheme.tileColor,
                        child: ListTile(
                          onTap: () async {
                            try {
                              CustomerInfo customerInfo =
                                  await Purchases.purchasePackage(
                                      myProductList[index]);
                              appData.subscriptionIsActive = customerInfo
                                  .entitlements.all[entitlementId]!.isActive;
                              Subscription.checkSubscriptionAsync();
                              print('active');
                            } catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          },
                          title: Text(
                            myProductList[index].storeProduct.title,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18),
                          ),
                          subtitle: Text(
                            myProductList[index].storeProduct.description,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14),
                          ),
                          trailing: Text(
                            myProductList[index].storeProduct.priceString,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14),
                          ),
                        ),
                      
                    );
                  }),
            ),
            const Padding(
                padding:
                    EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
                child: Text(
                  footerText,
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
                )),
          ],
        )),
      ),
    );
  }
}


