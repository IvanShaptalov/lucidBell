import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/theme/view.dart';

class CashedButtons extends StatefulWidget {
  const CashedButtons({super.key});

  @override
  State<CashedButtons> createState() => _CashedButtonsState();
}

class _CashedButtonsState extends State<CashedButtons> {
  // StreamSubscription? sub;

  // @override
  // void dispose() async {
  //   super.dispose();
  //   if (sub != null) {
  //     await sub!.cancel();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // sub = View.bellDurationListener(BellPresenter.bell!.innerInterval)
    //     .listen((event) async {
    //   await Future.delayed(Duration(seconds: 1));

    //   setState(() {
    //     print('update all');
    //   });
    // });

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () async {
                setState(() {
                  BellPresenter.bell!.setInterval(BellPresenter
                      .bell!.getThreeCashedIntervals
                      .getByIndex(0));
                });
              },
              child: Text(
                  '${BellPresenter.bell!.getThreeCashedIntervals.getByIndex(0).inMinutes} min.')),
          TextButton(
              onPressed: () async {
                setState(() {
                  BellPresenter.bell!.setInterval(BellPresenter
                      .bell!.getThreeCashedIntervals
                      .getByIndex(1));
                });
              },
              child: Text(
                  '${BellPresenter.bell!.getThreeCashedIntervals.getByIndex(1).inMinutes} min.')),
          TextButton(
              onPressed: () async {
                setState(() {
                  BellPresenter.bell!.setInterval(BellPresenter
                      .bell!.getThreeCashedIntervals
                      .getByIndex(2));
                });
              },
              child: Text(
                  '${BellPresenter.bell!.getThreeCashedIntervals.getByIndex(2).inMinutes} min.')),
        ],
      ),
    );
  }
}
