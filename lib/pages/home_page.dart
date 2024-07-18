import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../components/top_navbar.dart';
import '../services/api/retailer_mock_api.dart';
import '../models/retailer.dart';
import './store_details_page.dart';
import './chat_page.dart';
import 'all_retailers.dart';
import '../services/api/product_mock_api.dart';
import '../models/products.dart';
import '../components/spherical_loader.dart'; // Import the spherical loader
import '../components/retailer_card.dart'; // Import the RetailerCard component

class HomePage extends StatefulWidget {
  final String userName;
  final String userProfilePicture;

  HomePage({required this.userName, required this.userProfilePicture});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MockApiService apiService = MockApiService();
  late Future<List<String>> categoriesFuture;
  final Map<String, Future<List<Retailer>>> retailersFutures = {};

  @override
  void initState() {
    super.initState();
    categoriesFuture = apiService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrderIn'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Handle cart action
            },
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
          ),
          _buildUserAvatar(widget.userName, widget.userProfilePicture), // Add user avatar here
        ],
        leading: Icon(Icons.shopping_basket),
      ),
      body: FutureBuilder<List<String>>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: SphericalLoader(color: AppColors.ultramarineBlue)); // Use spherical loader
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories available'));
          } else {
            List<String> categories = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(context),
                    SizedBox(height: 16.0),
                    _buildCoreValuesSection(),
                    SizedBox(height: 16.0),
                    for (String category in categories) ...[
                      _buildCategorySection(category, context),
                      SizedBox(height: 16.0),
                    ]
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserAvatar(String userName, String userProfilePicture) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: () {
          // Handle profile tap
        },
        child: CircleAvatar(
          backgroundImage: userProfilePicture.isNotEmpty
              ? NetworkImage(userProfilePicture)
              : null,
          child: userProfilePicture.isEmpty
              ? Text(
                  userName[0],
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              : null,
        ),
      ),
    );
  }
  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2.0, // Reduced shadow
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cargoplane.jpg'), // Adjust the path as needed
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ordering Goods Overseas',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'See how you can find and order products from abroad with ease.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoreValuesSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCoreValueBox(Icons.store, 'Find Store'),
        _buildCoreValueBox(Icons.add_shopping_cart, 'Place Order'),
        _buildCoreValueBox(Icons.track_changes, 'Track Order'),
        _buildCoreValueBox(Icons.local_shipping, 'Receive'),
      ],
    );
  }

  Widget _buildCoreValueBox(IconData icon, String title) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundColor: AppColors.ultramarineBlue,
          child: Icon(icon, color: AppColors.white, size: 30.0),
        ),
        SizedBox(height: 8.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(String title, BuildContext context) {
    if (!retailersFutures.containsKey(title)) {
      retailersFutures[title] = apiService.fetchRetailers(title, limit: 10);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to AllRetailersPage when See More is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder<List<Retailer>>(
                      future: retailersFutures[title],
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No retailers available'));
                        } else {
                          List<Retailer> retailers = snapshot.data!;
                          return AllRetailersPage(category: title, retailers: retailers);
                        }
                      },
                    ),
                  ),
                );
              },
              child: Text(
                'See More',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ultramarineBlue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        FutureBuilder<List<Retailer>>(
          future: retailersFutures[title],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No retailers available'));
            } else {
              List<Retailer> retailers = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: retailers.map((retailer) => RetailerCard(retailer: retailer)).toList(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
