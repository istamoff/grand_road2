import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/widgets/calendar.dart';

class MyTextField extends StatefulWidget {
  MyTextField({required this.controller, required this.txt, this.icon = false, required this.validate});

  late TextEditingController controller;
  late String txt;
  late bool icon;
  late bool validate;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: widget.controller,
        decoration: !widget.icon ?
        InputDecoration(
          errorText: widget.validate ? (widget.controller.text == "" ? 'Value Can\'t Be Empty' : null) : null,
          labelText: widget.txt,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
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
        ) : InputDecoration(
          errorText: widget.validate ? (widget.controller.text == "" ? 'Value Can\'t Be Empty' : null) : null,
          labelText: widget.txt,
          hintText: "01-01-2021",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: GestureDetector(
              onTap: (){
                showDialog(context: context, builder: (_) => AlertDialog(
                    content: SizedBox(
                        height: 450,
                        width: 330,
                        child: SimpleCalendarPage()))
                ).then((value){
                  widget.controller.text = value;
                  setState(() {
                  });
                  print(widget.controller.text + " NULLLLLLLLLLL");
                });
              },
              child: const Icon(Icons.calendar_today_outlined, color: MyColors.baseOrangeColor,)),
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
