import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/welcome_screen/features.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

class WelcomeScreen extends StatefulWidget {
  final Function updateCallback;
  const WelcomeScreen(this.updateCallback, {super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  List<Widget> indicator() => List<Widget>.generate(
      items.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: currentPage.round() == index
                    ? const Color(0XFF256075)
                    : const Color(0XFF256075).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));

  double currentPage = 0.0;
  final _pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    _pageViewController.addListener(() {
      setState(() {
        currentPage = _pageViewController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> slides = items
        .map((item) => Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getMediaHeight(context) * 0.05), //10%
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Image.asset(
                    item['image'],
                    fit: BoxFit.fitWidth,
                    width: SizeConfig.getMediaWidth(context) * 0.8, //80%
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            SizeConfig.getMediaWidth(context) * 0.07), //14%
                    child: Column(
                      children: <Widget>[
                        Text(
                          item['header'],
                          style: const TextStyle(
                            fontSize: 35.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          item['description'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )))
        .toList();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            top: SizeConfig.getMediaHeight(context) * 0.1), // 10%
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageViewController,
              itemCount: slides.length,
              itemBuilder: (BuildContext context, int index) {
                return slides[index];
              },
            ),

            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.getMediaHeight(context) * 0.1), //10%
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.getMediaHeight(context) * 0.02), //4%
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {});
                            BellPresenter.setFeaturesPage(false);

                            // skip tutorial or end
                            widget.updateCallback();
                          },
                          child: currentPage == 0 || currentPage == items.length-1
                              ? Text(currentPage == items.length - 1
                                  ? 'go to Circle Bell'
                                  : 'skip tutorial', style: const TextStyle(fontSize: 15),)
                              : const SizedBox.shrink()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: indicator(),
                      ),
                    ],
                  ),
                )
                //  ),
                )
            // )
          ],
        ),
      ),
    );
  }
}
