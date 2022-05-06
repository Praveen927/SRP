import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';

import 'Customised/round_button.dart';

//code for designing the UI of our text field where the user writes his email id or password

const kTextFieldDecoration = InputDecoration(
    hintText: 'Enter a value',
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ));

class UserLoginScreen extends StatefulWidget {
  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

final _auth = FirebaseAuth.instance;

class _UserLoginScreenState extends State<UserLoginScreen> {
  String email;
  String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: wid / 20, vertical: hei / 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: [
                    Text(
                      "USER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 10.0,
                          fontSize: 50,
                          fontFamily: 'Allura',
                          fontWeight: FontWeight.w900),
                    ),
                    Image(
                        image: AssetImage("Resources/images/user.png"),
                        height: MediaQuery.of(context).size.height / 2),
                  ],
                ),
                TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                      //Do something with the user input.
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 100,
                ),
                TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                      //Do something with the user input.
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password')),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                RoundedButton(
                    colour: Colors.lightBlueAccent,
                    title: 'Log In',
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: "mailpraveen927@gmail.com",
                            password: "Praveen@27");
                        if (user != null) {
                          Navigator.pushNamed(context, 'home_screen');
                        }
                      } catch (e) {
                        //print("Wrong Userid or Password");
                        print(e);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
