import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../provider/theme_provider.dart';

class MenuDrawer extends StatelessWidget {
  final String userName;
  final String userProfilePicture;
  final String userEmail;
  final VoidCallback onLogout;
  final VoidCallback onBecomeRetailer;

  MenuDrawer({
    required this.userName,
    required this.userProfilePicture,
    required this.userEmail,
    required this.onLogout,
    required this.onBecomeRetailer,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

        return Drawer(
          backgroundColor: themeProvider.switchThemeIcon() ? AppColors.white : AppColors.darkThemePrimary,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userName, style: TextStyle(color: Colors.white)),
                accountEmail: Text(userEmail, style: TextStyle(color: Colors.white)),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: userProfilePicture.isNotEmpty
                      ? NetworkImage(userProfilePicture)
                      : null,
                  child: userProfilePicture.isEmpty
                      ? Text(
                          userName[0],
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )
                      : null,
                ),
              ),
              ListTile(
                leading: Icon(
                  themeProvider.switchThemeIcon() ? Icons.dark_mode : Icons.light_mode,
                  color: themeProvider.switchThemeIcon() ? AppColors.ultramarineBlue : AppColors.white,
                ),
                title: Text(
                  'Switch Theme',
                  style: TextStyle(color: themeProvider.switchThemeIcon() ? AppColors.ultramarineBlue : AppColors.white),
                ),
                onTap: () {
                  themeProvider.toggleTheme();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.store,
                  color: themeProvider.switchThemeIcon() ? AppColors.ultramarineBlue : AppColors.white,
                ),
                title: Text(
                  'Become a Retailer',
                  style: TextStyle(color: themeProvider.switchThemeIcon() ? AppColors.ultramarineBlue : AppColors.white),
                ),
                onTap: onBecomeRetailer,
              ),
              Spacer(),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: themeProvider.switchThemeIcon() ? AppColors.ultramarineBlue : AppColors.white,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(color: themeProvider.switchThemeIcon() ? AppColors.ultramarineBlue : AppColors.white),
                ),
                onTap: onLogout,
              ),
            ],
          ),
        );
      },
    );
  }
}
