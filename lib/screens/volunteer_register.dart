import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:india_covid_leads/models/network_info.dart';
import 'package:india_covid_leads/reusable_widget/reuseablewidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SingUpPage extends StatefulWidget {
  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  bool _saving = false;
  bool status = true;
  var index;

  TextEditingController volunteer_name = TextEditingController();
  TextEditingController volunteer_username = TextEditingController();
  TextEditingController volunteer_contact = TextEditingController();
  TextEditingController volunteer_emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
  String keep_private;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[200],
        title: Center(
          child: Image.asset(
            'images/kaizen.png',
            width: MediaQuery.of(context).size.width * 0.3,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    "Create",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Account",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        ".",
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: MediaQuery.of(context).size.height * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                KbuildTextBox(volunteer_name, 'Enter your name',
                    Icon(Icons.person), 1, TextInputType.name, false),
                KbuildTextBox(volunteer_username, 'Enter username',
                    Icon(Icons.person), 1, TextInputType.name, false),
                KbuildTextBox(volunteer_contact, 'Enter your contact number',
                    Icon(Icons.phone), 1, TextInputType.number, false),
                KbuildTextBox(
                    volunteer_emailAddress,
                    'Enter your email address',
                    Icon(Icons.alternate_email),
                    1,
                    TextInputType.emailAddress,
                    false),
                KbuildTextBox(password, 'Enter password', Icon(Icons.vpn_key),
                    1, TextInputType.visiblePassword, false),
                KbuildTextBox(
                    confirm_password,
                    'Enter confirm password',
                    Icon(Icons.vpn_key_outlined),
                    1,
                    TextInputType.visiblePassword,
                    false),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Keep Details private ? ',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    Container(
                      child: FlutterSwitch(
                        activeText: "Private",
                        inactiveText: "Public",
                        width: MediaQuery.of(context).size.width * 0.22,
                        height: MediaQuery.of(context).size.width * 0.08,
                        valueFontSize: MediaQuery.of(context).size.width * 0.035,
                        toggleSize: 20.0,
                        value: status,
                        borderRadius: 30.0,
                        padding: 8.0,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            status = val;
                            if (val == false) {
                              index = 0;
                            } else {
                              index = 1;
                            }
                            print('keep private $index');

                            setState(() {
                              keep_private = index.toString();
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Center(
                    child: kbuildButton(context, 'Register', () async {
                  setState(() {
                    _saving = true;
                  });

                  try {
                    if (keep_private == null) {
                      keep_private = '1';
                    }

                    var registerNewVolunteer =
                        await http.post(volunteerRegistrationURI, body: {
                      "AppLoginPassword": "covidApp",
                      "volunteer_name": volunteer_name.text,
                      "volunteer_username": volunteer_username.text,
                      "volunteer_contact": volunteer_contact.text,
                      "volunteer_emailAddress": volunteer_emailAddress.text,
                      "password": password.text,
                      "confirm_password": confirm_password.text,
                      "keep_private": keep_private.toString()
                    }).timeout(Duration(seconds: 10));

                    var content =
                        await jsonDecode(registerNewVolunteer.body)['message'];

                    if (registerNewVolunteer.statusCode == 200) {
                      setState(() {
                        _saving = false;
                      });
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: content.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 10,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      setState(() {
                        _saving = false;
                      });
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: content.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 10,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  } on TimeoutException catch (e) {
                    print('Socket Exception $e');
                    kshowDialogue(
                            'Error', 'Connectivity Error, Request timeout')
                        .showAlertDialoge(context);
                    setState(() {
                      _saving = false;
                    });
                  } on SocketException catch (e) {
                    print('Socket Exception $e');
                    Fluttertoast.showToast(
                        msg: "Connectivity Error",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 10,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {
                      _saving = false;
                    });
                  } on IOException catch (e) {
                    print('Socket Exception $e');
                    Fluttertoast.showToast(
                        msg: "Connectivity Error",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 10,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {
                      _saving = false;
                    });
                  } catch (e) {
                    print('Socket Exception $e');
                    Fluttertoast.showToast(
                        msg: "Something went wrong",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 10,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {
                      _saving = false;
                    });
                  }
                })),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ]),
        ),
      ),
    );
  }
}

// if (index == 0){
// index = 1;
// } else {
// index = 0;
// }

// print('keep private $index');
//
// setState(() {
// keep_private=index.toString();
// });
