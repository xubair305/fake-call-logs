import 'package:call_e_log/call_log.dart';
import 'package:fake_call_log/app/helper/app_datetime_formatter.dart';
import 'package:fake_call_log/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

import '../controllers/call_history_controller.dart';

class CallHistoryView extends GetView<CallHistoryController> {
  const CallHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone', style: TextStyle(color: context.theme.primaryColor, fontWeight: FontWeight.w700)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.HOME);
        },
        foregroundColor: context.theme.primaryColor,
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.callHistory.isEmpty) {
          return const Center(child: Text("No call history found!"));
        }

        if (controller.rxStatus.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.rxStatus.isError) {
          return Center(child: Text(controller.rxStatus.errorMessage ?? '', style: const TextStyle(color: Colors.red)));
        }

        if (controller.callHistory.isEmpty) {
          return const Center(child: Text("No call history found!"));
        }

        return GroupedListView<CallLogEntry, DateTime>(
          elements: controller.callHistory.toList(),
          groupBy: (element) => AppDatetimeFormatter.dateTimeFromInt(element.timestamp),
          groupSeparatorBuilder:
              (groupByValue) => Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Text(
                  AppDatetimeFormatter.formatDateTime(groupByValue),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

          useStickyGroupSeparators: false,
          floatingHeader: true,
          groupItemBuilder: (context, element, groupStart, groupEnd) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(groupEnd ? 16 : 0),
                  top: Radius.circular(groupStart ? 16 : 0),
                ),
                color: Colors.white,
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                title: Text(element.name ?? 'Unknown'),
                subtitle: Text(element.number ?? ''),
                leading: getCallIcon(element.callType),
                trailing: Text(AppDatetimeFormatter.formatIntoAmPm(element.timestamp)),
              ),
            );
          },
          order: GroupedListOrder.DESC,
        );
      }),
    );
  }

  Widget getCallIcon(CallType? type) {
    switch (type) {
      case CallType.incoming:
        return Icon(Icons.call_received);
      case CallType.outgoing:
        return Icon(Icons.call_made);
      case CallType.missed:
        return Icon(Icons.call_missed, color: Colors.red);
      case CallType.rejected:
        return Icon(Icons.block);
      default:
        return Icon(Icons.call);
    }
  }
}
