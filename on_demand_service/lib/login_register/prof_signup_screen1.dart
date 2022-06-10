import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:getwidget/getwidget.dart';
import '../Customised/round_button.dart';

import 'package:geolocator/geolocator.dart';

//code for designing the UI of our text field where the user writes his email id or password

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class ProfRegistrationScreen1 extends StatefulWidget {
  @override
  _ProfRegistrationScreen1State createState() =>
      _ProfRegistrationScreen1State();
}

class _ProfRegistrationScreen1State extends State<ProfRegistrationScreen1> {
  var email;
  var password;
  final _auth = FirebaseAuth.instance;
  String uname;
  String name;
  var phone;
  var work;
  var desc;
  var gps;
  var rate = "100";
  String city;
  List<String> dropList = ["Plumber", "Electrician", "Mechanic"];
  bool showSpinner = false;
  final _unameKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  final _phoneKey = GlobalKey<FormState>();
  final _cityKey = GlobalKey<FormState>();
  var _uploadedFileURL;

  void writeData() async {
    var url =
        "https://spr-project-236b2-default-rtdb.asia-southeast1.firebasedatabase.app/" +
            "data/.json";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "id": uname.substring(0, 4) + phone.toString(),
          "uname": uname,
          "name": name,
          "phone": phone,
          "work": work,
          "city": city,
          "email": email,
          "profile_img": _uploadedFileURL,
          "description": desc,
          "rate": rate,
          "avilability": DateTime.now().toString(),
          "gps": gps,
        }),
      );
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    email = args['email'];
    password = args['pass'];
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: wid / 15, vertical: hei / 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Professional Registration",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 5.0,
                      fontSize: 45,
                      fontFamily: 'Volkhov',
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: hei / 25),
                GestureDetector(
                  onTap: () async {
                    await ImagePicker.pickImage(source: ImageSource.gallery)
                        .then((_image) async {
                      FirebaseStorage storage = FirebaseStorage.instance;
                      Reference ref = storage
                          .ref()
                          .child("images/" + DateTime.now().toString());
                      UploadTask uploadTask = ref.putFile(File(_image.path));
                      uploadTask.whenComplete(() {
                        ref.getDownloadURL().then((value) {
                          setState(() {
                            _uploadedFileURL = value;
                          });
                        });
                      });
                    });
                  },
                  child: Container(
                    height: hei / 8,
                    child: _uploadedFileURL != null
                        ? Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(
                                        _uploadedFileURL.toString()))),
                          )
                        : CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 55, 183, 243),
                            foregroundColor: Colors.white,
                            minRadius: hei / 20,
                            child: Icon(
                              Icons.add_a_photo,
                              size: hei / 25,
                            )),
                  ),
                ),
                SizedBox(height: hei / 25),
                Field(
                  title: "Username",
                  hinttxt: "Enter Username",
                  keyV: _unameKey,
                  onChanged: (value) {
                    uname = value;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Field(
                  title: "Full Name",
                  hinttxt: "Enter your full name",
                  keyV: _nameKey,
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Field(
                  title: "Phone",
                  keyV: _phoneKey,
                  hinttxt: "Enter your phone number",
                  onChanged: (value) {
                    phone = value;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Field(
                  title: "City",
                  keyV: _cityKey,
                  hinttxt: "Enter your city",
                  onChanged: (value) {
                    city = value;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Text(
                  " Job",
                  style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 20,
                      fontFamily: 'Volkhov',
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 200,
                ),
                GFMultiSelect(
                  items: dropList,
                  onSelect: (value) {
                    work = value;
                  },
                  dropdownTitleTileText: 'Select Your Work',
                  dropdownTitleTileMargin: EdgeInsets.symmetric(
                      horizontal: wid / 20, vertical: hei / 200),
                  dropdownTitleTilePadding: EdgeInsets.all(wid / 35),
                  dropdownUnderlineBorder:
                      const BorderSide(color: Colors.transparent, width: 2),
                  dropdownTitleTileBorder:
                      Border.all(color: Colors.grey[300], width: 1),
                  dropdownTitleTileBorderRadius: BorderRadius.circular(5),
                  expandedIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black54,
                  ),
                  collapsedIcon: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.black54,
                  ),
                  submitButton: Text('OK'),
                  cancelButton: Text('Cancel'),
                  dropdownTitleTileTextStyle:
                      const TextStyle(fontSize: 14, color: Colors.black54),
                  padding: EdgeInsets.all(wid / 50),
                  margin: EdgeInsets.all(wid / 120),
                  type: GFCheckboxType.basic,
                  activeBgColor: GFColors.SUCCESS,
                  activeBorderColor: GFColors.SUCCESS,
                  inactiveBorderColor: Colors.grey[300],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Field(
                  title: "Rate",
                  hinttxt: "Enter Charge per hour",
                  onChanged: (value) {
                    rate = value;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Text(
                  "Decription",
                  style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 20,
                      fontFamily: 'Volkhov',
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 200,
                ),
                Form(
                  child: TextFormField(
                      maxLines: 8,
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        desc = value;
                        //ci something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '\n\n\nMention detail about your job',
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                RoundedButton(
                    colour: Colors.lightBlueAccent,
                    title: 'Register',
                    onPressed: () async {
                      try {
                        if (!_unameKey.currentState.validate()) {
                        } else if (!_nameKey.currentState.validate()) {
                        } else if (!_phoneKey.currentState.validate()) {
                        } else if (!_cityKey.currentState.validate()) {
                        } else {
                          setState(() {
                            showSpinner = true;
                          });
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);

                          Position position = await Geolocator()
                              .getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high);
                          gps = {
                            "lat": position.latitude,
                            "long": position.longitude
                          };
                          await writeData();

                          if (newUser != null) {
                            Fluttertoast.showToast(
                                msg:
                                    'Registration Successful. \nLogin to continue',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black45,
                                textColor: Colors.white);
                            sleep(Duration(seconds: 2));
                            Navigator.popAndPushNamed(
                              context,
                              'prof_login_screen',
                            );
                          }
                        }
                      } catch (e) {
                        //print("Wrong Userid or Password");
                        print(e);

                        setState(() {
                          showSpinner = false;
                        });
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Used only if you need a single picture
class Field extends StatelessWidget {
  var title;
  var hinttxt;
  var keyV;
  Function onChanged;
  Field({this.title, this.hinttxt, this.keyV, this.onChanged});
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FlexColumnWidth(1.8),
        1: FlexColumnWidth(4),
      },
      children: [
        TableRow(children: [
          Text(
            title,
            style: TextStyle(
                letterSpacing: 0.5,
                fontSize: 20,
                fontFamily: 'Volkhov',
                fontWeight: FontWeight.w500),
          ),
          Container(
            width: wid / 1.7,
            height: hei / 20,
            child: Form(
              key: keyV,
              child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Invalid Input";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    onChanged(value);
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: hinttxt,
                  )),
            ),
          )
        ])
      ],
    );
  }
}
