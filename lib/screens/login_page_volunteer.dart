import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:india_covid_leads/models/network_info.dart';
import 'package:india_covid_leads/models/validate.dart';
import 'package:india_covid_leads/reusable_widget/reuseablewidget.dart';
import 'package:india_covid_leads/screens/volunteer_register.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'enter_service_provider_details.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool buttonClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[200],
        title: Center(
          child: Image.asset(
            'images/kaizen.png',
            width: MediaQuery.of(context).size.width * 0.4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Hello !",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "There",
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
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            KbuildTextBox(username, 'Enter username', Icon(Icons.person), 1,
                TextInputType.name, false),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            KbuildTextBox(password, 'Enter password', Icon(Icons.vpn_key), 1,
                TextInputType.visiblePassword, true),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     TextButton(
            //         onPressed: buttonClicked == false
            //             ? () {
            //                 Navigator.push(context,
            //                     MaterialPageRoute(builder: (context) {
            //                   return ForgetUsername();
            //                 }));
            //               }
            //             : null,
            //         child: Text(
            //           'Forget Username ?',
            //           style: TextStyle(color: Colors.purple),
            //         )),
            //     TextButton(
            //         onPressed: buttonClicked == false
            //             ? () {
            //                 Navigator.push(context,
            //                     MaterialPageRoute(builder: (context) {
            //                   return ForgetPassword();
            //                 }));
            //               }
            //             : null,
            //         child: Text(
            //           'Forget Password ?',
            //           style: TextStyle(color: Colors.purple),
            //         )),
            //   ],
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
                child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: buttonClicked == false
                    ? () async {
                        final SharedPreferences sharedPreference =
                            await SharedPreferences.getInstance();

                        setState(() {
                          buttonClicked = true;
                        });



                        if (username.text == '' || password.text == '') {
                          setState(() {
                            buttonClicked = false;
                          });
                          kshowDialogue('Error',
                                  'Username or password can\'t be empty')
                              .showAlertDialoge(context);
                        } else {
                          try {
                            var sendLoginRequest =
                                await http.post(loginURI, body: {
                              "AppLoginPassword": "covidHelp",
                              "username": username.text,
                              "password": password.text
                            }).timeout(Duration(seconds: 10));

                            if (sendLoginRequest.statusCode == 200) {
                              String accessToken = await jsonDecode(
                                  sendLoginRequest.body)['access_token'];
                              String refreshToken = await jsonDecode(
                                  sendLoginRequest.body)['refresh_token'];

                              sharedPreference.setString(
                                  'access_token',
                                  jsonDecode(
                                      sendLoginRequest.body)['access_token']);
                              sharedPreference.setString(
                                  'refresh_token',
                                  jsonDecode(
                                      sendLoginRequest.body)['refresh_token']);

                              var user = await http.get(currentCustomerURI,
                                  headers: {
                                    HttpHeaders.authorizationHeader:
                                        'Bearer $accessToken'
                                  }).timeout(Duration(seconds: 10));

                              var userIs =
                                  await jsonDecode(user.body)['userName'];

                              if (user.statusCode == 200) {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                                  return ServiceProviderDetails(userIs);
                                }), (route) => false);
                              }

                              setState(() {
                                buttonClicked = false;
                              });
                            } else {
                              setState(() {
                                buttonClicked = false;
                              });
                              var content = jsonDecode(sendLoginRequest.body)['message'];
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
                            kshowDialogue('Error',
                                    'Connectivity Error, Request timeout')
                                .showAlertDialoge(context);
                            setState(() {
                              buttonClicked = false;
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
                              buttonClicked = false;
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
                              buttonClicked = false;
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
                              buttonClicked = false;
                            });
                          }
                        }
                      }
                    : null,
                child: buttonClicked == false
                    ? Text(
                        'Login',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025),
                      )
                    : CupertinoActivityIndicator(),
              ),
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Want to join us as a Volunteer ? '),
                TextButton(
                  onPressed: buttonClicked == false
                      ? () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SingUpPage();
                          }));
                        }
                      : null,
                  child: Text(
                    'Register Now !',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ForgetUsername extends StatefulWidget {
  @override
  _ForgetUsernameState createState() => _ForgetUsernameState();
}

class _ForgetUsernameState extends State<ForgetUsername> {
  TextEditingController sourcePassword = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  bool _saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFBB506),
      appBar: AppBar(
        title: Text('Recover Username'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  '* Note: Enter your registered email id, we will send you username details in your email',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                KbuildTextBox(
                    emailAddress,
                    'Enter registered email address',
                    Icon(Icons.alternate_email),
                    1,
                    TextInputType.emailAddress,
                    false),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                kbuildButton(context, 'Recover', () async {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController sourcePassword = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController username = TextEditingController();
  bool _saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFBB506),
      appBar: AppBar(
        title: Text('Recover Password'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  '* Note: Enter your registered email id and username, We will confirm and send you mail regarding your password',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                KbuildTextBox(username, 'Enter username', Icon(Icons.person), 1,
                    TextInputType.name, false),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                KbuildTextBox(
                    emailAddress,
                    'Enter registered email address',
                    Icon(Icons.alternate_email),
                    1,
                    TextInputType.emailAddress,
                    false),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                kbuildButton(context, 'Recover', () async {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
