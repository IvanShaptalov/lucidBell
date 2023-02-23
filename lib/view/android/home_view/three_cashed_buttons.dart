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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BellPresenter.callbacksTrigger.add(update);
  }

  void update() => setState(() {
        print('update buttons');
      });

  @override
  Widget build(BuildContext context) {
    print('buttons ***');

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
                  BellPresenter.updateCallbacks();
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
                  BellPresenter.updateCallbacks();
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
                  BellPresenter.updateCallbacks();
                });
              },
              child: Text(
                  '${BellPresenter.bell!.getThreeCashedIntervals.getByIndex(2).inMinutes} min.')),
        ],
      ),
    );
  }
}
