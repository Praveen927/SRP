import 'dart:convert';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../Customised/round_button.dart';

import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class Professional {
  String name;
  String phone;
  String city;
  String prof_url;
  String id;
  String rate;
  String desc;
  Professional(
      {this.id,
      this.name,
      this.phone,
      this.prof_url,
      this.city,
      this.desc,
      this.rate});
}

class ProfDetail1Screen extends StatefulWidget {
  @override
  _ProfDetail1ScreenState createState() => _ProfDetail1ScreenState();
}

class _ProfDetail1ScreenState extends State<ProfDetail1Screen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    var prof = args['prof'];
    var datetime = args['datetime'];
    Professional professional = Professional(
        id: prof.id,
        name: prof.name,
        phone: prof.phone,
        city: prof.city,
        prof_url: prof.prof_url,
        rate: prof.rate,
        desc: prof.desc);
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(
      alignment: Alignment.topCenter,
      children: [
        SingleChildScrollView(
            child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: wid / 20, vertical: hei / 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: wid / 15,
                )),
            SizedBox(
              height: hei / 40,
            ),
            Center(
              child: prof.prof_url != null
                  ? Image(
                      image: NetworkImage(prof.prof_url),
                      height: hei / 6,
                      width: wid / 4,
                      fit: BoxFit.fill,
                    )
                  : Container(
                      color: Color.fromARGB(255, 195, 193, 193),
                      height: hei / 7.5,
                      width: wid / 5.5,
                      child: Icon(
                        Icons.photo,
                        color: Colors.white,
                        size: hei / 25,
                      )),
            ),
            SizedBox(
              height: hei / 20,
            ),
            Text(
              professional.name,
              style: TextStyle(
                  fontSize: 35,
                  fontFamily: 'Volkhov',
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: hei / 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.black54,
                      size: wid / 22,
                    ),
                    Text(
                      professional.city,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Text(
                  "\₹" + professional.rate.toString() + "/hour",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: hei / 30,
            ),
            Text(
              "Bio",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Volkhov',
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: hei / 100,
            ),
            Text(
              professional.desc.toString(),
              textAlign: TextAlign.justify,
              style: TextStyle(
                wordSpacing: 1.5,
                color: Colors.black54,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: hei / 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Experience",
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Volkhov',
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: hei / 100,
                    ),
                    Text(
                      "5 Years",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: hei / 40,
                    ),
                    Text(
                      "Total Projects",
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Volkhov',
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: hei / 100,
                    ),
                    Text(
                      "353 ",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: hei / 20,
                      color: Colors.amber,
                    ),
                    Text(
                      " 4.5",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ]),
        )),
        Column(
          children: [
            SizedBox(
              height: hei / 1.15,
            ),
            RoundedButton(
              colour: Colors.blueAccent,
              title: "Book Now",
              onPressed: () async {
                try {
                  var url =
                      "https://spr-project-236b2-default-rtdb.asia-southeast1.firebasedatabase.app/data";
                  final response = await http.get(Uri.parse(url + ".json"));
                  if (response.statusCode == 200) {
                    final extractedData =
                        json.decode(response.body) as Map<String, dynamic>;
                    if (extractedData == null) return [];
                    extractedData.forEach((key, value) async {
                      if (value['id'].toString().contains(professional.id)) {
                        List<Object> wrks;
                        try {
                          wrks = value['jobs'];
                          if (wrks == null) {
                            wrks = [
                              {
                                "Booked Time": DateTime.now().toString(),
                                "Request Time": datetime.toString()
                              }
                            ];
                          } else {
                            wrks.add({
                              "Booked Time": DateTime.now().toString(),
                              "Request Time": datetime.toString()
                            });
                          }
                          var newurl =
                              url + "/" + key.toString() + "/jobs.json";

                          final response = await http.put(Uri.parse(newurl),
                              body: jsonEncode(wrks));
                        } catch (e) {
                          print(e);
                        }
                      }
                    });
                  }
                } catch (e) {}
              },
            ),
          ],
        )
      ],
    ));
  }
}
