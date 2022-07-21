import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkverify/HomePage.dart';
import 'package:linkverify/RegisterPage.dart';
import 'emailVerification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login"
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),

        child: Column(
          children: [

            const SizedBox(height: 30),

            TextFormField(
             controller: emailController,
             onChanged: (value){
               setState(() {});
             },
             decoration: InputDecoration(
               hintText: "Email",
               focusedBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(10),
               ),

               enabledBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(10),
               )
             ),
           ),

            const SizedBox(height:20),

            TextFormField(
             controller: passwordController,
              onChanged: (value){
                setState(() {});
              },
             decoration: InputDecoration(
               hintText: "Password",
               focusedBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(10),
               ),

               enabledBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(10),
               )
             ),
           ),

            const SizedBox(height: 80),


            loading
                ?
            const CircularProgressIndicator(color: Colors.red,)
                :
            InkWell(
              onTap: () async {

               if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){

                 setState(() {
                   loading = true;
                 });

                 FocusScope.of(context).unfocus();

                 FirebaseAuth.instance.signInWithEmailAndPassword(
                     email: emailController.text.trim(),
                     password: passwordController.text.trim()
                 ).then((value) {
                   if (FirebaseAuth.instance.currentUser!.emailVerified == false) {
                     setState(() {
                       loading = false;
                     });
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => const EmailVerification(),
                       ),
                     );
                   }else{
                     Navigator.pushAndRemoveUntil(
                       context,
                       MaterialPageRoute(
                         builder: (context) => const HomePage(),
                       ),
                           (route) => false,
                     );
                   }
                 }).catchError((e) {
                   print(e);
                   setState(() {
                     loading = false;
                   });

                   if (e.code == 'invalid-email') {
                     ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(
                           backgroundColor: Colors.red,
                           content: Text(
                             'Invalid Email.',
                             style: TextStyle(
                                 color: Colors.white,
                             ),
                           ),
                         )
                     );
                   }
                   else if (e.code == 'user-not-found') {
                     ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(
                           backgroundColor: Colors.red,
                           content: Text(
                             'User Not Found.',
                             style: TextStyle(
                                 color: Colors.white
                             ),
                           ),
                         )
                     );
                   }

                   else if (e.code == 'wrong-password') {
                     ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(
                           backgroundColor: Colors.red,
                           content: Text(
                             'Wrong Password.',
                             style: TextStyle(
                                 color: Colors.white
                             ),
                           ),
                         )
                     );
                   }
                 });
               }

              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    color: emailController.text.isNotEmpty && passwordController.text.isNotEmpty ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  "Login Now",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ),


            const SizedBox(height: 30),

            InkWell(
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "If you don't have Account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17
                        )
                    ), TextSpan(
                      text: "Create new",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 17
                      )
                    )
                  ]
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
