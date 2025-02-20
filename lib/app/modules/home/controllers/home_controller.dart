import 'dart:developer' show log;

import 'package:fake_call_log/app/services/call_log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  String contactName = '';
  int callType = 1; // 1 = Incoming, 2 = Outgoing, 3 = Missed
  int callDurationHours = 0;
  int callDurationMinutes = 0;
  int callDurationSeconds = 0;
  DateTime selectedDateTime = DateTime.now();

  @override
  void onInit() {
    _requestCallLogPermission();
    super.onInit();
  }

  // final _platform = MethodChannel('fake_call_log');

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  submitAddFakeCallLog() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      formKey.currentState!.save();
      return;
    } else {
      _addFakeCallLog();
    }
    formKey.currentState?.save();
  }

  Future<void> _addFakeCallLog() async {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);

    int durationInSeconds = (callDurationHours * 60 * 60) + (callDurationMinutes * 60) + callDurationSeconds;

    print("""
    Contact Name: $contactName
    Phone Number: ${phoneController.text}
    Call Type: ${callType == 1
        ? 'Incoming'
        : callType == 2
        ? 'Outgoing'
        : 'Missed'}
    Duration: $callDurationMinutes min $callDurationSeconds sec
    Date & Time: $formattedDate
    """);

    try {
      final success = await CallLogService.addCallLog(
        phoneNumber: phoneController.text,
        contactName: contactName,
        callType: callType,
        duration: durationInSeconds,
        timestamp: selectedDateTime.millisecondsSinceEpoch,
      );

      if (success) {
        Get.snackbar('Success', 'Fake Call Log Added', snackPosition: SnackPosition.BOTTOM);
        clearAllfields();
      } else {
        print("Failed to add fake call log.");
      }
    } on PlatformException catch (e) {
      print("Error: '${e.message}'.");
    }
  }

  Future<bool> _requestCallLogPermission() async {
    final statuses = await [Permission.phone, Permission.contacts].request();
    return statuses[Permission.phone] == PermissionStatus.granted &&
        statuses[Permission.contacts] == PermissionStatus.granted;
  }

  void getContactList() async {
    final contacts = await FlutterContacts.openExternalPick();
    log(contacts.toString());
  }

  Future<void> pickContact() async {
    Contact? contact = await FlutterContacts.openExternalPick();
    if (contact != null) {
      contactName = contact.displayName;
      phoneController.text = contact.phones.isNotEmpty ? contact.phones.first.number : '';
    }
  }

  /// Pick Date & Time
  Future<void> pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context.mounted ? context : Get.context!,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (pickedTime != null) {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  void clearAllfields() {
    phoneController.clear();
    callDurationSeconds = 0;
    callDurationSeconds = 0;
    contactName = '';
  }
}
