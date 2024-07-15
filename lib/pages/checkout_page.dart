import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../models/cart_item.dart'; // Import your CartItem model
import '../components/primary_button.dart'; // Import your PrimaryButton widget
import '../components/payment_info_modal.dart'; // Import the PaymentInfoModal

class CheckoutPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final double deliveryCharge;
  final double totalAmount;

  const CheckoutPage({
    required this.cartItems,
    required this.deliveryCharge,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Theme.of(context).primaryColor, // Use theme primary color
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Options
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
            ),
            buildPaymentOption(context, icon: Icon(Icons.monetization_on, size: 28, color: AppColors.darkBlue), text: 'Tigo Pesa'),
            buildPaymentOption(context, icon: Icon(Icons.phone_android, size: 28, color: AppColors.darkBlue), text: 'M-Pesa'),
            buildPaymentOption(context, icon: Icon(Icons.account_balance, size: 28, color: AppColors.darkBlue), text: 'Bank Account'),
            SizedBox(height: 16.0),
            // Order Summary
            Divider(thickness: 1.0),
            SizedBox(height: 16.0),
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            buildOrderSummaryItem(text: 'Subtotal', price: calculateSubtotal(cartItems), context: context),
            buildOrderSummaryItem(text: 'Delivery Charge', price: deliveryCharge, context: context),
            buildOrderSummaryItem(text: 'Discount', price: -5.0, context: context), // Replace with your actual discount
            Divider(thickness: 1.0),
            buildOrderSummaryItem(text: 'Total', price: totalAmount, isBold: true, context: context),
            // Order Now Button
            SizedBox(height: 16.0),
            PrimaryButton(
              text: 'Order Now',
              onPressed: () {
                // Handle order placement based on chosen payment method (integration with payment gateways required)
                // Show success or error message based on payment outcome
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build payment option UI
  Widget buildPaymentOption(BuildContext context, {required Icon icon, required String text}) {
    return InkWell(
      onTap: () {
        // Show payment info modal
        showDialog(
          context: context,
          builder: (BuildContext context) => PaymentInfoModal(paymentMethod: text),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            SizedBox(width: 16.0), // Left padding for space
            icon,
            SizedBox(width: 16.0), // Space between icon and text
            Text(
              text,
              style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
            Spacer(), // Expands to push icon and text to the left
            Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.bodyMedium!.color), // Indicator icon
            SizedBox(width: 16.0), // Right padding for space
          ],
        ),
      ),
    );
  }

  // Helper function to build order summary item UI
  Widget buildOrderSummaryItem({required String text, required double price, bool isBold = false, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0), // Adjust horizontal padding for alignment
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
          Text(
            'P${price.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Helper function to calculate subtotal
  double calculateSubtotal(List<CartItem> items) {
    double subtotal = 0;
    items.forEach((item) {
      String cleanedPrice = item.productPrice.replaceAll(RegExp(r'[^\d.]'), '');
      double price = double.parse(cleanedPrice);
      subtotal += price * item.quantity;
    });
    return subtotal;
  }
}
