import 'dart:async';

import 'package:call_e_log/call_log.dart';
import 'package:get/get.dart';

class CallHistoryController extends GetxController {
  RxList<CallLogEntry> callHistory = <CallLogEntry>[].obs;
  StreamSubscription? _callLogStream;

  RxStatus rxStatus = RxStatus.empty();

  @override
  void onInit() {
    fetchInitCallLog();
    super.onInit();
  }

  @override
  void onClose() {
    _callLogStream?.cancel();
    super.onClose();
  }

  void fetchInitCallLog() async {
    try {
      rxStatus = RxStatus.loading();
      final callLogs = await CallLog.get();
      callHistory.assignAll(callLogs.toList());
      _startCallLogStream();
      rxStatus = RxStatus.success();
    } catch (e) {
      rxStatus = RxStatus.error("Failed to fetch call logs!");
    }

    await CallLog.get().then((callLogs) {
      callHistory.value = callLogs.toList();
      _startCallLogStream();
    });
  }

  void _startCallLogStream() {
    _callLogStream = Stream.periodic(const Duration(seconds: 5))
        .asyncMap((_) => fetchAllCallHistory())
        .listen(
          (logs) {
            callHistory.assignAll(logs);
          },
          onError: (error) {
            rxStatus = RxStatus.error(error);
          },
        );
  }

  Future<List<CallLogEntry>> fetchAllCallHistory() async {
    try {
      final logs = await CallLog.get();
      return logs.toList();
    } catch (e) {
      rxStatus = RxStatus.error('Failed to fetch call logs!');
      return [];
    }
  }
}
