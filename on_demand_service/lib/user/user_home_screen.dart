import 'package:flutter/material.dart';
import 'package:on_demand_service/Customised/round_button.dart';
import '../Customised/list_card.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class UserHomeScreen extends StatefulWidget {
  static const String idScreen = "main";
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  double _height;
  double _width;

  String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDateTime(BuildContext context) async {
    final DateTime pickedD = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));

    if (pickedD != null) {
      setState(() {
        selectedDate = pickedD;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
      final TimeOfDay pickedT = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (pickedT != null) {
        setState(() {
          selectedTime = pickedT;
          _hour = selectedTime.hour.toString();
          if (selectedTime.hour < 10) _hour = "0" + _hour;
          _minute = selectedTime.minute.toString();
          if (selectedTime.minute < 10) _minute = "0" + _minute;
          _time = _hour + ':' + _minute + ':' + "00";
          _timeController.text = _time;
        });
        var t = selectedDate.toString().substring(0, 11) + _time;

        Navigator.pushNamed(context, 'prof_detail_screen',
            arguments: {'work': 0, 'datetime': DateTime.tryParse(t)});
      }
    }
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

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
            FittedBox(
              child: Row(
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
                  SizedBox(
                    width: wid / 25,
                  ),
                  ListCard(
                    title: "  Electrician",
                    img_url: "Resources/images/signup_img.png",
                    size: hei / 6,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: FittedBox(
                              child: Column(
                                children: [
                                  RoundedButton(
                                    colour: Colors.lightBlueAccent,
                                    title: "Select Date and Time",
                                    onPressed: () {
                                      _selectDateTime(context);
                                    },
                                  ),
                                ],
                              ),
                            ));
                          });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: hei / 30,
            ),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListCard(
                    title: "  Cooking",
                    img_url: "Resources/images/cooking.png",
                    size: hei / 6,
                    onPressed: () {
                      // _DateAndTimeState obj = new _DateAndTimeState();
                      //obj._selectDate(context);
                    },
                  ),
                  SizedBox(
                    width: wid / 25,
                  ),
                  ListCard(
                    title: "  Mechanic",
                    img_url: "Resources/images/mechanic.png",
                    size: hei / 6,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(
              height: hei / 30,
            ),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListCard(
                    title: "  Sanitization",
                    img_url: "Resources/images/sanitization.png",
                    size: hei / 6,
                    onPressed: () {
                      Navigator.pushNamed(context, 'prof_detail_screen',
                          arguments: {'work': 0});
                    },
                  ),
                  SizedBox(
                    width: wid / 25,
                  ),
                  ListCard(
                    title: "  Painting",
                    img_url: "Resources/images/painter.png",
                    size: hei / 6,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(
              height: hei / 30,
            ),
          ],
        ),
      ),
    ));
  }
}
