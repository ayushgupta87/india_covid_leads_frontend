import 'package:flutter/material.dart';
import 'package:dropdownfield/dropdownfield.dart';


Widget KbuildTextBox(TextEditingController inputController, String labelText,
    Icon icon, int lines, TextInputType textInputType, bool isHidden) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
    child: TextField(
      maxLines: lines,
      controller: inputController,
      keyboardType: textInputType,
      obscureText: isHidden,
      decoration: InputDecoration(
        icon: icon,
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    ),
  );
}

Widget KbuildDropDown(TextEditingController dropdownController,
    String labelText, List list, Icon icon) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
    child: DropDownField(
      controller: dropdownController,
      hintText: '* $labelText',
      enabled: true,
      items: list,
      icon: icon,
      itemsVisibleInDropdown: 5,
    ),
  );
}

Widget kbuildButton(BuildContext context, String title, function) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.5,
    height: MediaQuery.of(context).size.height * 0.06,
    child: ElevatedButton(
      onPressed: function,
      child: Text(
        title,
        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
      ),
    ),
  );
}

class kshowDialogue {
  String titleis;
  String contentIs;
  kshowDialogue(this.titleis, this.contentIs);

  showAlertDialoge(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text('Ok'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(titleis),
      content: SingleChildScrollView(child: Text(contentIs)),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}