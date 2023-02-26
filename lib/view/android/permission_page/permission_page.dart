import 'package:flutter/material.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Icon(Icons.emoji_emotions),
          // ListView(
          //   children: const [],
          // ),
        ],
      )),
      backgroundColor: Colors.transparent,
    );
  }
}
