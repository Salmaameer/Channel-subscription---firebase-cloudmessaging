import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/firestoreTask.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

// task 2
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Channel Subscription App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChannelPage(),
    );
  }
}


// task 1
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Channel Subscription',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const ChannelListScreen(),
//     );
//   }
// }


// task 2
