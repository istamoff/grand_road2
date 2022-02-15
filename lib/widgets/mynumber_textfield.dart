import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/widgets/calendar.dart';

class MyNumberTextField extends StatefulWidget {
  MyNumberTextField({required this.controller, required this.txt,  required this.validate, required this.formatter});

  late TextEditingController controller;
  late String txt;
  late bool validate;
  List<TextInputFormatter> formatter;

  @override
  State<MyNumberTextField> createState() => _MyNumberTextFieldState();
}

class _MyNumberTextFieldState extends State<MyNumberTextField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        inputFormatters: widget.formatter,
        controller: widget.controller,
        decoration: InputDecoration(
          errorText: widget.validate ? (widget.controller.text == "" ? 'Value Can\'t Be Empty' : null) : null,
          labelText: widget.txt,
          hintText: "998(__) ___ __ __",
          hintStyle: TextStyle(color: Colors.grey),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder:  OutlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: MyColors.baseOrangeColor,
                width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
