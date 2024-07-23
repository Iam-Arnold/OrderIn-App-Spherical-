import 'package:flutter/material.dart';
import '../components/top_navbar.dart'; // Import the custom app bar
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import '../utils/colors.dart';

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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Card(
      color: themeProvider.switchThemeIcon() ? AppColors.white : AppColors.darkBlue,    
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: statusColor),
        title: Text(orderNumber, style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 247, 36, 36))),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: $status', style: TextStyle(color: statusColor)),
            SizedBox(height: 4.0),
            Text('Date: ${date.toLocal()}'.split(' ')[0], style: TextStyle(color: themeProvider.switchThemeIcon() ? AppColors.darkBlue.withOpacity(0.7) : AppColors.white.withOpacity(0.5))),
          ],
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to order details page
        },
      ),
    );
      }
    );  
  }
}
