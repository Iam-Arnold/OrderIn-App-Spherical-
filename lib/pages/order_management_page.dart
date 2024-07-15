import 'package:flutter/material.dart';

class OrderManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      body: Center(
        child: Text(
          'Order management features for retailers',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
