import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Text(
            "Email: ${auth.currentUser!.email}"
          ),

          const SizedBox(height: 20),

          InkWell(
            onTap: (){
              auth.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),

                   (route) => false
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.login),
                SizedBox(width: 10),
                Text(
                  "Logout"
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
