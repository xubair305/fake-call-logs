import 'package:get/get.dart';

import '../controllers/call_history_controller.dart';

class CallHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallHistoryController>(
      () => CallHistoryController(),
    );
  }
}
