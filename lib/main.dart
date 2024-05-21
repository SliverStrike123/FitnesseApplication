import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesseapplication/screens/adminhome.dart';
import 'package:fitnesseapplication/screens/trainerhome.dart';
import 'package:fitnesseapplication/screens/userhome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnesseapplication/screens/splash.dart';
import 'package:fitnesseapplication/screens/chat.dart';
import 'firebase_options.dart';
import 'package:fitnesseapplication/screens/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 181, 181)),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            } else if (snapshot.hasData) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .get(),
                builder: (ctx, futureSnapshot) {
                  if (futureSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SplashScreen();
                  } else if (futureSnapshot.hasData) {
                    final userDoc = futureSnapshot.data;
                    if (userDoc!.exists) {
                      if(userDoc['userrole'] == 'User'){
                        return const UserHome();
                      }
                      else if(userDoc['userrole'] == 'Admin'){
                        return const AdminHomeWidget();
                      }
                      else if(userDoc['userrole'] == 'Trainer'){
                        return const TrainerHome();
                      }
                    } else {
                      // Handle other roles or cases here if needed
                      return const AuthScreen();
                    }
                  } else if (futureSnapshot.hasError) {
                    // Handle error state
                    return const AuthScreen();
                  } else {
                    // Handle case where the user document does not exist
                    return const AuthScreen();
                  }
                  return const AuthScreen();
                },
              );}
              
            return const AuthScreen();
          }),
    );
  }
}
