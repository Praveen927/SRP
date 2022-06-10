import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:http/http.dart' as http;

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

Future<List<Professional>> read(String id, DateTime datetime) async {
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
        String temp = value['work'].toString();
        datetime.subtract(const Duration(hours: 2));
        int flag = datetime.compareTo(DateTime.tryParse(value['avilability']));
        print(flag);
        if (temp.contains(id) && flag >= 0) {
          Professional ref = Professional(
              id: value['id'],
              name: value['uname'],
              phone: value['phone'],
              prof_url: value['profile_img'],
              city: value['city'],
              rate: value['rate'],
              desc: value['description']);
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
    var datetime = args['datetime'];
    var uid = args['uid'];
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
              future: read(workid.toString(), datetime),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: new Text("No Professionals"));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return userList(
                          context, snapshot.data[index], datetime, uid);
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

Widget userList(
    BuildContext context, Professional prof, DateTime datetime, uid) {
  double wid = MediaQuery.of(context).size.width;
  double hei = MediaQuery.of(context).size.height;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, 'prof_detail1_screen', arguments: {
            "prof": prof,
            "datetime": datetime.toString(),
            "uid": uid
          });
        },
        child: Card(
            elevation: hei / 200,
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
                  width: wid / 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prof.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                        Text(" " + prof.phone.substring(0, 5) + "XXXXXX"),
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
                        Text(" " + prof.city),
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
            )),
      ),
      SizedBox(
        height: hei / 75,
      )
    ],
  );
}
