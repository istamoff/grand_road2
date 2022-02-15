import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unikids_uz/model/response_model.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';

class ListItemWidget extends StatefulWidget {
  final Human human;
  final int index;
  final bool checked;
  final Function()?onTapItem;

  ListItemWidget({
    required this.human,
    required this.index,
    this.checked = false,
    this.onTapItem,
  });

  @override
  _ListItemWidgetState createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  // late bool isRadio;

  @override
  void initState() {
    //  isRadio = widget.index == 0 ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTapItem,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                width: 76,
                height: 98,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.human.photo != ""
                        ? NetworkImage(widget.human.photo)
                        : //     NetworkImage(_baseUrl + widget.model.result.photo):
                        AssetImage('assets/image/no_image.png') as ImageProvider,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 4, color: MyColors.baseWhiteColor),
                  boxShadow: [
                    BoxShadow(
                        color: MyColors.baseWeightShadowColor,
                        blurRadius: 4,
                        spreadRadius: 0.25),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    width: 180,
                    child: Text(
                        widget.human.firstName.toUpperCase() +
                            " " +
                            widget.human.lastName.toUpperCase(),
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: 18, color: MyColors.baseWhiteColor)),
                  ),
                  // Text(widget.human.middleName.toUpperCase(),
                  //     style: TextStyle(fontSize: 14, color: Colors.white)),
                  SizedBox(height: 8),
                  Text(widget.human.relativityType.title.toUpperCase(),
                      style: TextStyle(
                          fontSize: 12, color: MyColors.baseLightColor)),
                  SizedBox(height: 8),
                  Container(
                      width: 180, height: 1, color: MyColors.baseLightColor),
                  SizedBox(height: 8),
                  Text(
                      widget.human.phoneNumber == ""
                          ? "No number"
                          : widget.human.phoneNumber.toUpperCase(),
                      style: TextStyle(
                          fontSize: 14, color: MyColors.baseLightColor)),
                ],
              ),
              Spacer(),
              !widget.checked
                  ? SvgPicture.asset("assets/svg/radio_off.svg",
                      color: MyColors.baseLightColor)
                  : SvgPicture.asset("assets/svg/radio_on.svg",
                      color: MyColors.baseLightColor)
            ],
          ),
        ),
        SizedBox(height: 16),
        Divider(color: MyColors.baseLightColor, thickness: 2)
      ],
    );
  }
}
