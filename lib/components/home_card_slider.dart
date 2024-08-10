import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/colors.dart';

class HomeCardSlider extends StatefulWidget {
  final String userName;

  HomeCardSlider({required this.userName});

  @override
  _HomeCardSliderState createState() => _HomeCardSliderState();
}

class _HomeCardSliderState extends State<HomeCardSlider> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage == 4) {
          _currentPage = 0;
          _pageController.jumpToPage(_currentPage);
        } else {
          _currentPage++;
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning, ${widget.userName}';
    } else if (hour < 18) {
      return 'Good Afternoon, ${widget.userName}';
    } else {
      return 'Good Evening, ${widget.userName}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Center the PageView
        Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 460.0, // Adjust this width as needed
            ),
            child: SizedBox(
              height: 180.0,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildCard(getGreeting(), 'We hope you have a great day!', Icons.wb_sunny, _getGreetingImage(), context),
                  _buildCard('Quality', 'We ensure top-notch quality in all our products.', Icons.star, 'assets/quality_bg.jpg', context),
                  _buildCard('Trust', 'Trust is the foundation of our service.', Icons.lock, 'assets/trust_bg.jpg', context),
                  _buildCard('Affordability', 'We offer competitive prices on all items.', Icons.attach_money, 'assets/affordable_bg.jpg', context),
                  _buildCard('Transparency', 'Transparency in all transactions is our promise.', Icons.visibility, 'assets/transparent_bg.jpg', context),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        SmoothPageIndicator(
          controller: _pageController,
          count: 5,
          effect: WormEffect(
            dotHeight: 8.0,
            dotWidth: 8.0,
            activeDotColor: AppColors.ultramarineBlue,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _getGreetingImage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'assets/morning_bg.jpg';
    } else if (hour < 18) {
      return 'assets/afternoon_bg.jpg';
    } else {
      return 'assets/evening_bg.jpg';
    }
  }

  Widget _buildCard(String title, String description, IconData icon, String bgImage, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0), // Add horizontal padding for spacing
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  bgImage,
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.lightBlue.withOpacity(0.5),
                      AppColors.ultramarineBlue.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Content
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, size: 40.0, color: Colors.white),
                      SizedBox(height: 16.0),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
