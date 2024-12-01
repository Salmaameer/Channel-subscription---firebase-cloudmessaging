import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatRoomPage extends StatefulWidget {
  final String channelId;

  const ChatRoomPage({super.key, required this.channelId});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<Map<String, dynamic>> messages = [];
  final DatabaseReference chatRoomRef = FirebaseDatabase.instance.ref();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listenToMessages();
  }

  void _listenToMessages() {
    chatRoomRef.child('chatRooms/${widget.channelId}/messages').onChildAdded
        .listen((event) {
      final message = Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        messages.add(message);
      });
    });
  }

  void _sendMessage(String content) {
    final message = {
      'userId': 'user1', // Simulated user
      'content': content,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    chatRoomRef
        .child('chatRooms/${widget.channelId}/messages')
        .push()
        .set(message);
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['content']),
                  subtitle: Text("User: ${message['userId']}"),
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
                    controller: messageController,
                    decoration: const InputDecoration(labelText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      _sendMessage(messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
