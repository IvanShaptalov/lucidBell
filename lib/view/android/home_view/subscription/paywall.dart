import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' show AlertDialog, BorderRadius, BoxDecoration, BuildContext, Card, Center, Color, Colors, Container, EdgeInsets, ListTile, ListView, Padding, SafeArea, SingleChildScrollView, SizedBox, State, StatefulWidget, Text, TextStyle, Widget, Wrap, showDialog;
import 'package:flutter_lucid_bell/model/data_structures/app_data.dart' show appData;
import 'package:flutter_lucid_bell/presenter/android/monetization/monetization.dart' show Subscription, entitlementId, footerText;
import 'package:flutter_lucid_bell/view/config_view.dart' show SizeConfig;
import 'package:flutter_lucid_bell/view/view.dart' show View;
import 'package:purchases_flutter/purchases_flutter.dart' show CustomerInfo, Offering, Purchases;

class MockOffering {
  get availablePackages {
    return [
      const MockStoreProduct('description', 'title', '1 UAH'),
      const MockStoreProduct('description', 'title', '1 UAH'),
      const MockStoreProduct('description', 'title', '1 UAH')
    ];
  }
}

class MockStoreProduct {
  final String description;
  final String title;
  final String priceString;

  const MockStoreProduct(this.description, this.title, this.priceString);
}

class Paywall extends StatefulWidget {
  final Offering offering;
  // final MockOffering offering;
  const Paywall({required this.offering, super.key});

  @override
  State<Paywall> createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(
        '${widget.offering.availablePackages.length} ===================== available');
    }
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
                child: SizedBox.shrink()),
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
                          // if subscribed you can't subscribe again
                          if (await Subscription.premiumActivatedAsync()) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Container(
                                      height: SizeConfig.getMediaHeight(context) * 0.2,
                                      width: SizeConfig.getMediaWidth(context) * 0.8,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          gradient: View.currentTheme.appTheme
                                              .activeBellGradient),
                                      child: const AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          title: Text(
                                            'you already got premium',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16)),
                                          content: null),
                                    ),
                                  );
                                });
                          } else {
                            try {
                              CustomerInfo customerInfo =
                                  await Purchases.purchasePackage(
                                      myProductList[index]);
                              appData.subscriptionIsActive = customerInfo
                                  .entitlements.all[entitlementId]!.isActive;
                              Subscription.premiumActivatedAsync();
                              if (kDebugMode) {
                                print('active');
                              }
                            } catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          }
                          setState(() {});
                        },
                        title: Text(
                          // myProductList[index]/* .storeProduct */.title,  // mock
                          myProductList[index].storeProduct.title,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18),
                        ),
                        subtitle: Text(
                          // myProductList[index]/* .storeProduct */.description,  // mock
                          myProductList[index].storeProduct.description,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14),
                        ),
                        trailing: Text(
                          // myProductList[index]/* .storeProduct */.priceString,  //mock
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
