import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth.dart';
import 'screens/login.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Root();
  }
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    final auth = Auth(auth: _auth);
    
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData.dark(),
      home: StreamBuilder<User?>(
        stream: auth.user, 
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) { 
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              // User is logged in
              return HomeScreen(
                user: snapshot.data!,
                auth: auth,
                firestore: _firestore,
              );
            } else {
              // User is not logged in
              return LoginScreen(auth: auth);
            }
          }
          
          // Still loading
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
