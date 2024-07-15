import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/primary_button.dart'; // Import your PrimaryButton widget
import '../models/cart_item.dart';
import 'checkout_page.dart';

class MyCartPage extends StatelessWidget {
  final List<CartItem> cartItems;

  MyCartPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    // Calculate subtotal, delivery charge, and total based on cart items
    double subtotal = 0;
    cartItems.forEach((item) {
      // Remove non-numeric characters from productPrice before parsing
      String cleanedPrice = item.productPrice.replaceAll(RegExp(r'[^\d.]'), '');
      double price = double.parse(cleanedPrice);
      subtotal += price * item.quantity;
    });

    double deliveryCharge = 10.0; // Example delivery charge
    double discount = 5.0; // Example discount
    double total = subtotal + deliveryCharge - discount;

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Cart'),
          backgroundColor: AppColors.ultramarineBlue,
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cartItems[index].productName),
                      subtitle: Text(
                        'Buy a piece  P${cartItems[index].productPrice}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Text('Qty: ${cartItems[index].quantity}'),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'P${subtotal.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Charge',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'P${deliveryCharge.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discount',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '- P${discount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'P${total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              PrimaryButton(
                text: 'Place Order',
                onPressed: () {
                  // Navigate to CheckoutPage with necessary data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        cartItems: cartItems,
                        deliveryCharge: deliveryCharge,
                        totalAmount: total,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


