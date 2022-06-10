import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:http/http.dart' as http;

class Bookings {
  String uid;
  String datetime;
  String booking_id;
  Bookings({this.uid, this.datetime, this.booking_id});
}

Future<List<Bookings>> read(String pkey) async {
  var url =
      "https://spr-project-236b2-default-rtdb.asia-southeast1.firebasedatabase.app/" +
          "data/" +
          pkey +
          "/.json";
  List<Bookings> book_list = [];
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return [];
      List<dynamic> temp = extractedData['jobs'];
      if (temp == null) return [];
      temp.forEach((element) {
        if (element != null) {
          Bookings ref = Bookings(
              uid: element['Customer Id'],
              datetime: element['Request Time'],
              booking_id: element['Booking Id']);
          book_list.add(ref);
        }
      });
    }
  } catch (error) {
    throw error;
  }
  print(book_list);
  return book_list;
}

class RequestScreen extends StatefulWidget {
  static const String idScreen = "main";
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    //print(Geolocator.getCurrentPosition());
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    var pkey = args['pkey'];
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
                  "Requests",
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Volkhov',
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            FutureBuilder<List<Bookings>>(
              future: read(pkey),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.length < 1) {
                  return Center(
                    child: new Text(
                      "No Requests",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Volkhov',
                          fontWeight: FontWeight.w300),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return userList(
                          context, snapshot.data[index], index + 1, pkey);
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

Widget userList(BuildContext context, Bookings req, ct, pkey) {
  double wid = MediaQuery.of(context).size.width;
  double hei = MediaQuery.of(context).size.height;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Card(
          elevation: hei / 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: wid / 100),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: hei / 100),
                  Text(
                    "User " + ct.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: hei / 100),
                  Text(
                    req.datetime.toString().substring(0, 10),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: hei / 100),
                  Text(
                    req.datetime.toString().substring(11, 19),
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: hei / 100),
                ],
              ),
              SizedBox(width: wid / 8),
              GestureDetector(
                onTap: () async {
                  try {
                    //updating user Orders
                    var url =
                        "https://spr-project-236b2-default-rtdb.asia-southeast1.firebasedatabase.app/user/" +
                            req.uid.toString() +
                            "/orders.json";
                    final response = await http.post(Uri.parse(url),
                        body: jsonEncode({"Booked Time": req.datetime}));

                    //updating professional booking requests
                    if (response.statusCode == 200) {
                      var purl =
                          "https://spr-project-236b2-default-rtdb.asia-southeast1.firebasedatabase.app/data/";
                      final response = await http.get(
                          Uri.parse(purl + pkey.toString() + "/jobs.json"));
                      if (response.statusCode == 200) {
                        final extractedData =
                            json.decode(response.body) as List<dynamic>;
                        if (extractedData == null) return [];
                        var lst = [];
                        extractedData.forEach((value) async {
                          if (value != null) {
                            if (value['Booking Id'] != req.booking_id) {
                              lst.add(value);
                            }
                          }
                        });
                        final res = await http.put(
                            Uri.parse(
                                "https://spr-project-236b2-default-rtdb.asia-southeast1.firebasedatabase.app/data/" +
                                    pkey.toString() +
                                    "/jobs.json"),
                            body: jsonEncode(lst));
                        Navigator.popAndPushNamed(context, 'home_screen',
                            arguments: {"pkey": pkey});
                      }
                    } else {
                      print(response.statusCode);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)),
                  child: Row(children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 20,
                    ),
                    Text(
                      " Accept",
                      style: TextStyle(fontSize: 20),
                    ),
                  ]),
                ),
              ),
              SizedBox(width: wid / 100),
              Container(
                padding: EdgeInsets.all(5),
                color: Colors.black,
                child: GestureDetector(
                  onTap: () async {
                    var purl =
                        "https://spr-project-236b2-default-rtdb.asia-southeast1.firebasedatabase.app/data/";
                    final response = await http
                        .get(Uri.parse(purl + pkey.toString() + "/jobs.json"));
                    if (response.statusCode == 200) {
                      final extractedData =
                          json.decode(response.body) as List<dynamic>;
                      if (extractedData == null) return [];
                      var lst = [];
                      extractedData.forEach((value) async {
                        if (value != null) {
                          if (value['Booking Id'] != req.booking_id) {
                            lst.add(value);
                          }
                        }
                      });
                      final res = await http.put(
                          Uri.parse(
                              "https://spr-project-236b2-default-rtdb.asia-southeast1.firebasedatabase.app/data/" +
                                  pkey.toString() +
                                  "/jobs.json"),
                          body: jsonEncode(lst));
                      Navigator.popAndPushNamed(context, 'home_screen',
                          arguments: {"pkey": pkey});
                    }
                  },
                  child: Row(children: [
                    Icon(
                      Icons.highlight_off_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                    Text(
                      " Decline",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ]),
                ),
              ),
              SizedBox(width: wid / 100),
            ],
          )),
      SizedBox(
        height: hei / 75,
      )
    ],
  );
}
