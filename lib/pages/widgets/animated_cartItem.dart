import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import 'package:provider/provider.dart';
import '../../provider/cart_provider.dart';
import '../my_cart_page.dart';

class AnimatedCartItem extends StatefulWidget {
  final CartItem cartItem;

  AnimatedCartItem({required this.cartItem});

  @override
  _AnimatedCartItemState createState() => _AnimatedCartItemState();
}

class _AnimatedCartItemState extends State<AnimatedCartItem> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  widget.cartItem.productImage,
                  width: 60,
                  height: 60,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.cartItem.productName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (_isExpanded) ...[
              SizedBox(height: 10),
              Text('Price: ${widget.cartItem.productPrice}'),
              Text('Quantity: ${widget.cartItem.quantity}'),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      cartProvider.updateQuantity(
                        widget.cartItem.productId,
                        widget.cartItem.quantity - 1,
                      );
                    },
                  ),
                  Text('${widget.cartItem.quantity}'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      cartProvider.updateQuantity(
                        widget.cartItem.productId,
                        widget.cartItem.quantity + 1,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyCartPage(
                        cartItems: [widget.cartItem], // Pass the single item here
                      ),
                    ),
                  );
                },
                child: Text('View in Cart'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
