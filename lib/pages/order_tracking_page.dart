import 'package:flutter/material.dart';
import '../components/top_navbar.dart'; // Import the custom app bar
import '../components/bottom_nav.dart';

class OrderTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Track Orders',
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildOrderTile(context, 'Order #1234', 'Shipped', DateTime.now().subtract(Duration(days: 1)), Colors.green),
          _buildOrderTile(context, 'Order #5678', 'Processing', DateTime.now().subtract(Duration(days: 3)), Colors.orange),
          _buildOrderTile(context, 'Order #9101', 'Delivered', DateTime.now().subtract(Duration(days: 7)), Colors.blue),
          // Add more list tiles for other orders
        ],
      ),
      //bottomNavigationBar: BottomNavigation(), 
    );
  }

  Widget _buildOrderTile(BuildContext context, String orderNumber, String status, DateTime date, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: statusColor),
        title: Text(orderNumber, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: $status', style: TextStyle(color: statusColor)),
            SizedBox(height: 4.0),
            Text('Date: ${date.toLocal()}'.split(' ')[0]),
          ],
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to order details page
        },
      ),
    );
  }
}
