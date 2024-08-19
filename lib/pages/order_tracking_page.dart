import 'package:flutter/material.dart';
import '../components/top_navbar.dart'; // Import the custom app bar
import '../provider/theme_provider.dart';
import '../utils/colors.dart';
import '../models/cart_item.dart';
import '../provider/cart_provider.dart'; // Import CartProvider
import 'package:provider/provider.dart';
import '../pages/widgets/animated_cartItem.dart'; // Import the AnimatedCartItem

class OrderTrackingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Track Orders',
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
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
          // Display cart items with animation
          ...cartProvider.items.map((item) => AnimatedCartItem(cartItem: item)).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderTile(BuildContext context, String orderNumber, String status, DateTime date, Color statusColor) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.ultramarineBlue, statusColor],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(Icons.check_circle_outline, color: statusColor, size: 32),
            title: Text(
              orderNumber,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: $status', style: TextStyle(color: statusColor, fontSize: 16)),
                SizedBox(height: 4.0),
                Text('Date: ${date.toLocal()}', style: TextStyle(color: AppColors.white.withOpacity(0.7))),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: () {
              // Navigate to order details page
            },
          ),
        );
      },
    );
  }
}
