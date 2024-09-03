import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../provider/cart_provider.dart'; // Import CartProvider
import '../provider/theme_provider.dart';
import '../pages/widgets/animated_cartItem.dart'; // Import the AnimatedCartItem

class OrderTrackingPage extends StatefulWidget {
  final bool expandCart;

  OrderTrackingPage({this.expandCart = false});

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  bool _isCartExpanded = false;

  @override
  void initState() {
    super.initState();
    _isCartExpanded = widget.expandCart;
  }

  void _toggleCartExpansion() {
    setState(() {
      _isCartExpanded = !_isCartExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        bool isDarkTheme = themeProvider.switchThemeIcon();
        return Scaffold(
      appBar: AppBar(
        title: Text('Track Orders', style: TextStyle(color:isDarkTheme ? AppColors.ultramarineBlue: AppColors.white, fontWeight: FontWeight.w500,),),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              _buildOrderTile(context, 'Order #1234', 'Shipped', DateTime.now().subtract(Duration(days: 1)), Colors.green),
              _buildOrderTile(context, 'Order #5678', 'Processing', DateTime.now().subtract(Duration(days: 3)), Colors.orange),
              _buildOrderTile(context, 'Order #9101', 'Delivered', DateTime.now().subtract(Duration(days: 7)), Colors.blue),
            ],
          ),
          _buildCartContainer(cartProvider),
        ],
      ),
      // bottomNavigationBar: BottomNavigation(
      //   selectedIndex: 1,
      //   onItemTapped: (index) {
      //     // Handle navigation
      //   },
      // ),
    );
  }
    );}
  Widget _buildCartContainer(CartProvider cartProvider) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: _isCartExpanded ? 0 : -200,
      left: 0,
      right: 0,
      height: _isCartExpanded ? 250 : 80, // Adjusted height for more space
      child: GestureDetector(
        onTap: _toggleCartExpansion,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.ultramarineBlue.withOpacity(0.8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: _isCartExpanded ? _buildExpandedCart(cartProvider) : _buildMinimizedCart(cartProvider),
        ),
      ),
    );
  }

  Widget _buildExpandedCart(CartProvider cartProvider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Icon(Icons.expand_more, color: Colors.white),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index) {
              return AnimatedCartItem(cartItem: cartProvider.items[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to checkout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Change button color to match the design
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text('Checkout', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimizedCart(CartProvider cartProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: cartProvider.items.map((item) {
        return CircleAvatar(
          radius: 24.0, // Slightly larger avatar
          backgroundColor: Colors.white.withOpacity(0.3), // Background for glass effect
          child: CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(item.productImage),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderTile(BuildContext context, String orderNumber, String status, DateTime date, Color statusColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0), // Add padding inside the tile
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.ultramarineBlue.withOpacity(0.9), statusColor.withOpacity(0.9)],
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
            Text('Date: ${date.toLocal().toString().split(' ')[0]}', style: TextStyle(color: AppColors.white.withOpacity(0.7))),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          // Navigate to order details page
        },
      ),
    );
  }
}
