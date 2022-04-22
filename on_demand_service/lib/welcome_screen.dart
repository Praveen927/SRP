import 'package:flutter/material.dart';
import 'Customised/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Web app",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 10.0,
                      fontSize: 50,
                      fontFamily: 'Allura',
                      fontWeight: FontWeight.w900),
                ),
                Image(image: AssetImage("Resources/images/welcome_img.jpg")),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 75,
                ),
                RoundedButton(
                  colour: Colors.lightBlueAccent,
                  title: 'Log In',
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_screen');
                  },
                ),
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: 'Register',
                    onPressed: () {
                      Navigator.pushNamed(context, 'registration_screen');
                    }),
              ]),
        ));
  }
}
