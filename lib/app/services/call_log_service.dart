import 'package:flutter/services.dart';

import 'call_log_model.dart';

class CallLogService {
  static final _platform = MethodChannel('fake_call_log');

  static Future<List<CallLogModel>> getCallLogs() async {
    try {
      final List<dynamic> callLogs = await _platform.invokeMethod('queryCallLogs');
      return callLogs.map((log) => CallLogModel.fromMap(Map<String, dynamic>.from(log))).toList();
    } catch (e) {
      print("Error fetching call logs: $e");
      return [];
    }
  }

  static Future<bool> addCallLog({
    String? phoneNumber,
    String? contactName,
    required int callType,
    required int duration,
    required int timestamp,
  }) async {
    bool success = await _platform.invokeMethod('addFakeCallLog', {
      "number": phoneNumber, // Fake number
      "name": contactName,
      "type": callType, // Incoming (1), Outgoing (2), Missed (3)
      "duration": duration, // Call duration in seconds
      "timestamp": timestamp,
    });
    return success;
  }
}
