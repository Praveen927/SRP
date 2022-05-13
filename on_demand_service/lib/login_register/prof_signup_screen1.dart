import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:getwidget/getwidget.dart';
import '../Customised/round_button.dart';

//code for designing the UI of our text field where the user writes his email id or password

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
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
            "data.json";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "uname": uname,
          "name": name,
          "phone": phone,
          "work": work,
          "city": city,
          "email": email,
          "profile_img": _uploadedFileURL
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
                Text(
                  "  Username",
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
                  key: _unameKey,
                  child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter Username";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        uname = value;
                        //Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter Your Username',
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Text(
                  "  Full Name",
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
                  key: _nameKey,
                  child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter Name";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        name = value;
                        //Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter Your Full Name',
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Text(
                  "  Phone",
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
                  key: _phoneKey,
                  child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter Phone Number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        phone = value;
                        //Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter Your Phone Number',
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Text(
                  "  City",
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
                  key: _cityKey,
                  child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter City";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        city = value;
                        //ci something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter Your City',
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
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
                RoundedButton(
                    colour: Colors.lightBlueAccent,
                    title: 'Register',
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });

                      try {
                        if (!_unameKey.currentState.validate()) {
                        } else if (!_nameKey.currentState.validate()) {
                        } else if (!_phoneKey.currentState.validate()) {
                        } else if (!_cityKey.currentState.validate()) {
                        } else {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);

                          await writeData();
                          if (newUser != null) {
                            Navigator.pushNamed(
                              context,
                              'home_screen',
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

