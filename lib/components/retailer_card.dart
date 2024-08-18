import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../models/retailer.dart';
import '../models/products.dart';
import '../pages/store_details_page.dart';
import '../provider/theme_provider.dart';
import '../services/api/product_mock_api.dart';
import '../utils/colors.dart';

class RetailerCard extends StatelessWidget {
  final Retailer retailer;

  RetailerCard({required this.retailer});

  @override
  Widget build(BuildContext context) {
    // Fetch the list of products for the retailer
    List<Product> products = MockProductApi.fetchProductsForRetailer(retailer.storeName);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreDetailsPage(
              storeName: retailer.storeName,
              storeLocation: '1km away',
              storeType: retailer.retailerType,
              rating: 4.2,
              deliveryTime: retailer.time,
              deliveryFee: retailer.price,
              promoDeals: _convertProductsToMap(products),
              placeholderImage: retailer.placeholderImageAsset ?? 'assets/orderinLogo.jpg',
            ),
          ),
        );
      },
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Container(
            width: 220.0,
            margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeProvider.switchThemeIcon()
                    ? [AppColors.lightBlue, AppColors.ultramarineBlue]
                    : [AppColors.darkBlue, AppColors.lightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: themeProvider.switchThemeIcon()
                      ? AppColors.grey.withOpacity(0.3)
                      : AppColors.darkBlue.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Check if products list is not empty
                if (products.isNotEmpty)
                  Container(
                    height: 140.0,
                    child: CarouselSlider.builder(
                      itemCount: products.length,  // Ensure itemCount matches the length of products
                      options: CarouselOptions(
                        height: 140.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.easeInOut,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 1200),
                        viewportFraction: 0.85,
                      ),
                      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                        final product = products[itemIndex];
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: product.imageUrl.startsWith('assets')
                                      ? AssetImage(product.imageUrl)
                                      : NetworkImage(product.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  margin: EdgeInsets.only(bottom: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    product.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        retailer.storeName,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.switchThemeIcon() ? AppColors.white : AppColors.lightBlue,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        retailer.retailerType,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppColors.white.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Delivery in ${retailer.time}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: AppColors.white.withOpacity(0.7),
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

  List<Map<String, String>> _convertProductsToMap(List<Product> products) {
    return products.map((product) {
      return {
        'name': product.name,
        'price': product.price.toString(),
        'image': product.imageUrl,
      };
    }).toList();
  }
}
