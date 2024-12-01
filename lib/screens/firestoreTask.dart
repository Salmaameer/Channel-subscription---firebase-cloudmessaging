import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatRoom.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({super.key});

  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  List<Map<String, dynamic>> channels = [];
  String userId = "user1"; // Simulate a logged-in user

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    try {
      final channelsSnapshot =
      await FirebaseFirestore.instance.collection('channels').get();
      final userSubscriptionSnapshot = await FirebaseFirestore.instance
          .collection('subscriptions')
          .doc(userId)
          .get();

      List<String> subscribedChannels = [];
      if (userSubscriptionSnapshot.exists) {
        subscribedChannels =
        List<String>.from(userSubscriptionSnapshot.data()?['channels'] ?? []);
      }

      setState(() {
        channels = channelsSnapshot.docs.map((doc) {
          final channelData = doc.data();
          return {
            'id': doc.id,
            'name': channelData['name'],
            'subscribed': subscribedChannels.contains(doc.id),
          };
        }).toList();
      });
      print(channels);
    } catch (e) {
      print('Error loading channels: $e');
    }
  }

  Future<void> _toggleSubscription(String channelId, bool isSubscribed) async {
    try {
      final userSubscriptionRef =
      FirebaseFirestore.instance.collection('subscriptions').doc(userId);

      if (isSubscribed) {
        await userSubscriptionRef.update({
          'channels': FieldValue.arrayRemove([channelId])
        });
      } else {
        await userSubscriptionRef.set({
          'channels': FieldValue.arrayUnion([channelId])
        }, SetOptions(merge: true));
      }

      _loadChannels();
    } catch (e) {
      print('Error toggling subscription: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Channel Subscriptions')),
      body: ListView.builder(
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          return ListTile(
            title: Text(channel['name']),
            trailing: ElevatedButton(
              onPressed: () => _toggleSubscription(
                  channel['id'], channel['subscribed']),
              child: Text(
                channel['subscribed'] ? 'Unsubscribe' : 'Subscribe',
              ),
            ),
            onTap: () {
              if (channel['subscribed']) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoomPage(channelId: channel['id']),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Subscribe to access this channel!"),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
