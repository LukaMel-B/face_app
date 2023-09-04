// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'dart:async';
import 'dart:developer';
import 'package:face_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var storage = GetStorage();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Position? currentLocation;
  RxString geoLocation = 'Geolocation...'.obs;

  writeData({
    required String name,
    required String address,
    required String geoLocation,
  }) async {
    final box = await storage;
    box.write('isData', true);
    box.write(name, 'name');
    box.write(address, 'address');
    box.write(geoLocation, 'geolocation');
    Get.offAllNamed(Routes.LANDING);
  }

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    currentLocation = await Geolocator.getCurrentPosition();
    update();
  }

  getCurrentLocation(BuildContext context) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          currentLocation!.latitude, currentLocation!.longitude);
      Placemark place = placeMarks[0];
      geoLocation.value =
          '${place.locality}, ${place.postalCode}, ${place.country}';
      update();
    } catch (e) {
      log(e.toString());
      SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        content: Text(e.toString()),
        backgroundColor: const Color(0xff1E1E1E),
        duration: const Duration(seconds: 4),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

InputDecoration inputField(String hintText) {
  final textfieldDeco = InputDecoration(
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(55),
      borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: .8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(55),
      borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: .8),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(55),
      borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: .8),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(55),
      borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: .8),
    ),
    hintText: hintText,
    hintStyle: const TextStyle(
      fontSize: 13,
      fontFamily: 'Montserrat',
      color: Color(0xFF808080),
    ),
  );
  return textfieldDeco;
}

InputDecoration inputFieldAddress(String hintText) {
  final textfieldDeco = InputDecoration(
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: .8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: .8),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: .8),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(color: Color(0xFFFFFFFF), width: .8),
    ),
    hintText: hintText,
    hintStyle: const TextStyle(
      fontSize: 13,
      fontFamily: 'Montserrat',
      color: Color(0xFF808080),
    ),
  );
  return textfieldDeco;
}
