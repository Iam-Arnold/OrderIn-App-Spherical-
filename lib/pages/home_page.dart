import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/colors.dart';
import '../components/top_navbar.dart';
import '../services/api/retailer_mock_api.dart';
import '../models/retailer.dart';
import './store_details_page.dart';
import './chat_page.dart';
import 'all_retailers.dart';
import '../services/api/product_mock_api.dart';
import '../models/products.dart';
import '../components/spherical_loader.dart';
import '../components/retailer_card.dart';
import '../components/menu_drawer.dart';
import '../provider/user_provider.dart';
import '../provider/theme_provider.dart';
import './phone_reg_page.dart';
import './contact_selection_page.dart';
import '../components/home_card_slider.dart';
import './profile_page.dart';
import '../components/lazy_loader_cards.dart';

class HomePage extends StatefulWidget {
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
    // Ensure UserProvider is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).fetchUserDetails(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<UserProvider>(context).userName;

    return Scaffold(
      appBar: AppBar(
        title: Text('OrderIn'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactSelectionPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://example.com/default-profile.png'), // Default image
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final String userName = userProvider.userName.isNotEmpty ? userProvider.userName : 'Guest';
                    final String userProfilePicture = userProvider.userProfilePicture;

                    if (userProfilePicture.isNotEmpty) {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(userProfilePicture),
                      );
                    } else {
                      return Text(
                        userName[0],
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final String userName = userProvider.userName.isNotEmpty ? userProvider.userName : 'Guest';
          final String userProfilePicture = userProvider.userProfilePicture;
          final String userEmail = userProvider.userEmail;

          return MenuDrawer(
            userName: userName,
            userProfilePicture: userProfilePicture,
            userEmail: userEmail,
            onBecomeRetailer: () {
              // Handle becoming a retailer
            },
          );
        },
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
                    HomeCardSlider(userName: userName), // Add the card slider here
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
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
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
                color: Colors.blue,
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
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) => LazyLoaderCard()), // Displaying 5 loading cards
              ),
            );
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

  Widget _buildPlaceholderCard() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 150.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
