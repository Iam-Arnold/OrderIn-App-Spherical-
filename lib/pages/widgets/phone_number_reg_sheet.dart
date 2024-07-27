import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberBottomSheet extends StatelessWidget {
  final TextEditingController controller;

  PhoneNumberBottomSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntlPhoneField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            initialCountryCode: 'US',
            onChanged: (phone) {
              controller.text = phone.completeNumber;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }
}
