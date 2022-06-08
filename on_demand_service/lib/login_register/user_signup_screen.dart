import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../Customised/round_button.dart';

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
  ),
);

class UserRegistrationScreen extends StatefulWidget {
  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;
  final _emailKey = GlobalKey<FormState>();
  final _pwdKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: wid / 20, vertical: hei / 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image(
                    image: AssetImage("Resources/images/user1.png"),
                    height: hei / 2),
                Text(
                  "Signup",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 50,
                      fontFamily: 'Volkhov',
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: hei / 40,
                ),
                Form(
                  key: _emailKey,
                  child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty || !value.contains("@")) {
                          return "Invalid Email id";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                        //Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 100,
                ),
                Form(
                  key: _pwdKey,
                  child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Invalid Password";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                        //Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password',
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                RoundedButton(
                    colour: Colors.lightBlueAccent,
                    title: 'Register',
                    onPressed: () async {
                      try {
                        if (!_emailKey.currentState.validate()) {
                        } else if (!_pwdKey.currentState.validate()) {
                        } else {
                          setState(() {
                            showSpinner = true;
                          });
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (newUser != null) {
                            Navigator.popAndPushNamed(
                                context, 'user_home_screen');
                          }
                        }
                      } catch (e) {
                        print(e);
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
