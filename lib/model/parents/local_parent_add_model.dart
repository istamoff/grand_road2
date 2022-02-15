
import 'package:flutter/cupertino.dart';

class LocalParentAddModel{
  final String first_name;
  final String last_name;
  final String middle_name;
  final int child;
  final int relativity_type;
  final List<TextEditingController> contacts;
  final TextEditingController number;

  LocalParentAddModel({required this.first_name, required this.last_name, required this.middle_name, required this.child, required this.relativity_type, required this.contacts, required this.number});
  factory LocalParentAddModel.empty() =>
      LocalParentAddModel(
          child: 0,
          relativity_type: 0,
          contacts: [],
          first_name: "",
          last_name: "",
          middle_name: "",
          number: TextEditingController(text: "")
      );
}