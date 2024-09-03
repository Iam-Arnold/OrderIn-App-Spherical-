import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../components/secondary_button.dart'; // Import the SecondaryButton
import '../components/primary_button.dart';
import '../pages/my_cart_page.dart'; 
import '../models/cart_item.dart';
import '../provider/theme_provider.dart';
import '../provider/cart_provider.dart'; // Import the CartProvider
import './order_tracking_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName;
  final String productId;
  final String productImage;
  final String productPrice;
  final String productDescription;

  ProductDetailsPage({
    required this.productId, 
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productDescription,
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, CartProvider>(
      builder: (context, themeProvider, cartProvider, child) {
        bool isDarkTheme = themeProvider.switchThemeIcon();

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.productName),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      // Access the cart provider
                      final cartProvider = Provider.of<CartProvider>(context, listen: false);

                      // Add product to cart
                      cartProvider.addItem(
                        CartItem(
                          productId: widget.productId,
                          productName: widget.productName,
                          productImage: widget.productImage,
                          productPrice: widget.productPrice,
                          quantity: quantity,
                        ),
                      );

                      // Navigate to the OrderTrackingPage with the cart expanded
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingPage(expandCart: true),
                        ),
                      );
                    },
                  ),
                  if (cartProvider.items.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 10.0,
                        backgroundColor: Colors.red,
                        child: Text(
                          cartProvider.items.length.toString(),
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.productImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? AppColors.darkBlue : AppColors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        widget.productPrice,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: isDarkTheme ? AppColors.grey : AppColors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        widget.productDescription,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isDarkTheme ? AppColors.grey : AppColors.white,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme ? AppColors.darkBlue : AppColors.white,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: isDarkTheme ? AppColors.darkBlue : AppColors.grey,
                                ),
                                onPressed: _decrementQuantity,
                              ),
                              Container(
                                width: 50,
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(
                                    text: quantity.toString(),
                                  ),
                                  style: TextStyle(
                                    color: isDarkTheme ? AppColors.darkBlue : AppColors.grey,
                                  ),
                                  onChanged: (value) {
                                    int newQuantity = int.tryParse(value) ?? 1;
                                    setState(() {
                                      quantity = newQuantity;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: isDarkTheme ? AppColors.darkBlue : AppColors.grey,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: isDarkTheme ? AppColors.darkBlue : AppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: isDarkTheme ? AppColors.darkBlue : AppColors.grey,
                                ),
                                onPressed: _incrementQuantity,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      SecondaryButton(
                        text: 'Add to Cart',
                        onPressed: () {
                          // Access the cart provider
                          final cartProvider = Provider.of<CartProvider>(context, listen: false);

                          // Add product to cart and check if it was successful
                          bool addedSuccessfully = cartProvider.addItem(
                                 CartItem(
                                  productId: widget.productId, // Pass the productId
                                  productName: widget.productName,
                                  productImage: widget.productImage,
                                  productPrice: widget.productPrice,
                                  quantity: quantity,
                                ),
                          );

                          if (!addedSuccessfully) {
                            // Show message if item is already in the cart
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Item already added to cart'),
                              ),
                            );
                          } else {
                            // Show confirmation if item was successfully added
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${widget.productName} added to cart'),
                              ),
                            );
                          }
                        },
                        gradientColors: [Colors.deepOrange, Colors.yellow], // Deep yellow-orange gradient
                      ),
                      SizedBox(height: 16.0),
                      PrimaryButton(
                        text: 'Continue',
                       onPressed: () {
                          // Simulate adding to cart (replace with actual logic)
                          List<CartItem> cartItems = [
                            CartItem(
                              productId: widget.productId,
                              productName: widget.productName,
                              productImage: widget.productImage,
                              productPrice: widget.productPrice,
                              quantity: quantity,
                            ),
                          ];

                          // Navigate to cart page with cart items
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyCartPage(
                                cartItems: cartItems,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
