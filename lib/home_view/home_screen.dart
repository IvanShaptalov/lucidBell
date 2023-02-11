import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/home_view/switch_button.dart';
import 'package:flutter_lucid_bell/home_view/time_selector.dart';
import 'package:flutter_lucid_bell/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InitServices.bell.running
                ? TimeSelector(
                    bell: InitServices.bell,
                    callback: callback,
                  )
                : const SizedBox.shrink(),
            SwitchBell(bell: InitServices.bell, callback: callback)
          ],
        ),
      ),
    );
  }

  void callback() {
    setState(() {
      print('updated');
    });
  }
}
