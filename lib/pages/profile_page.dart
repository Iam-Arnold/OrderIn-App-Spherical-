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

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = userProvider.userName;
    _phoneController.text = userProvider.userPhoneNumber;
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
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              hintText: 'Enter $title',
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
                  title: Text('Name'),
                  subtitle: Text(userProvider.userName),
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
                  title: Text('Email'),
                  subtitle: Text(userProvider.userEmail),
                ),
                ListTile(
                  title: Text('Phone Number'),
                  subtitle: Text(userProvider.userPhoneNumber.isNotEmpty ? userProvider.userPhoneNumber : 'Add phone number'),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
