import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../models/retailer.dart';
import '../components/top_navbar.dart';
import '../services/api/retailer_mock_api.dart';
import '../components/bottom_nav.dart';

class FavoriteRetailersPage extends StatefulWidget {
  @override
  _FavoriteRetailersPageState createState() => _FavoriteRetailersPageState();
}

class _FavoriteRetailersPageState extends State<FavoriteRetailersPage> {
  final MockApiService apiService = MockApiService();
  late Future<List<Retailer>> favoriteRetailersFuture;

  @override
  void initState() {
    super.initState();
    favoriteRetailersFuture = apiService.fetchRetailers('Favorite');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Favorite Retailers',
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Retailer>>(
          future: favoriteRetailersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No favorite retailers available'));
            } else {
              List<Retailer> favoriteRetailers = snapshot.data!;
              return ListView.builder(
                itemCount: favoriteRetailers.length,
                itemBuilder: (context, index) {
                  return _buildRetailerCard(context, favoriteRetailers[index]);
                },
              );
            }
          },
        ),
      ),
      //bottomNavigationBar: BottomNavigation(), 
    );
  }

  Widget _buildRetailerCard(BuildContext context, Retailer retailer) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          // Navigate to retailer details page
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Image.asset(
                retailer.placeholderImageAsset ?? 'assets/images/store_placeholder.png',
                height: 150.0,
                width: double.infinity,
                fit: BoxFit.cover,
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
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    retailer.retailerType,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 14.0, color: AppColors.grey),
                      SizedBox(width: 4.0),
                      Text(
                        retailer.time,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppColors.grey,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.attach_money, size: 14.0, color: AppColors.grey),
                      Text(
                        retailer.price,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
