// import 'package:flutter/material.dart';
// import '../services/api/retailer_mock_api.dart';
// import '../models/retailer.dart';
// import 'chat_page.dart';

// class ContactSelectionPage extends StatefulWidget {
//   @override
//   _ContactSelectionPageState createState() => _ContactSelectionPageState();
// }

// class _ContactSelectionPageState extends State<ContactSelectionPage> {
//   final MockApiService apiService = MockApiService();
//   late Future<List<Retailer>> retailersFuture;

//   @override
//   void initState() {
//     super.initState();
//     retailersFuture = apiService.fetchAllRetailers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select a Retailer'),
//       ),
//       body: FutureBuilder<List<Retailer>>(
//         future: retailersFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No retailers available'));
//           } else {
//             List<Retailer> retailers = snapshot.data!;
//             return ListView.builder(
//               itemCount: retailers.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(retailers[index].storeName),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChatPage(
//                           retailerId: retailers[index].storeName,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
