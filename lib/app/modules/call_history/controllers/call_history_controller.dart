import 'dart:async';
import 'package:fake_call_log/app/services/call_log_model.dart';
import 'package:fake_call_log/app/services/call_log_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CallHistoryController extends GetxController {
  RxList<CallLogModel> callHistory = <CallLogModel>[].obs;
  StreamSubscription? _callLogStream;
  RxStatus rxStatus = RxStatus.empty();

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  void onClose() {
    _callLogStream?.cancel();
    super.onClose();
  }

  void _initialize() async {
    bool permissionGranted = await _requestCallLogPermission();
    if (permissionGranted) {
      fetchInitCallLog();
    } else {
      rxStatus = RxStatus.error("Call log permission denied!");
    }
  }

  Future<bool> _requestCallLogPermission() async {
    final statuses = await [Permission.phone, Permission.contacts].request();
    return statuses[Permission.phone] == PermissionStatus.granted &&
        statuses[Permission.contacts] == PermissionStatus.granted;
  }

  void fetchInitCallLog() async {
    try {
      rxStatus = RxStatus.loading();
      final callLogs = await CallLogService.getCallLogs();
      callHistory.assignAll(callLogs);
      _startCallLogStream();
      rxStatus = callHistory.isEmpty ? RxStatus.empty() : RxStatus.success();
    } catch (e) {
      rxStatus = RxStatus.error("Failed to fetch call logs: ${e.toString()}");
    }
  }

  void _startCallLogStream() {
    _callLogStream = Stream.periodic(const Duration(seconds: 5))
        .asyncMap((_) => fetchAllCallHistory())
        .listen((logs) => callHistory.assignAll(logs), onError: (error) => rxStatus = RxStatus.error(error.toString()));
  }

  Future<List<CallLogModel>> fetchAllCallHistory() async {
    try {
      return await CallLogService.getCallLogs();
    } catch (e) {
      rxStatus = RxStatus.error('Failed to fetch call logs: ${e.toString()}');
      return [];
    }
  }
}
