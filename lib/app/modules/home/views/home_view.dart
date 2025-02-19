import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add History")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.contactName),
              SizedBox(height: 12),
              // Phone Number Input
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(labelText: "Phone Number", border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(width: 12),
                  IconButton(onPressed: controller.pickContact, icon: Icon(Icons.perm_contact_calendar)),
                ],
              ),
              SizedBox(height: 12),

              // Call Type Dropdown
              DropdownButtonFormField<int>(
                value: controller.callType,
                onChanged: (value) {
                  controller.callType = value!;
                },
                items: [
                  DropdownMenuItem(
                    value: 1,
                    child: Row(children: [Icon(Icons.call_received), SizedBox(width: 8), Text("Incoming Call")]),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Row(children: [Icon(Icons.call_made), SizedBox(width: 8), Text("Outgoing Call")]),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Row(children: [Icon(Icons.call_missed), SizedBox(width: 8), Text("Missed Call")]),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Row(children: [Icon(Icons.block), SizedBox(width: 8), Text("Rejected Call")]),
                  ),
                ],
                decoration: InputDecoration(labelText: "Call Type", border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),

              // Call Duration Picker
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Hours", border: OutlineInputBorder()),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter the hours';
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        controller.callDurationHours = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Minutes", border: OutlineInputBorder()),
                      onChanged: (value) {
                        controller.callDurationMinutes = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Seconds", border: OutlineInputBorder()),
                      onChanged: (value) {
                        controller.callDurationSeconds = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Date & Time Picker
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month),
                    TextButton(
                      onPressed: () => controller.pickDateTime(context),
                      child: Text(DateFormat('dd/MM/yyyy hh:mm a').format(controller.selectedDateTime)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Add Call Log Button
              ElevatedButton(
                onPressed: controller.submitAddFakeCallLog,
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
                child: Text("Add Log"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
