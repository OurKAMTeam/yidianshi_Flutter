import 'package:get/get.dart';

//import '../shared/services/services.dart';
import 'shared/service/service.dart';

class DenpendencyInjection {
  static Future<void> init() async {
    await Get.putAsync(() => StorageService().init());
  }
}