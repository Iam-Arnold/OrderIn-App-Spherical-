import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/user_provider.dart';
import '../provider/theme_provider.dart';
import '../utils/colors.dart';
//import 'become_retailer_page.dart'; // Replace with your actual import

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = userProvider.userName;
    _phoneController.text = userProvider.userPhoneNumber;

    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(UserProvider userProvider) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await userProvider.updateProfilePicture(pickedFile.path);
    }
  }

 Future<void> _showEditDialog({required String title, required TextEditingController controller, required Function(String) onSave}) async {
    controller.text = title == 'Name' ? context.read<UserProvider>().userName : '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update your $title'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7, // Reduced width
            height: 100, // Reduced height
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: title,
                    hintText: 'Enter $title',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSlidingCard({
    required String title,
    required String imagePath,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkBlue.withOpacity(0.6),
              ),
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, ThemeProvider>(
      builder: (context, userProvider, themeProvider, child) {
        bool isDarkTheme = themeProvider.switchThemeIcon();
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: userProvider.userProfilePicture.isNotEmpty
                          ? NetworkImage(userProvider.userProfilePicture)
                          : null,
                      child: userProvider.userProfilePicture.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 50,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit, color: AppColors.ultramarineBlue),
                          onPressed: () => _pickImage(userProvider),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text('Name', style: TextStyle(color: AppColors.grey)),
                  subtitle: Text(userProvider.userName, style: TextStyle(color: AppColors.lightBlue)),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: AppColors.ultramarineBlue),
                    onPressed: () => _showEditDialog(
                      title: 'Name',
                      controller: _nameController,
                      onSave: (value) async {
                        await userProvider.updateUserName(value);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name updated')));
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Email', style: TextStyle(color: AppColors.grey)),
                  subtitle: Text(userProvider.userEmail, style: TextStyle(color: AppColors.lightBlue)),
                ),
                ListTile(
                  title: Text('Phone Number', style: TextStyle(color: AppColors.grey)),
                  subtitle: Text(userProvider.userPhoneNumber.isNotEmpty ? userProvider.userPhoneNumber : 'Add phone number', style: TextStyle(color: AppColors.lightBlue)),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: AppColors.ultramarineBlue),
                    onPressed: () => _showEditDialog(
                      title: 'Phone Number',
                      controller: _phoneController,
                      onSave: (value) async {
                        await userProvider.updatePhoneNumber(value);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Phone number updated')));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      _buildSlidingCard(
                        title: 'Quality',
                        imagePath: 'assets/quality.jpg',
                      ),
                      _buildSlidingCard(
                        title: 'Affordable',
                        imagePath: 'assets/affordable.jpg',
                      ),
                      _buildSlidingCard(
                        title: 'Trust',
                        imagePath: 'assets/trust.jpg',
                      ),
                      _buildSlidingCard(
                        title: 'Transparent',
                        imagePath: 'assets/transparent.jpg',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
