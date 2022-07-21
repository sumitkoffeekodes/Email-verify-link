import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'emailVerification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool emailVerify = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register"
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              const SizedBox(height: 30),

              TextFormField(
               controller: emailController,
               validator: (value){

                 String pattern =
                     r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                     r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                     r"{0,253}[a-zA-Z0-9])?)*$";

                 RegExp regex = RegExp(pattern);

                 if (value == null || value.isEmpty) {
                   return 'Please enter Email-Id';
                 }else if(!regex.hasMatch(value)){
                   return 'Please enter valid Email-Id';
                 }
                 return null;
               },
               decoration: InputDecoration(
                 hintText: "Email",
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
                 errorBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
                 focusedErrorBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 )
               ),
             ),

              const SizedBox(height: 20),

              TextFormField(
               controller: passwordController,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }else if(value.length < 6){
                    return 'Password must be 6 digit';
                  }
                  return null;
                },
               decoration: InputDecoration(
                 hintText: "Password",
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),

                 errorBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),

                 focusedErrorBorder: OutlineInputBorder(
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

                  if(_formKey.currentState!.validate()) {

                    setState(() {
                      loading = true;
                    });

                    FocusScope.of(context).unfocus();
                    FirebaseAuth.instance.createUserWithEmailAndPassword(
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
                      }
                    }).catchError((e) {

                      setState(() {
                        loading = false;
                      });

                      if (e.code == 'weak-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.amber,
                              content: Text(
                                'The password provided is too weak.',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            )
                        );
                      }
                      else if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'The account already exists for that email.',
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
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: const Text(
                    "Register Now",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
