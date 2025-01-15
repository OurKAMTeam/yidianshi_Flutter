import 'package:get/get.dart';
import 'package:yidianshi/widget/home/info_widget/controller/experiment_controller.dart';
import 'package:yidianshi/model/xidian_ids/experiment.dart';

class ExperimentPageController extends GetxController {
  final ExperimentController _experimentController = Get.find<ExperimentController>();
  
  var status = ExperimentStatus.fetched.obs;
  DateTime now = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    status.value = _experimentController.status;
    _experimentController.addListener(() {
      status.value = _experimentController.status;
    });
  }

  List<ExperimentData> getDoing() {
    return _experimentController.doing(now);
  }

  List<ExperimentData> getUnDone() {
    return _experimentController.isNotFinished(now);
  }

  List<ExperimentData> getDone() {
    return _experimentController.isFinished(now);
  }

  int get sum => _experimentController.sum;

  String get error => _experimentController.error;

  void reload() {
    _experimentController.get();
  }
}
