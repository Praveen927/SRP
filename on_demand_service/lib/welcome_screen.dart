import 'package:flutter/material.dart';
import 'Customised/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
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
                  height: hei / 10,
                ),
                RoundedButton(
                  colour: Colors.lightBlueAccent,
                  title: 'User Log In',
                  onPressed: () {
                    Navigator.pushNamed(context, 'user_login_screen');
                  },
                ),
                RoundedButton(
                  colour: Colors.blueAccent,
                  title: 'Professional Log In',
                  onPressed: () {
                    Navigator.pushNamed(context, 'prof_login_screen');
                  },
                ),
                SizedBox(height: hei / 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New to Our App? ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    InkWell(
                      focusColor: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, "registration_screen");
                      },
                      child: Text(
                        "Register Here",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.blueAccent),
                      ),
                    )
                  ],
                ),
              ]),
        ));
  }
}
