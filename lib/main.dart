import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_state_provider.dart';
import 'firebase_options.dart';
import 'screens/splash.dart';
import 'screens/adminhome.dart';
import 'screens/trainerhome.dart';
import 'screens/userhome.dart';
import 'screens/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthStateProvider(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitnesse Application',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 181, 181)),
      ),
      home: Consumer<AuthStateProvider>(
        builder: (ctx, authStateProvider, _) {
          return authStateProvider.ignoreAuthChange
              ? const SplashScreen()
              : StreamBuilder<User?>(
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
                          if (futureSnapshot.connectionState == ConnectionState.waiting) {
                            return const SplashScreen();
                          } else if (futureSnapshot.hasData) {
                            final userDoc = futureSnapshot.data;
                            if (userDoc!.exists) {
                              if (userDoc['userrole'] == 'User') {
                                return const UserHome();
                              } else if (userDoc['userrole'] == 'Admin') {
                                return const AdminHomeWidget();
                              } else if (userDoc['userrole'] == 'Trainer') {
                                return const TrainerHomepageWidget();
                              }
                            } else {
                              return const AuthScreen();
                            }
                          } else if (futureSnapshot.hasError) {
                            return const AuthScreen();
                          } else {
                            return const AuthScreen();
                          }
                          return const AuthScreen();
                        },
                      );
                    }
                    return const AuthScreen();
                  },
                );
        },
      ),
    );
  }
}