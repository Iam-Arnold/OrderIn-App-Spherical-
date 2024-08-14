import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/user_provider.dart';
import '../provider/theme_provider.dart';
import '../utils/colors.dart';

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
                controller.text.isEmpty ? 'Tap to add $label' : controller.text,
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, ThemeProvider>(
      builder: (context, userProvider, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.ultramarineBlue,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                            colors: [AppColors.lightBlue, AppColors.ultramarineBlue],
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
                SizedBox(height: 20),
                _buildEditableField(
                  label: 'Name',
                  controller: _nameController,
                  onSave: (value) async {
                    await userProvider.updateUserName(value);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name updated')));
                  },
                ),
                _buildEditableField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  onSave: (value) async {
                    await userProvider.updatePhoneNumber(value);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Phone number updated')));
                  },
                ),
                SizedBox(height: 30), // Space added between the fields and rest of the options
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
                  title: 'Logout',
                  icon: Icons.logout,
                  onTap: () {
                    // Handle logout
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
