import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:india_covid_leads/main.dart';
import 'package:india_covid_leads/models/network_info.dart';
import 'package:india_covid_leads/models/validate.dart';
import 'package:india_covid_leads/reusable_widget/reuseablewidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_switch/flutter_switch.dart';


class ServiceProviderDetails extends StatefulWidget {
  String user;
  ServiceProviderDetails(this.user);
  @override
  _ServiceProviderDetailsState createState() => _ServiceProviderDetailsState();
}

class _ServiceProviderDetailsState extends State<ServiceProviderDetails> {

  bool status = true;
  var index;
  bool _saving = true;


  List<String> cities = [];
  List<String> service = [];

  Future<List<String>> getAllItems() async {
    var getAllCities = await http.get(getAllCitiesURI);

    var getAllServices = await http.get(getAllServicesURI);

    if (getAllCities.statusCode == 200) ;
    var citiesdata = jsonDecode(getAllCities.body);

    if (getAllServices.statusCode == 200) ;
    var servicesdata = jsonDecode(getAllServices.body);

    for (var item in citiesdata) {
      cities.add(item['indiaCitiesStates']);
    }

    for (var item in servicesdata) {
      service.add(item['serviceCategory']);
    }
  }

  TextEditingController provider_contact = TextEditingController();
  TextEditingController provider_name = TextEditingController();
  TextEditingController last_verified_date = TextEditingController();
  TextEditingController last_verified_time = TextEditingController();
  TextEditingController last_verified_time1 = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController url = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllItems().whenComplete(() {
      setState(() {
        _saving = false;
      });
    }).catchError((SocketException) {
      setState(() {
        _saving = false;
      });
      Fluttertoast.showToast(
          msg: 'Connectivity Error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((IOException) {
      setState(() {
        _saving = false;
      });
      Fluttertoast.showToast(
          msg: 'Connectivity Error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
                child: Icon(FontAwesomeIcons.signOutAlt),
                onTap: () async{
                  SharedPreferences sharedpreference =
                  await SharedPreferences.getInstance();
                  await sharedpreference.remove('access_token');
                  await sharedpreference.remove('refresh_token');
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }), (route) => false);

                }),
          ),
        ],

      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Welcome back, ${widget.user}!',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                              return HomePage();
                            }), (route) => false);
                      },
                      child: Text(
                        'Home',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  'Enter Details of service provider',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  'Wrong and irrelevant details will be removed soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  'Please don\'t misuse this platform as these information will help many patients to recover',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              KbuildDropDown(
                  city, 'Select City', cities, Icon(Icons.location_on)),
              KbuildDropDown(
                  category, 'Select Service', service, Icon(Icons.category)),
              KbuildTextBox(
                  provider_contact,
                  'Enter service provider contact number',
                  Icon(Icons.phone),
                  1,
                  TextInputType.number,
                  false),
              KbuildTextBox(provider_name, 'Enter service provider name',
                  Icon(Icons.person), 1, TextInputType.name, false),
              KbuildTextBox(qty, 'Enter count if any',
                  Icon(Icons.question_answer), 1, TextInputType.number, false),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueGrey),
                  ),
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            var inputFormatYear = DateFormat('yyyy');
                            var todaysYear =
                                inputFormatYear.format(DateTime.now());
                            print(int.parse(todaysYear.toString()));

                            var inputFormatMonth = DateFormat('MM');
                            var todaysMonth =
                                inputFormatMonth.format(DateTime.now());
                            print(int.parse(todaysMonth.toString()));

                            var inputFormatDate = DateFormat('dd');
                            var todaysDate =
                                inputFormatDate.format(DateTime.now());
                            print(int.parse(todaysDate.toString()));

                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2021, 1, 1),
                                maxTime: DateTime(
                                    int.parse(todaysYear.toString()),
                                    int.parse(todaysMonth.toString()),
                                    int.parse(todaysDate.toString())),
                                onChanged: (date) {}, onConfirm: (date) {
                              var inputFormat = DateFormat('yyyy-MM-dd');
                              var finalDate = inputFormat.format(date);
                              print('confirm ${finalDate}');

                              setState(() {
                                last_verified_date.text = finalDate.toString();
                              });
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Text(
                            'Select last confirmed date',
                            style: TextStyle(color: Colors.blue),
                          )),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 20, left: 20, top: 20),
                        child: TextField(
                          enabled: false,
                          maxLines: 1,
                          controller: last_verified_date,
                          decoration: InputDecoration(
                            icon: Icon(Icons.date_range),
                            labelText: 'Select last verified date',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      TextButton(onPressed: (){
                        last_verified_date.clear();
                      }, child: Text('Clear')),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueGrey),
                  ),
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            var inputFormatYear = DateFormat('HH');
                            var todaysYear =
                            inputFormatYear.format(DateTime.now());
                            print(int.parse(todaysYear.toString()));

                            var inputFormatMonth = DateFormat('mm');
                            var todaysMonth =
                            inputFormatMonth.format(DateTime.now());
                            print(int.parse(todaysMonth.toString()));


                            DatePicker.showTimePicker(context, showTitleActions: true,
                                onConfirm: (date) {

                                  var inputFormat = DateFormat('HH-mm');
                                  var finalTime = inputFormat.format(date);

                                  setState(() {
                                    last_verified_time1.text='${finalTime.toString()} , HH - MM';
                                    last_verified_time.text=finalTime.toString();
                                  });


                                }, currentTime: DateTime.now());
                          },
                          child: Text(
                            'Select last confirmed time',
                            style: TextStyle(color: Colors.blue),
                          )),
                      Padding(
                        padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                        child: TextField(
                          enabled: false,
                          maxLines: 1,
                          controller: last_verified_time1,
                          decoration: InputDecoration(
                            icon: Icon(Icons.access_time),
                            labelText: 'Select last verified time',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      TextButton(onPressed: (){
                        last_verified_time1.clear();
                      }, child: Text('Clear')),
                    ],
                  ),
                ),
              ),

              KbuildTextBox(url, 'Enter any imp URL',
                  Icon(Icons.web), 1, TextInputType.url, false),
              SizedBox(height: 50,),
              kbuildButton(context, 'Share', ()async{


                if (city.text == ''){
                  kshowDialogue('Error', 'Enter City').showAlertDialoge(context);
                } else if (category.text == ''){
                  kshowDialogue('Error', 'Enter Category').showAlertDialoge(context);
                }  else {

                  setState(() {
                    _saving=true;
                  });
                  try {
                    String access_token = await Validate();

                    if (access_token != null) {
                      var sendLeadDetails = await http.post(newLeadURI, body: {
                        "provider_contact_number": provider_contact.text,
                        "provider_name": provider_name.text,
                        "last_verified_date": last_verified_date.text,
                        "last_verified_time": last_verified_time.text,
                        "city": city.text,
                        "qty": qty.text,
                        "category": category.text,
                        "important_link": url.text
                      },
                          headers: {
                            HttpHeaders
                                .authorizationHeader: 'Bearer $access_token'
                          }).timeout(Duration(seconds: 10));

                      var content = await jsonDecode(sendLeadDetails
                          .body)['message'];

                      if (sendLeadDetails.statusCode == 200) {
                        setState(() {
                          _saving = false;
                          provider_contact.clear();
                          provider_name.clear();
                          last_verified_time.clear();
                          last_verified_time1.clear();
                          last_verified_date.clear();
                          city.clear();
                          qty.clear();
                          category.clear();
                          url.clear();
                        });
                        Fluttertoast.showToast(
                            msg: content.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 6,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        setState(() {
                          _saving = false;
                        });
                        Fluttertoast.showToast(
                            msg: content.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 6,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    } else {
                      setState(() {
                        _saving = false;
                      });
                      Fluttertoast.showToast(
                          msg: 'Login required',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 6,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }), (route) => false);
                    }
                  }  on TimeoutException catch (e) {
                    print('Socket Exception $e');
                    kshowDialogue('Error',
                        'Connectivity Error, Request timeout')
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
                }

              }),
              SizedBox(height: 300,),

            ],
          ),
        ),
      ),
    );
  }
}
