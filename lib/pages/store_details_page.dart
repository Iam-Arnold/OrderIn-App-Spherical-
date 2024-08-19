import 'package:flutter/material.dart';
import 'package:orderinapp/provider/theme_provider.dart';
import 'package:orderinapp/utils/colors.dart';
import 'package:orderinapp/pages/product_details_page.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class StoreDetailsPage extends StatelessWidget {
  final String storeName;
  final String storeLocation;
  final String storeType;
  final double rating;
  final String deliveryTime;
  final String deliveryFee;
  final List<Map<String, String>> promoDeals;
  final String placeholderImage;

  StoreDetailsPage({
    required this.storeName,
    required this.storeLocation,
    required this.storeType,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.promoDeals,
    required this.placeholderImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(storeName),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _shareStoreDetails();
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Handle favorite action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    image: NetworkImage(placeholderImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.ultramarineBlue),
                  SizedBox(width: 4.0),
                  Text(
                    storeLocation,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                storeType,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  SizedBox(width: 4.0),
                  Text(
                    rating.toString(),
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.timer, color: AppColors.grey),
                  SizedBox(width: 4.0),
                  Text(
                    deliveryTime,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                  Spacer(),
                  //Icon(Icons.attach_money, color: AppColors.grey),
                  SizedBox(width: 4.0),
                  Text(
                    deliveryFee,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Promo Deals',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              SizedBox(height: 8.0),
              _buildPromoDeals(context),
            ],
          ),
        ),
      ),
    );
  }

  void _shareStoreDetails() {
    Share.share('Check out this store: $storeName, located at $storeLocation. They offer great deals on $storeType.');
  }

  Widget _buildPromoDeals(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: promoDeals.length,
      itemBuilder: (context, index) {
        print('dealssss $promoDeals[index]');
        return _buildPromoDealCard(context, promoDeals[index]);
      },
    );
  }

  Widget _buildPromoDealCard(BuildContext context, Map<String, String> deal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              productId: deal['id']!,
              productName: deal['name']!,
              productImage: deal['image']!,
              productPrice: deal['price']!,
              productDescription: 'For reference only: An image of fresh ${deal['name']}',
            ),
          ),
        );
      },
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(deal['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal['name']!,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        deal['price']!,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
