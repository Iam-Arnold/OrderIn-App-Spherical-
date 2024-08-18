import 'package:flutter/material.dart';
import 'package:orderinapp/provider/theme_provider.dart';
import 'package:orderinapp/utils/colors.dart';
import '../models/retailer.dart';
import './store_details_page.dart';
import '../services/api/product_mock_api.dart';
import '../models/products.dart';
import 'package:provider/provider.dart';
import './widgets/search_field.dart'; // Import the new SearchField component

class AllRetailersPage extends StatefulWidget {
  final String category;
  final List<Retailer> retailers;

  const AllRetailersPage({Key? key, required this.category, required this.retailers}) : super(key: key);

  @override
  _AllRetailersPageState createState() => _AllRetailersPageState();
}

class _AllRetailersPageState extends State<AllRetailersPage> {
  TextEditingController _searchController = TextEditingController();
  List<Retailer> _filteredRetailers = [];

  @override
  void initState() {
    super.initState();
    _filteredRetailers = widget.retailers;
    _searchController.addListener(_filterRetailers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRetailers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredRetailers = widget.retailers;
      } else {
        _filteredRetailers = widget.retailers.where((retailer) {
          return retailer.storeName.toLowerCase().contains(query) ||
                 retailer.retailerType.toLowerCase().contains(query) ||
                 retailer.time.toLowerCase().contains(query) ||
                 retailer.price.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchField(
              controller: _searchController, // Use the SearchField component
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRetailers.length,
              itemBuilder: (context, index) {
                Retailer retailer = _filteredRetailers[index];
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
                          promoDeals: _convertProductsToMap(MockProductApi.fetchProductsForRetailer(retailer.storeName)),
                          placeholderImage: retailer.placeholderImageAsset ?? 'assets/images/store_placeholder.png',
                        ),
                      ),
                    );
                  },
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: themeProvider.switchThemeIcon() ? AppColors.white : AppColors.darkBlue,
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
                              height: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(retailer.placeholderImageAsset ?? 'assets/images/store_placeholder.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.0),
                                  Text(
                                    retailer.storeName,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.lightBlue,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    retailer.retailerType,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      Icon(Icons.timer, size: 14.0, color: Colors.grey),
                                      SizedBox(width: 4.0),
                                      Text(
                                        retailer.time,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(Icons.attach_money, size: 14.0, color: Colors.grey),
                                      Text(
                                        retailer.price,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
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
              },
            ),
          ),
        ],
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
