import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added provider import
import '../utils/colors.dart';
import '../components/primary_button.dart'; 
import '../models/cart_item.dart';
import 'checkout_page.dart';
import '../provider/theme_provider.dart'; // Import the theme provider

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

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        bool isDarkTheme = themeProvider.switchThemeIcon();

        return WillPopScope(
          onWillPop: () async {
            // Handle back button press
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('My Cart'),
            ),
            body: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                            cartItems[index].productImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            cartItems[index].productName,
                            style: TextStyle(
                              color: isDarkTheme ? AppColors.darkBlue : AppColors.grey,
                            ),
                          ),
                          subtitle: Text(
                            'Buy a piece @  TZS${cartItems[index].productPrice}',
                            style: TextStyle(
                              color: isDarkTheme ? AppColors.grey : AppColors.white,
                            ),
                          ),
                          trailing: Text(
                            'Qty: ${cartItems[index].quantity}',
                            style: TextStyle(
                              color: isDarkTheme ? AppColors.darkBlue : AppColors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Display product image above the subtotal and make it fill the available space
                  Expanded(
                    flex: 2,
                    child: Image.network(
                      cartItems.isNotEmpty ? cartItems[0].productImage : '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isDarkTheme ? AppColors.darkBlue : AppColors.white,
                        ),
                      ),
                      Text(
                        'TZS${subtotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isDarkTheme ? AppColors.darkBlue : AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Charge',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isDarkTheme ? AppColors.darkBlue : AppColors.white,
                        ),
                      ),
                      Text(
                        'P${deliveryCharge.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isDarkTheme ? AppColors.darkBlue : AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isDarkTheme ? AppColors.darkBlue : AppColors.white,
                        ),
                      ),
                      Text(
                        '- P${discount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isDarkTheme ? AppColors.darkBlue : AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? AppColors.darkBlue : AppColors.white,
                        ),
                      ),
                      Text(
                        'TZS${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? AppColors.darkBlue : AppColors.white,
                        ),
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
      },
    );
  }
}
