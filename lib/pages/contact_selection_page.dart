import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api/retailer_mock_api.dart';
import '../models/retailer.dart';
import '../utils/colors.dart';
import '../provider/theme_provider.dart';
import 'chat_page.dart';

class ContactSelectionPage extends StatefulWidget {
  @override
  _ContactSelectionPageState createState() => _ContactSelectionPageState();
}

class _ContactSelectionPageState extends State<ContactSelectionPage> {
  final MockApiService apiService = MockApiService();
  late Future<List<Retailer>> retailersFuture;
  String searchQuery = '';
  List<Retailer> filteredRetailers = [];

  @override
  void initState() {
    super.initState();
    retailersFuture = apiService.fetchAllRetailers();
    retailersFuture.then((retailers) {
      setState(() {
        filteredRetailers = retailers;
      });
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredRetailers = filteredRetailers.where((retailer) {
        return retailer.storeName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Select a Retailer'),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search retailers...',
                    hintStyle: TextStyle(color: AppColors.ultramarineBlue),
                    prefixIcon: Icon(Icons.search, color: AppColors.ultramarineBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: themeProvider.switchThemeIcon() ? AppColors.lightBlue : AppColors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: themeProvider.switchThemeIcon() ? AppColors.lightBlue : AppColors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: AppColors.ultramarineBlue,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Retailer>>(
                  future: retailersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: AppColors.ultramarineBlue));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No retailers available'));
                    } else {
                      if (filteredRetailers.isEmpty) {
                        filteredRetailers = snapshot.data!;
                      }
                      return ListView.builder(
                        itemCount: filteredRetailers.length,
                        itemBuilder: (context, index) {
                          Retailer retailer = filteredRetailers[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    retailerId: retailer.storeName,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2.0, // Reduced shadow elevation
                              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: themeProvider.switchThemeIcon() ? AppColors.white : AppColors.darkBlue,
                              child: ListTile(
                                contentPadding: EdgeInsets.all(10.0),
                                leading: CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: AssetImage(retailer.placeholderImageAsset),
                                ),
                                title: Text(
                                  retailer.storeName,
                                  style: TextStyle(
                                    color: themeProvider.switchThemeIcon() ? AppColors.darkBlue : AppColors.white,
                                  ),
                                ),
                                // Add other retailer details here if needed
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
