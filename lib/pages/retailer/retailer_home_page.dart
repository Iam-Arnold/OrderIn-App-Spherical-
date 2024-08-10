import 'package:flutter/material.dart';

class RetailerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retailer Home'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to product upload page
              },
              child: Text('Upload New Product'),
            ),
            // Add other functionalities
          ],
        ),
      ),
    );
  }
}
