
import 'package:flutter/material.dart';
import 'package:unikids_uz/utils/colors.dart';

class LoginBtn extends StatelessWidget {
   LoginBtn({required this.onPressed, required this.text});

   final VoidCallback onPressed;
   final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed, child: Text(text, style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
      style:  ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)
              )
          ),
        backgroundColor: MaterialStateProperty.all<Color>(MyColors.yellow),
      ),
      ),
    );
  }
}
