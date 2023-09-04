import 'package:face_app/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreenController extends GetxController {
  var storage = GetStorage();
  @override
  void onInit() async {
    await Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      if (storage.read('isData').toString() == 'true') {
        Get.toNamed(Routes.LANDING);
      } else {
        Get.toNamed(Routes.HOME);
      }
    });
    super.onInit();
  }
}
