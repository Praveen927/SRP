import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:http/http.dart' as http;

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Professional {
  String name;
  String phone;
  String city;
  String prof_url;
  String id;
  String rate;
  String desc;
  String dis;
  Professional(
      {this.id,
      this.name,
      this.phone,
      this.prof_url,
      this.city,
      this.desc,
      this.rate,
      this.dis});
}

Future<List<Professional>> read(lat, long) async {
  var url =
      "https://spr-project-236b2-default-rtdb.asia-southeast1.firebasedatabase.app/" +
          "data.json";
  List<Professional> prof_list = [];
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return [];
      extractedData.forEach((key, value) {
        var temp = value['gps'];
        if ((temp['lat'] - lat).abs() < 30 &&
            (temp['long'] - long).abs() < 30) {
          Professional ref = Professional(
              id: value['id'],
              name: value['uname'],
              phone: value['phone'],
              prof_url: value['profile_img'],
              city: value['city'],
              rate: value['rate'],
              desc: value['description'],
              dis: (temp['lat'] * 111 / 1000).toString().substring(0, 4));
          prof_list.add(ref);
        }
      });
    }
  } catch (error) {
    throw error;
  }

  return prof_list;
}

class EmerProfDetailScreen extends StatefulWidget {
  static const String idScreen = "main";
  @override
  _EmerProfDetailScreenState createState() => _EmerProfDetailScreenState();
}

class _EmerProfDetailScreenState extends State<EmerProfDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    var lat = args['lat'];
    var long = args['long'];
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: wid / 20, vertical: hei / 10),
        child: Column(
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
                  "Professionals",
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Volkhov',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            FutureBuilder<List<Professional>>(
              future: read(lat, long),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: new Text("No Professionals Nearby"));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return userList(context, snapshot.data[index]);
                    },
                  );
                } else if (snapshot.hasError) {
                  return new Text("${snapshot.error}");
                }
                return new CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    ));
  }
}

Widget userList(BuildContext context, Professional prof) {
  double wid = MediaQuery.of(context).size.width;
  double hei = MediaQuery.of(context).size.height;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () async {
          try {
            print(prof.phone);
            await FlutterPhoneDirectCaller.callNumber(prof.phone.toString());
          } catch (e) {
            print(e);
          }
        },
        child: Card(
            elevation: hei / 200,
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  prof.prof_url != null
                      ? Image(
                          image: NetworkImage(prof.prof_url),
                          height: hei / 10,
                          width: wid / 5.5,
                          fit: BoxFit.fill,
                        )
                      : Container(
                          color: Color.fromARGB(255, 195, 193, 193),
                          height: hei / 10,
                          width: wid / 5.5,
                          child: Icon(
                            Icons.photo,
                            color: Colors.white,
                            size: hei / 25,
                          )),
                  SizedBox(
                    width: wid / 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prof.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: hei / 100,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: hei / 60,
                          ),
                          Text(" " + prof.phone.substring(0, 5) + "XXX"),
                        ],
                      ),
                      SizedBox(
                        height: hei / 150,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: hei / 60,
                          ),
                          Text(" " + prof.dis + " km"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: wid / 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.rate_review,
                        size: hei / 60,
                      ),
                      Text(" 4.5"),
                    ],
                  ),
                  SizedBox(
                    width: wid / 20,
                  )
                ],
              ),
            )),
      ),
      SizedBox(
        height: hei / 75,
      )
    ],
  );
}
