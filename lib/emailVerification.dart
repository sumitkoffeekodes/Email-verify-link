import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkverify/HomePage.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {

  Timer? timer;
  bool emailVerify = false;

  @override
  void initState() {
    super.initState();
    sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 3), (_) {
      checkVerification();
    });


  }


  checkVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      emailVerify = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(emailVerify) {
      timer!.cancel();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          )
      );
    }
  }

  Future<void>sendEmailVerification()async{
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    }catch(e){
      print("firebase link error $e");
    }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Email Verification"
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "A Verification email has been send to your email.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17
              ),
            ),

            const SizedBox(height: 20),


            const Text(
              "Note: if you can't get an email please check the spam ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13
              ),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: (){
                print(emailVerify);
                if(!emailVerify) {
                  sendEmailVerification();
                } else{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      )
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.email_outlined,color: Colors.white,),
                    SizedBox(width: 10),
                    Text(
                      "Resend Email",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
