import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/user_provider.dart';
import '../provider/theme_provider.dart';
import '../utils/colors.dart';
import '../components/heart_beat_loader.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _phoneController = TextEditingController();

    // Load user data from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      _nameController.text = userProvider.userName;
      _phoneController.text = userProvider.userPhoneNumber;
    });

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
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(UserProvider userProvider) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await userProvider.updateProfilePicture(pickedFile.path);
    }
  }

  Future<void> _showEditDialog({
    required String title,
    required TextEditingController controller,
    required Function(String) onSave,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.lightBlue, AppColors.ultramarineBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Update your $title',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Enter $title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel', style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            onSave(controller.text);
                            Navigator.of(context).pop();
                          },
                          child: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.ultramarineBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
    );
  }

Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required Function(String) onSave,
  }) {
    return GestureDetector(
      onTap: () {
        _showEditDialog(title: label, controller: controller, onSave: onSave);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightBlue, AppColors.ultramarineBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Flexible(
              child: Text(
                controller.text.isNotEmpty ? controller.text : _nameController.text,
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.create, color: Colors.white), // Changed icon to a pencil
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightBlue, AppColors.ultramarineBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HeartbeatLoader()),
        );
        Provider.of<UserProvider>(context, listen: false).logout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, ThemeProvider>(
      builder: (context, userProvider, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile', style: TextStyle(color: themeProvider.switchThemeIcon() ? AppColors.ultramarineBlue : Colors.white)),
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture Section
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: userProvider.userProfilePicture.isNotEmpty
                          ? NetworkImage(userProvider.userProfilePicture)
                          : null,
                      child: userProvider.userProfilePicture.isEmpty
                          ? Icon(Icons.person, size: 60, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.darkThemePrimary, AppColors.ultramarineBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: () => _pickImage(userProvider),
                        ),
                      ),
                    ),
                  ],
                ),

                // User Name and Phone Number Section
                SizedBox(height: 16),
                Text(
                  userProvider.userName.isNotEmpty ? userProvider.userName : 'No name available',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeProvider.switchThemeIcon() ? AppColors.darkBlue : AppColors.white),
                ),
                SizedBox(height: 8),
                Text(
                  userProvider.userPhoneNumber.isNotEmpty
                      ? userProvider.userPhoneNumber
                      : 'No phone number available',
                  style: TextStyle(fontSize: 16, color: themeProvider.switchThemeIcon() ? AppColors.darkBlue : Colors.white70),
                ),

                // Editable Fields and Profile Options
                SizedBox(height: 20),
                _buildEditableField(
                  label: 'New name',
                  controller: _nameController,
                  onSave: (value) async {
                    await userProvider.updateUserName(value);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name updated')));
                  },
                ),
                _buildEditableField(
                  label: 'New phone',
                  controller: _phoneController,
                  onSave: (value) async {
                    await userProvider.updatePhoneNumber(value);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Phone number updated')));
                  },
                ),

                SizedBox(height: 30),
                _buildProfileOption(
                  title: 'Settings',
                  icon: Icons.settings,
                  onTap: () {
                    // Handle settings navigation
                  },
                ),
                _buildProfileOption(
                  title: 'Privacy Policy',
                  icon: Icons.privacy_tip,
                  onTap: () {
                    // Handle privacy policy navigation
                  },
                ),
                _buildProfileOption(
                  title: 'Terms of Service',
                  icon: Icons.article,
                  onTap: () {
                    // Handle terms of service navigation
                  },
                ),
                _buildProfileOption(
                  title: 'Logout',
                  icon: Icons.logout,
                  onTap: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
