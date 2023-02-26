import 'package:flutter/material.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('permission page'),
      backgroundColor: Colors.transparent,
    );
  }
}
