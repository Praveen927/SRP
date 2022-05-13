import 'package:flutter/material.dart';

import '../Customised/list_card.dart';

class UserHomeScreen extends StatefulWidget {
  static const String idScreen = "main";
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: wid / 20, vertical: hei / 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: wid / 15,
                    )),
                Text(
                  "Choose Your \nService",
                  style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Volkhov',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: hei / 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListCard(
                  title: "  Plumbing",
                  img_url: "Resources/images/prof.png",
                  size: hei / 6,
                  onPressed: () {
                    Navigator.pushNamed(context, 'prof_detail_screen',
                        arguments: {'work': 0});
                  },
                ),
                ListCard(
                  title: "  Electrician",
                  img_url: "Resources/images/signup_img.png",
                  size: hei / 6,
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(
              height: hei / 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListCard(
                  title: " Cooking",
                  img_url: "Resources/images/cooking.png",
                  size: hei / 6,
                  onPressed: () {},
                ),
                ListCard(
                  title: "  Mechanic",
                  img_url: "Resources/images/mechanic.png",
                  size: hei / 6,
                  onPressed: () {
                    Navigator.pushNamed(context, 'prof_detail_screen',
                        arguments: {'work': 2});
                  },
                ),
              ],
            ),
            SizedBox(
              height: hei / 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ListCard(
                title: "  Sanitization",
                img_url: "Resources/images/sanitization.png",
                size: hei / 6,
                onPressed: () {},
              ),
              ListCard(
                title: "  Painting",
                img_url: "Resources/images/painter.png",
                size: hei / 6,
                onPressed: () {
                  Navigator.pushNamed(context, 'date_time',
                      arguments: {'work': 2});
                },
              ),
            ])
          ],
        ),
      ),
    ));
  }
}
