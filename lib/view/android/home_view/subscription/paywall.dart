import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/model/singletons_data.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/constant.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/subscription.dart';
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
            Container(
              decoration: BoxDecoration(
                  color:
                      View.currentTheme.appTheme.activeBottomNavigationBarColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25.0))),
              child: Center(
                child: Text(
                  'Circle Bell Premium',
                  style: View.currentTheme.bellInfoTheme.textLeftSecondStyle,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    top: 32, bottom: 16, left: 16, right: 16),
                child: Text('CIRCLE BELL PREMIUM',
                    style:
                        View.currentTheme.bellInfoTheme.textLeftSecondStyle)),
            SizedBox(
              height: SizeConfig.getMediaHeight(context) * 0.8,
              width: SizeConfig.getMediaWidth(context) * 0.8,

              child: ListView.builder(
                  itemCount: widget.offering.availablePackages.length,
                  itemBuilder: (BuildContext context, int index) {
                    var myProductList = widget.offering.availablePackages;
                    return Card(
                      color: Colors.black,
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
                          style:
                              View.currentTheme.bellInfoTheme.textLeftSecondStyle,
                        ),
                        subtitle: Text(
                          myProductList[index].storeProduct.description,
                          style: View
                              .currentTheme.bellInfoTheme.textLeftSecondStyle
                              .copyWith(fontSize: 14),
                        ),
                        trailing: Text(
                          myProductList[index].storeProduct.priceString,
                          style:
                              View.currentTheme.bellInfoTheme.textLeftSecondStyle,
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    top: 32, bottom: 16, left: 16, right: 16),
                child: Text(footerText,
                    style:
                        View.currentTheme.bellInfoTheme.textLeftSecondStyle)),
          ],
        )),
      ),
    );
  }
}
