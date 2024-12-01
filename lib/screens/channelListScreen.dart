import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({super.key});

  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  final List<String> channels = ["Tech", "Sports", "Music", "News"];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    initializeFirebaseMessaging();
    getToken();
  }


  void initializeFirebaseMessaging() {
    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showForegroundNotification(message.notification!.title ?? "",
            message.notification!.body ?? "");
      }
    });

    // Handle messages when the app is in the background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        showForegroundNotification(message.notification!.title ?? "",
            message.notification!.body ?? "");
      }
    });
  }

  void showForegroundNotification(String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  void getToken() async {
    String? token = await _firebaseMessaging.getToken(); // Get the FCM token
    print("FCM Token: $token"); // Print the token in the console
  }
  void subscribeToChannel(String channel) {
    _firebaseMessaging.subscribeToTopic(channel).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Subscribed to $channel"))
      );
    });
  }

  void unsubscribeFromChannel(String channel) {
    _firebaseMessaging.unsubscribeFromTopic(channel).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unsubscribed from $channel"))
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Channels")),
      body: ListView.builder(
        itemCount: channels.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(channels[index]),
            trailing: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Subscribe or unsubscribe based on the current state
                // Logic here (this could be dynamic based on whether the user is subscribed)
                subscribeToChannel(channels[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

