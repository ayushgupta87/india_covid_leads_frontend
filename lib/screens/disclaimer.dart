import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:india_covid_leads/models/network_info.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDetails extends StatefulWidget {
  @override
  _AppDetailsState createState() => _AppDetailsState();
}

class _AppDetailsState extends State<AppDetails> {
  void _launchEmail(String emailId) async {
    var urlEmail =
        "mailto:$emailId?subject=Message is regarding CoviRescue App";
    await launch(urlEmail);
  }

  List<Sponsor> listItems = [];
  bool _saving = true;

  Future<List<Sponsor>> getAllItems() async {
    var allSponsor = await http.get(allSonsorsURI);

    if (allSponsor.statusCode != 200) {
      var content = await jsonDecode(allSponsor.body)['message'];
      Fluttertoast.showToast(
          msg: content.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 18.0);
    }

    if (allSponsor.statusCode == 200) {
      var jsonData = jsonDecode(allSponsor.body)['sponsors'];
      if (jsonData == null) {
        return null;
      }

      for (var item in jsonData) {
        Sponsor sponsor = Sponsor(item['name'], item['image']);
        listItems.add(sponsor);
      }
      return listItems;
    }
  }

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
          gravity: ToastGravity.CENTER,
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
          gravity: ToastGravity.CENTER,
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
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              'Disclaimer',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.1),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'The user understands that the data provided on this app platform is collected and verified by volunteers to the best of their ability. However we sincerely request the users to verify and confirm the identity of any service provider. Any financial, purchase or commercial deal must be done by the user is his/her ability to judge the information, Kaizen is not liable or responsible for any loss or damage of any kind (direct/indirect/consequential or otherwise). Don\'t misuse this platform by providing false information, if we fiund anything not related to CoviRescue we will remove that information. User must understand that the real-time verification of the data is neither a responsibility, nor a legality of the Kaizen Innovations in any manner whatsoever.',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Tell us if this platform helped you, or any feature we should add ! We will love to hear from you :)',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                onPressed: () {
                  _launchEmail('kaizenandinnovations@gmail.com');
                },
                child: Text('Email Us')),
            SizedBox(
              height: 20,
            ),
            Text(
              'List of CoviRescue App Sponsors',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
            Text(
              '(We thanks our sponsors.. this amount will be used in maintaining the App servers)',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, i) {
                  Uint8List _base64_image = base64.decode(listItems[i].image);
                  return Card(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              listItems[i].name,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.memory(_base64_image) is FormatException ||
                                    listItems[i].image == 'NONE' ||
                                    listItems[i].image == ''
                                ? Image.asset(
                                    'images/kaizen.png',
                                    width: MediaQuery.of(context).size.width *
                                        0.4,
                                  )
                                : Image.memory(
                                    _base64_image,
                                    width: MediaQuery.of(context).size.width *
                                        0.4,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Sponsor {
  final String name;
  final String image;

  Sponsor(
    this.name,
    this.image,
  );
}
