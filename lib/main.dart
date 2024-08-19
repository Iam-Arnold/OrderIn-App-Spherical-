import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:orderinapp/firebase_options.dart';
import './utils/theme.dart';
import './pages/home_page.dart';
import './pages/order_tracking_page.dart';
import './pages/favourite_retailer.dart';
import './welcome/loading_screen.dart';
import './welcome/welcome_screen.dart';
import './welcome/signin.dart';
import './welcome/sign_up.dart';
import './components/bottom_nav.dart';
import './provider/user_provider.dart'; // Import the UserProvider
import './provider/theme_provider.dart'; // Import the ThemeProvider
import './provider/cart_provider.dart'; 
import './pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: OrderInApp(),
    ),
  );
}

class OrderInApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'OrderIn',
          theme: themeProvider.themeData,
          initialRoute: '/',
          routes: {
            '/': (context) => LoadingScreen(),
            '/welcome': (context) => WelcomeScreen(),
            '/signIn': (context) => SignInScreen(),
            '/signup': (context) => SignUpScreen(),
            '/main': (context) => MainScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomePage(),
      OrderTrackingPage(),
      FavoriteRetailersPage(),
      ProfilePage(), // Uncomment when ProfilePage is implemented
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
