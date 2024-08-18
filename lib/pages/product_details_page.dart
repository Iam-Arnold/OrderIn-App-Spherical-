import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../components/primary_button.dart';
import '../pages/my_cart_page.dart'; 
import '../models/cart_item.dart';
import '../provider/theme_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName;
  final String productImage;
  final String productPrice;
  final String productDescription;

  ProductDetailsPage({
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        bool isDarkTheme = themeProvider.switchThemeIcon();
        
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.productName),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Handle cart action
                },
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
                      PrimaryButton(
                        text: 'Add to Cart',
                        onPressed: () {
                          // Simulate adding to cart (replace with actual logic)
                          List<CartItem> cartItems = [
                            CartItem(
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
