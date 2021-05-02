import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:india_covid_leads/models/network_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadsScreen extends StatefulWidget {
  final String city;
  final String service;
  LeadsScreen(this.city, this.service);
  @override
  _LeadsScreenState createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  void _launchCaller(String number) async {
    var url = "tel:${number.toString()}";
    await launch(url);
  }

  void _launchUrl(String Url) async {
    launch(Url);
  }

  bool _button = true;
  bool _tap = false;

  List<AllLeads> listItems = [];
  int page = 1;
  bool _saving = true;

  Future<List<AllLeads>> getAllItems() async {
    print('Page is $page');

    var allLeads =
        await http.get(getAllByCategory(widget.service, widget.city, '$page'));

    if (jsonDecode(allLeads.body)['message'] == 'End of List') {
      Fluttertoast.showToast(
          msg: "No more items to load",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 18.0);
    }

    if (allLeads.statusCode != 200) {
      var content = await jsonDecode(allLeads.body)['message'];
      Fluttertoast.showToast(
          msg: content.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 18.0);
    }

    if (allLeads.statusCode == 200) {
      var jsonData = jsonDecode(allLeads.body)['leads'];
      if (jsonData == null) {
        return null;
      }

      for (var item in jsonData) {
        AllLeads allLeads = AllLeads(
            item['id'],
            item['providerContact'],
            item['providerName'],
            item['lastVerifiedDate'],
            item['lastVerifiedTime'],
            item['qty'],
            item['providerCity'],
            item['serviceCategory'],
            item['importantLink'],
            item['verificationBy']);
        listItems.add(allLeads);
      }
      page++;
      return listItems;
    }
  }

  fetchData() async {
    await getAllItems().whenComplete(() {
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
  void initState() {
    super.initState();
    fetchData().catchError((SocketException) {
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
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              '${widget.city} > ${widget.service}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listItems.length + 1,
                itemBuilder: (context, i) {
                  if (i == listItems.length) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 50, right: 50, bottom: 60),
                      child: SizedBox(
                        width: 200,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: _button == false
                                ? null
                                : () {
                                    setState(() {
                                      _button = false;
                                      _tap = true;
                                    });
                                    fetchData();
                                    setState(() {
                                      _tap = false;
                                      _button = true;
                                    });
                                  },
                            child: _tap == true
                                ? CupertinoActivityIndicator()
                                : Text('Load More..')),
                      ),
                    );
                  }
                  return Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Contact Number',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                child: Text(
                                  listItems[i].providerContact,
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  _launchCaller(listItems[i].providerContact);
                                },
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Name',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Expanded(
                                  child: Text(
                                listItems[i].providerName,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Last verified date',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Expanded(
                                  child: Text(
                                listItems[i].lastVerifiedDate,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Last verified time',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Expanded(
                                  child: Text(
                                listItems[i].lastVerifiedTime,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Qty (If applicable)',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Expanded(
                                  child: Text(
                                listItems[i].qty,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Important URL',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                child: Text(
                                  listItems[i].importantLink,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  _launchUrl(listItems[i].importantLink);
                                },
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Volunteer',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Expanded(
                                  child: Text(
                                listItems[i].verificationBy,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
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

class AllLeads {
  final int id;
  final String providerContact;
  final String providerName;
  final String lastVerifiedDate;
  final String lastVerifiedTime;
  final String qty;
  final String providerCity;
  final String serviceCategory;
  final String importantLink;
  final String verificationBy;

  AllLeads(
      this.id,
      this.providerContact,
      this.providerName,
      this.lastVerifiedDate,
      this.lastVerifiedTime,
      this.qty,
      this.providerCity,
      this.serviceCategory,
      this.importantLink,
      this.verificationBy);
}
