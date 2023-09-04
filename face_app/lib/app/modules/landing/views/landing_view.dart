import 'package:face_app/app/modules/landing/controllers/landing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Center(
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ]),
      body: const Center(
        child: Text(
          'LandingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
