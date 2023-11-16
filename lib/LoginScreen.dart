import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'palette.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool iss = true;

  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPass = '';

  void _tvd(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Stack(
        children: [
          Positioned(
            top: 150,
            child: Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width-100,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              iss = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'LOGIN',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:iss ? Palette.activeColor : Palette.textColor1
                                ),
                              ),
                              // if(!isSignupScreen)
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                height: 2,
                                width: 55,
                                color: iss ? Colors.blue : Colors.white,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              iss = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'SIGNUP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: !iss ? Palette.activeColor : Palette.textColor1,
                                ),
                              ),
                              // if(isSignupScreen)
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                height: 2,
                                width: 55,
                                color: !iss ? Colors.blue : Colors.white,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    if(!iss)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                key: const ValueKey(1),
                                validator: (value){
                                  if(value!.isEmpty||value!.length<4){
                                    return 'Please enter at least 4 characters';
                                  }
                                },
                                onSaved: (value){
                                  userName = value!;
                                },
                                onChanged: (value){
                                  userName = value;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.activeColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    hintText: 'UserName',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10)
                                ),
                              ),
                              const SizedBox(height: 8,),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                key: const ValueKey(2),
                                validator: (value){
                                  if(value!.isEmpty||!value.contains('@')){
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  userEmail = value!;
                                },
                                onChanged: (value){
                                  userEmail = value;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.activeColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10)
                                ),
                              ),
                              const SizedBox(height: 8,),
                              TextFormField(
                                obscureText: true,
                                key: const ValueKey(3),
                                validator: (value){
                                  if(value!.isEmpty||value!.length<6){
                                    return 'Please enter at least 6 characters';
                                  }
                                },
                                onSaved: (value){
                                  userPass = value!;
                                },
                                onChanged: (value){
                                  userPass = value;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.password,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.activeColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10)
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                key: const ValueKey(4),
                                validator: (value){
                                  if(value!.isEmpty||!value.contains('@')){
                                    return 'Please enter a valid eamil';
                                  }
                                },
                                onSaved: (value){
                                  userEmail = value!;
                                },
                                onChanged: (value){
                                  userEmail = value;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.activeColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10)
                                ),
                              ),
                              const SizedBox(height: 8,),
                              TextFormField(
                                obscureText: true,
                                key: const ValueKey(5),
                                validator: (value){
                                  if(value!.isEmpty||value!.length<6){
                                    return 'Please enter at least 6 characters';
                                  }
                                },
                                onSaved: (value){
                                  userPass = value!;
                                },
                                onChanged: (value){
                                  userPass = value;
                                },
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.password,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.activeColor,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35),
                                      ),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: EdgeInsets.all(10)
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ) ,
            ),
          ),
          Positioned(
            // duration: Duration(milliseconds: 500),
            // curve: Curves.easeIn,
            top: MediaQuery.of(context).size.height - 100,
            right: 0,
            left: 0,
            child: Center(
              child: GestureDetector(
                onTap: () async{
                  print('yee');
                  // handleButtonClick();
                  if(!iss) {
                    _tvd();

                    try {
                      final newUser = await _auth
                          .createUserWithEmailAndPassword(
                        email: userEmail,
                        password: userPass,
                      );
                      int getRandomHue() {
                        final random = Random();
                        int hue = (random.nextInt(12) * 30) % 360;
                        return hue;
                      }
                      await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid).set({'userName' : userName,'email' : userEmail,'color': getRandomHue(),'position':null,'time':Timestamp.now()});
                      if(newUser.user != null){
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context){
                            return ChatScreen();
                          }),
                      );*/
                      }
                    }catch(e){
                      print(e);
                    }
                  }else{
                    _tvd();

                    try {
                      final newUser = await _auth.signInWithEmailAndPassword(
                          email: userEmail,
                          password: userPass
                      );
                      if (newUser.user != null) {
                        /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ChatScreen();
                        }),
                      );*/
                      }
                    }catch(e){
                      print(e);
                    }
                  }
                  /*print(userName);
                print(userEmail);
                print(userPass);*/

                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.purple
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: const Offset(0,0),
                          )
                        ]
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white,),
                  ),
                ),
              ),
            ),
          ),
        ],

      ),
    );
  }
}
