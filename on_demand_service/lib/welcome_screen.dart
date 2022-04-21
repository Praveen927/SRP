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
              children: <Widget>[
                Text(
                  "ABCD",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 10.0,
                      fontSize: 50,
                      fontFamily: 'Allura',
                      fontWeight: FontWeight.w900),
                ),
                Image(
                    height: MediaQuery.of(context).size.height / 2,
                    image: NetworkImage(
                        "https://media.istockphoto.com/vectors/men-workers-set-in-uniform-vector-id977797014?k=20&m=977797014&s=612x612&w=0&h=O3EL4QSTxWa2JE3vY2gx4Tv35zVe8xyHUAqsevYwqjo=")),
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
