import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/chat/message_bubble.dart';
import '../utils/colors.dart';

class ChatPage extends StatefulWidget {
  final String contactPhoneNumber;

  ChatPage({required this.contactPhoneNumber});

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
      'receiverId': widget.contactPhoneNumber,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactPhoneNumber),
        backgroundColor: AppColors.ultramarineBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _messagesRef.orderBy('createdAt').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final bool isMe = message['senderId'] ==
                        FirebaseAuth.instance.currentUser!.uid;

                    return MessageBubble(
                      message: message['text'],
                      isMe: isMe,
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
