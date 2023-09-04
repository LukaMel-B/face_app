import 'package:flutter/material.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Loading...',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
