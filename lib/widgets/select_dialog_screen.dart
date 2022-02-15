import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/words.dart';

class SelectDiaalogUI extends StatefulWidget {

  @override
  _SelectDiaalogUIState createState() => _SelectDiaalogUIState();
}

class _SelectDiaalogUIState extends State<SelectDiaalogUI> {
  late bool isRadioIn = true;
  late bool isRadioOut = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
       children: [
         Spacer(),
         GestureDetector(
           onTap: (){
             if(isRadioIn)
               isRadioIn = !isRadioIn;
             else {
               isRadioIn = !isRadioIn;
               MyContants.COMEIN = 0;
               isRadioOut = false;
               Navigator.pop(context);
             }
             setState(() {
             });
           },
           child: Row(
             children: [
               Text(MyWords.bring_in.tr().toUpperCase(), style: TextStyle(fontSize: 14, color: MyColors.baseWhiteColor),),
               Spacer(),
               ! isRadioIn ? SvgPicture.asset("assets/svg/radio_off.svg", color: MyColors.baseLightColor) : SvgPicture.asset("assets/svg/radio_on.svg", color: MyColors.baseLightColor),
             ],
           ),
         ),
         GestureDetector(
           onTap: (){
             if(isRadioOut)
               isRadioOut = !isRadioOut;
             else {
               isRadioOut = !isRadioOut;
               MyContants.COMEIN = 1;
               isRadioIn = false;
               Navigator.pop(context);
             }
             setState(() {
             });
           },
           child: Row(
             children: [
               Text(MyWords.bring_out.tr().toUpperCase(), style: TextStyle(fontSize: 14, color: MyColors.baseWhiteColor),),
               Spacer(),
               ! isRadioOut ? SvgPicture.asset("assets/svg/radio_off.svg", color: MyColors.baseLightColor) : SvgPicture.asset("assets/svg/radio_on.svg", color: MyColors.baseLightColor),
             ],
           ),
         ),
         Spacer(),
       ],
          )
    );
  }
}



