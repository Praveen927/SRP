import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  ListCard(
      {@required this.title,
      @required this.size,
      @required this.img_url,
      @required this.onPressed});
  final String title;
  final double size;
  final String img_url;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: wid / 2.5,
        padding: EdgeInsets.all(wid / 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 53, 53, 53),
                offset: Offset(2, 2),
                blurRadius: 5)
          ],
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: Colors.white, width: wid / 200),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image(image: AssetImage(img_url), height: size),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 0.5,
                  fontFamily: 'Volkhov',
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
