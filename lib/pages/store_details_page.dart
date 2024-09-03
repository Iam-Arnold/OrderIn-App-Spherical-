import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orderinapp/utils/colors.dart';
import 'package:orderinapp/pages/product_details_page.dart';
import 'package:share_plus/share_plus.dart';

class StoreDetailsPage extends StatefulWidget {
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
  _StoreDetailsPageState createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends State<StoreDetailsPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = prefs.getBool(widget.storeName) ?? false;
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = !_isFavorite;
      prefs.setBool(widget.storeName, _isFavorite);
    });
  }

  void _shareStoreDetails() {
    Share.share(
      'Check out this store: ${widget.storeName}, located at ${widget.storeLocation}. They offer great deals on ${widget.storeType}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storeName),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareStoreDetails,
          ),
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
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
                    image: NetworkImage(widget.placeholderImage),
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
                    widget.storeLocation,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                widget.storeType,
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
                    widget.rating.toString(),
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
                    widget.deliveryTime,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 4.0),
                  Text(
                    widget.deliveryFee,
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
      itemCount: widget.promoDeals.length,
      itemBuilder: (context, index) {
        return _buildPromoDealCard(context, widget.promoDeals[index]);
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
      child: Container(
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
      ),
    );
  }
}
