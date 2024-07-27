import 'package:flutter/material.dart';
import './chat_page.dart';

class ContactSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy list of contacts for demonstration
    List<String> contacts = ['1234567890', '0987654321'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(contacts[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(contactPhoneNumber: contacts[index])),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddContactDialog(context);
        },
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter phone number'),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage(contactPhoneNumber: _controller.text)),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
