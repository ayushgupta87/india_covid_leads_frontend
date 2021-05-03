import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:india_covid_leads/models/validate.dart';
import 'package:india_covid_leads/reusable_widget/reuseablewidget.dart';
import 'package:india_covid_leads/screens/card_view_leads.dart';
import 'package:india_covid_leads/screens/disclaimer.dart';
import 'package:india_covid_leads/screens/enter_service_provider_details.dart';
import 'package:india_covid_leads/screens/login_page_volunteer.dart';
import 'package:india_covid_leads/screens/side_bar.dart';
import 'package:http/http.dart' as http;
import 'package:india_covid_leads/models/network_info.dart';
import 'package:india_covid_leads/screens/volunteer_register.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return HomePage();
      }), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff27272E),
      body: Column(
        children: [
          SafeArea(
            child: Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Text(
                    'K',
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'aizen Innovations',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 20),
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  ' ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.11),
                ),
                Text('CoviRescue',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.11)),
                Text(' ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.11)),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.04,
                ),
                Text(
                  'Leads for resources needed\nto fight Covid19',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 1,
                      letterSpacing: 4),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: SpinKitThreeBounce(
                      size: MediaQuery.of(context).size.width * 0.08,
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index.isEven ? Colors.white60 : Colors.green,
                          ),
                        );
                      }),
                ),
              ],
            ),
          )),
          Expanded(
              child: Align(
            alignment: Alignment.bottomLeft,
            child: Stack(
              children: [
                Positioned.fill(
                  left: -150,
                  bottom: -100,
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      'images/covid.png',
                      height: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  TextEditingController city = TextEditingController();
  TextEditingController category = TextEditingController();

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
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.09,
        child: ElevatedButton(
          child: Text('Disclaimer, App Sponsors', style: TextStyle(
            letterSpacing: 3,
          ),),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return AppDetails();
            }));
          },
        ),
      ),
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
      drawerScrimColor: Colors.black12,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                'Select City And Service',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold),
              ),
              KbuildDropDown(
                  city, 'Select City', cities, Icon(Icons.location_on)),
              KbuildDropDown(
                  category, 'Select Service', service, Icon(Icons.category)),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              kbuildButton(context, 'Search leads', () {
                if (city.text == '' || category.text == '') {
                  kshowDialogue('Error', 'Select one option from dropdown')
                      .showAlertDialoge(context);
                } else {
                  print(city.text);
                  print(category.text);

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LeadsScreen(city.text, category.text);
                  }));
                }
              }),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
              ),
              Divider(
                thickness: 3,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              Text(
                'Join Us as a Volunteer or Login to post leads',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
              ),
              kbuildButton(context, 'Volunteer Login', () async {
                setState(() {
                  _saving = true;
                });

                String access_token_is = await Validate();

                if (access_token_is != null) {
                  var user = await http.get(currentCustomerURI, headers: {
                    HttpHeaders.authorizationHeader: 'Bearer $access_token_is'
                  }).timeout(Duration(seconds: 10));

                  var userIs = await jsonDecode(user.body)['userName'];

                  if (user.statusCode == 200) {
                    setState(() {
                      _saving = false;
                    });
                    Fluttertoast.showToast(
                        msg: "Welcome back ! $userIs",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 10,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return ServiceProviderDetails(userIs);
                    }), (route) => false);
                  } else {
                    setState(() {
                      _saving = false;
                    });
                    Fluttertoast.showToast(
                        msg: "Login Required",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 10,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } else {
                  setState(() {
                    _saving = false;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                }
              }),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
              ),
              kbuildButton(context, 'Volunteer Register', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SingUpPage();
                }));
              }),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
