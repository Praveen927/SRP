import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:http/http.dart' as http;

class Professional {
  String name;
  String phone;
  String city;
  String prof_url;
  Professional({this.name, this.phone, this.prof_url, this.city});
}

Future<List<Professional>> read(String id) async {
  var url =
      "https://spr-project-236b2-default-rtdb.asia-southeast1.firebasedatabase.app/" +
          "data.json";
  List<Professional> prof_list = [];
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((key, value) {
        String temp = value['work'].toString();
        if (temp.contains(id)) {
          Professional ref = Professional(
              name: value['uname'],
              phone: value['phone'],
              prof_url: value['profile_img'],
              city: value['city']);
          prof_list.add(ref);
        }
      });
    }
  } catch (error) {
    throw error;
  }

  return prof_list;
}

class ProfDetailScreen extends StatefulWidget {
  static const String idScreen = "main";
  @override
  _ProfDetailScreenState createState() => _ProfDetailScreenState();
}

class _ProfDetailScreenState extends State<ProfDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    var workid = args['work'];
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Professional>>(
        future: read(workid.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
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
    ));
  }
}

Widget userList(BuildContext context, Professional prof) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      color: Color.fromARGB(143, 173, 202, 210),
    ),
    width: double.infinity,
    height: 120,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Container(
              width: 70,
              height: 70,
              margin: EdgeInsets.only(right: 15),
              child: Image(image: NetworkImage(prof.prof_url))),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                prof.name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(prof.city,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                          letterSpacing: .3)),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.call,
                    color: Colors.blue,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(prof.phone,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          letterSpacing: .3)),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
