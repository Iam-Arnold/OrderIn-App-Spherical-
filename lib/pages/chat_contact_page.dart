import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart';

class ChatContactPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _startChat(BuildContext context, String contactPhoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(contactPhoneNumber: contactPhoneNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select or Add Contact'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').doc(user!.uid).collection('contacts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var contacts = snapshot.data!.docs;
          if (contacts.isEmpty) {
            return Center(child: Text('No contacts added.'));
          }

          List<Widget> contactWidgets = [];
          for (var contact in contacts) {
            var phoneNumber = contact['phoneNumber'];
            contactWidgets.add(
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(phoneNumber[0].toUpperCase()),
                  ),
                  title: Text(
                    phoneNumber,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => _startChat(context, phoneNumber),
                ),
              ),
            );
          }

          return ListView(
            children: contactWidgets,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add logic to add a new contact
          _showAddContactDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final TextEditingController _phoneNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: TextField(
            controller: _phoneNumberController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String phoneNumber = _phoneNumberController.text.trim();
                if (phoneNumber.isNotEmpty) {
                  try {
                    final user = _auth.currentUser;
                    if (user != null) {
                      // Use phone number as document ID to avoid duplicates
                      await _firestore.collection('users').doc(user.uid).collection('contacts').doc(phoneNumber).set({
                        'phoneNumber': phoneNumber,
                      });
                    }
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error adding contact: $e');
                  }
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
