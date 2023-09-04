// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:face_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
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
                  'Register',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Registration Form',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat Bold',
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 55,
              ),
              textFieldSet(
                title: 'Name:',
                required: 'Name',
                hintText: 'Enter you name...',
                type: TextInputType.name,
                controller: controller.nameController,
              ),
              textFieldSet(
                title: 'Address:',
                required: 'Address',
                hintText: 'Enter you address...',
                type: TextInputType.multiline,
                maxLines: 3,
                controller: controller.addressController,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  controller.geoLocation.value = 'Searching...';
                  await controller.determinePosition();
                  await controller.getCurrentLocation(context);
                  log(controller.geoLocation.value);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors
                              .white, // Set your desired background color here
                          borderRadius: BorderRadius.circular(55),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x1F7E7E7E),
                                offset: Offset(10, 10),
                                blurRadius: 25.0,
                                spreadRadius: 5),
                          ],
                        ),
                        child: Obx(() {
                          return Text(
                            controller.geoLocation.value,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat SemiBold',
                              fontSize: 14,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.teal[200],
                      radius: 25,
                      child: ElevatedButton(
                          onPressed: () async {
                            controller.geoLocation.value = 'Searching...';
                            await controller.determinePosition();
                            await controller.getCurrentLocation(context);
                            log(controller.geoLocation.value);
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: Colors.transparent,
                          ),
                          child: Obx(() {
                            return (controller.geoLocation.value ==
                                    'Searching...')
                                ? Transform.scale(
                                    scale: 0.6,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1.7,
                                    ),
                                  )
                                : const Icon(
                                    FontAwesomeIcons.magnifyingGlass,
                                    size: 20,
                                  );
                          })),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (controller.formKey.currentState!.validate()) {
                      if (controller.geoLocation.value == 'Geolocation...' ||
                          controller.geoLocation.value == 'Searching...') {
                        SnackBar snackBar = const SnackBar(
                          behavior: SnackBarBehavior.fixed,
                          content: Text('Geo Location is required'),
                          backgroundColor: Color(0xff1E1E1E),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        final name = controller.nameController.text.trim();
                        final address =
                            controller.addressController.text.trim();
                        final geoLocation = controller.geoLocation.value;
                        await controller.writeData(
                          name: name,
                          address: address,
                          geoLocation: geoLocation,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 60),
                    elevation: 7,
                    shape: const StadiumBorder(),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.teal[200],
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Montserrat Bold',
                        color: Colors.white),
                  )),
            ],
          ),
        ));
  }

  Column textFieldSet(
      {required String title,
      required String required,
      required String hintText,
      required TextInputType type,
      required TextEditingController controller,
      int? maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat SemiBold',
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Set your desired background color here
            borderRadius: (maxLines != null)
                ? BorderRadius.circular(25)
                : BorderRadius.circular(55),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1F7E7E7E),
                  offset: Offset(10, 10),
                  blurRadius: 25.0,
                  spreadRadius: 5),
            ],
          ),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enableInteractiveSelection: true,
            controller: controller,
            validator: ((value) {
              if (value!.isEmpty) {
                return "$required is required!";
              } else {
                return null;
              }
            }),
            maxLines: maxLines,
            decoration: (maxLines != null)
                ? inputFieldAddress(hintText)
                : inputField(hintText),
            keyboardType: type,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
