import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/chat/message_bubble.dart';
import '../utils/colors.dart';

class ChatPage extends StatefulWidget {
  final String retailerId;

  ChatPage({required this.retailerId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _messagesRef =
      FirebaseFirestore.instance.collection('messages');

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    _messagesRef.add({
      'text': _messageController.text,
      'createdAt': Timestamp.now(),
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': widget.retailerId,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Retailer'),
        backgroundColor: AppColors.ultramarineBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _messagesRef
                  .where('senderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where('receiverId', isEqualTo: widget.retailerId)
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final bool isCustomer = message['senderId'] == FirebaseAuth.instance.currentUser!.uid;

                    return MessageBubble(
                      message: message['text'],
                      isCustomer: isCustomer,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.ultramarineBlue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatContactPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _startChat(BuildContext context, String retailerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(retailerId: retailerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Retailer'),
        backgroundColor: AppColors.ultramarineBlue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('retailers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var retailers = snapshot.data!.docs;
          if (retailers.isEmpty) {
            return Center(child: Text('No retailers available.'));
          }

          List<Widget> retailerWidgets = [];
          for (var retailer in retailers) {
            var retailerName = retailer['name'];
            var retailerId = retailer.id;

            retailerWidgets.add(
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(retailerName[0].toUpperCase()),
                  ),
                  title: Text(
                    retailerName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => _startChat(context, retailerId),
                ),
              ),
            );
          }

          return ListView(
            children: retailerWidgets,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add logic to add a new retailer (if applicable)
          _showAddRetailerDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddRetailerDialog(BuildContext context) {
    final TextEditingController _retailerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Retailer'),
          content: TextField(
            controller: _retailerController,
            decoration: InputDecoration(
              labelText: 'Retailer Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String retailerName = _retailerController.text.trim();
                if (retailerName.isNotEmpty) {
                  try {
                    // Use a unique ID for the retailer
                    await _firestore.collection('retailers').add({
                      'name': retailerName,
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error adding retailer: $e');
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
