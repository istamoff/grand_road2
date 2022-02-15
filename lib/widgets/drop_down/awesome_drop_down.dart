
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unikids_uz/model/rxbus_list_model.dart';
import 'package:unikids_uz/rx_bus/rx_bus.dart';
import 'package:unikids_uz/screens/child/add/bloc/child_add_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';

import 'src/custom_scrollbar.dart';
import 'src/remove_over_scroll.dart';

class AwesomeDropDown extends StatefulWidget {
  /// background [Color] of dropdown, icon, and overLay,
  final Color dropDownBGColor, dropDownIconBGColor, dropDownOverlayBGColor;

  /// this radius will be used to set the border of drop down
  final double dropDownBorderRadius;

  /// user can set any Icon or Image here because it accept any widget
 // final Widget dropDownIcon;

  /// The list of items the user can select
  /// If the list of items is null then an empty list will be shown
  List<String> dropDownList;

  /// this variable is used to close the drop down is user touch outside or by back pressed
  bool isBackPressedOrTouchedOutSide;

  /// this func is used to maintain the open and close state of drop down
  Function? dropStateChanged;

  /// this func is used for select any item from the list
  Function? onDropDownItemClick;

  /// this radius is used to custom the top borders of drop down
  /// user can set drop down style as Rectangular, Oval, Rounded Borders and any other
  /// it helps user to make customize design of drop down
  double dropDownTopBorderRadius;

  /// this radius is used to custom the bottom borders of drop down
  /// user can set drop down style as Rectangular, Oval, Rounded Borders and any other
  /// it helps user to make customize design of drop down
  double dropDownBottomBorderRadius;

  /// thi variable is used to detect panDown event of scaffold body
  bool isPanDown;

  /// user can provide any elevation as per his choice
  double elevation;

  /// A placeholder text that is displayed by the dropdown
  ///
  /// If the [hint] is null
  /// this will displayed the First index of List
  String selectedItem;

  /// TextStyle for the hint.
  TextStyle selectedItemTextStyle;

  ///TextStyle for the value of list in drop down.
  TextStyle dropDownListTextStyle;
  double padding;
  /// user can define how many items of list would be shown when drop down opens, by default we set it's value to '4'
  int numOfListItemToShow;
  Color color;
  bool? type;


  AwesomeDropDown({
    required this.dropDownList,
    this.isPanDown: false,
    this.dropDownBGColor: Colors.white,
    this.dropDownIconBGColor: Colors.transparent,
    this.dropDownOverlayBGColor: Colors.white,
    this.dropDownBorderRadius: 0,
 //   required this.dropDownIcon,
    this.onDropDownItemClick,
    this.isBackPressedOrTouchedOutSide: false,
    this.dropStateChanged,
    this.dropDownBottomBorderRadius: 50,
    this.dropDownTopBorderRadius: 50,
    this.selectedItem: '',
    this.selectedItemTextStyle: const TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
    this.dropDownListTextStyle: const TextStyle(
        color: Colors.grey, fontSize: 15, backgroundColor: Colors.transparent),
    this.elevation: 0,
    this.padding: 0,
    this.numOfListItemToShow: 4,
    this.color: MyColors.baseOrangeColor,
    this.type
  });

  @override
  _AwesomeDropDownState createState() {
    return _AwesomeDropDownState();
  }
}

class _AwesomeDropDownState extends State<AwesomeDropDown>
    with WidgetsBindingObserver {
  late GlobalKey _gestureDetectorGlobalKey;
  double _gestureDetectorHeight = 0.0,
      _gestureDetectorWidth = 0.0,
      _gestureDetectorXPosition = 0.0,
      _gestureDetectorYPosition = 0.0;
  static OverlayEntry? _floatingDropdown;
  bool _isDropdownOpened = false, _isFirstTime = true;
  double _listItemHeight = 0.0;
  double initialTopBorderRadius = 0.0;
  double initialBottomBorderRadius = 0.0;
  bool onPress = false;
  late Color myColor;
  List<String> list = [];

  @override
  void initState() {
    myColor = widget.color;
    _gestureDetectorGlobalKey = GlobalKey();
    WidgetsBinding.instance!.addObserver(this);
    _registerBus();
    super.initState();
  }


  Future<void> _registerBus() async {
    RxBus.register<bool>(tag: "Focus").listen(
          (event) {
            onPress = event;
        },
    );  //ItemClick
    RxBus.register<String>(tag: "ItemClick").listen(
          (event) {
            if (event == "color")
              onPress = false;
            myColor = Colors.grey;
      },
    );
    RxBus.register<String>(tag: "ItemClick").listen(
          (event) {
        if (event == "color")
          onPress = false;
        myColor = Colors.grey;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBackPressedOrTouchedOutSide != null &&
        widget.isBackPressedOrTouchedOutSide &&
        _isDropdownOpened) {
      _openAndCloseDrawer();
      widget.isBackPressedOrTouchedOutSide = false;
    }
    if (widget.isPanDown) {
      Future.delayed(Duration(milliseconds: 100), () {
        widget.isPanDown = false;
      });
    }

    /// we don't want to restrict user to wrap his scaffold by [WillPopScope] so we wrap our custom widget by it
    return WillPopScope(
      onWillPop: () {
        if (_isDropdownOpened) {
          setState(() {});
          _openAndCloseDrawer();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: GestureDetector(
        key: _gestureDetectorGlobalKey,
        onTap: () {
          if(widget.type != null){
            if(widget.type!) {
              print("RX BUS CLASS");
              RxBus.post(
              "Ok",
              tag: "Class",
            );
            } else {
              RxBus.post(
                "Oks",
                tag: "Class",
              );
            }
          }
          RxBus.post(
           "Ok",
            tag: "UnFocus",
          );
          if (_isFirstTime || (widget.isPanDown != null && !widget.isPanDown)) {
            setState(() {
              if (widget.isPanDown) {
                widget.isPanDown = false;
              }
              _isFirstTime = false;
              _openAndCloseDrawer();
            });
          } else {
            widget.isPanDown = false;
          }
          if(!onPress){
            onPress = true;
            myColor = MyColors.baseOrangeColor;
          }
          else{
              myColor = Colors.grey;
              onPress = false;
          }
          setState(() {
          });
        },
        child: Card(
          elevation: widget.elevation,
          color: widget.dropDownBGColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.dropDownTopBorderRadius),
              topRight: Radius.circular(widget.dropDownTopBorderRadius),
              bottomRight: Radius.circular(widget.dropDownBottomBorderRadius),
              bottomLeft: Radius.circular(widget.dropDownBottomBorderRadius),
            ),
          ),
          child: Container(
            // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            padding: EdgeInsets.all(widget.padding),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                 Radius.circular(8.0),
                ),
                border: Border.all(color: onPress ? myColor: Colors.grey, width: onPress ? 2.0 : 1.0)
            ),
            height: 50,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      widget.selectedItem == ''
                          ? widget.dropDownList[0]
                          : widget.selectedItem,
                      textScaleFactor:
                      MediaQuery.of(context).textScaleFactor > 1.5
                          ? 1.5
                          : MediaQuery.of(context).textScaleFactor,
                      style: widget.selectedItemTextStyle,
                    ),
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                     // margin: EdgeInsets.only(right: 5),
                      color: (widget.dropDownIconBGColor != null)
                          ? widget.dropDownIconBGColor
                          : Colors.transparent,
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: onPress ? MyColors.baseOrangeColor : Colors.grey,
                        size: 23,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeTextScaleFactor() {
    if (_isDropdownOpened) {
      _openAndCloseDrawer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void findDropdownData() {
    RenderBox renderBox = _gestureDetectorGlobalKey.currentContext!
        .findRenderObject() as RenderBox;
    _gestureDetectorHeight = renderBox.size.height;
    _gestureDetectorWidth = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    _gestureDetectorXPosition = offset.dx;
    _gestureDetectorYPosition = offset.dy;
  }

  /// Create the floating dropdown overlay
  OverlayEntry _createFloatingDropdown(int numOfListItemToShow) {
    int numOfListItem = numOfListItemToShow != null &&
        numOfListItemToShow <= 10 &&
        numOfListItemToShow <= widget.dropDownList.length
        ? numOfListItemToShow
        : 4;
    double overlayHeight = _listItemHeight * widget.dropDownList.length + 15,
        fourItemsHeight = numOfListItem * _listItemHeight + 15;
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: _gestureDetectorXPosition * 1.05,
        width: _gestureDetectorWidth * 0.990,
        top: _gestureDetectorYPosition + _gestureDetectorHeight,
        height: (_listItemHeight == 0.0)
            ? 0.1
            : (overlayHeight > fourItemsHeight)
            ? fourItemsHeight + MediaQuery.of(context).padding.top
            : overlayHeight + MediaQuery.of(context).padding.top,
        child: Container(
          height: 200,
         // margin: const EdgeInsets.only(left: 10.0, right: 8.0, bottom: 10.0),
          transform: Matrix4.translationValues(
              0, -MediaQuery.of(context).padding.top, 0),
          child: SafeArea(
            child: DropDownOverlay(
              itemHeight: _gestureDetectorHeight,
              dropDownList:
            (widget.dropDownList != null) ? widget.dropDownList : [],
              overlayBGColor: (widget.dropDownOverlayBGColor != null)
                  ? widget.dropDownOverlayBGColor
                  : widget.dropDownBGColor,
              dropDownItemClick: _dropDownItemClickListener,
              dropDownBorderRadius: widget.dropDownBottomBorderRadius,
              dropDownListTextStyle: widget.dropDownListTextStyle,
              onOverlayOpen: (listItemHeight) {
                setState(() {
                  if (listItemHeight != null &&
                      listItemHeight > 0 &&
                      _listItemHeight != listItemHeight) {
                    _listItemHeight = listItemHeight;
                    _openAndCloseDrawer();
                    _openAndCloseDrawer();
                  }
                });
              },
            ),
          ),
        ),
      );
    });
  }

  /// it flip flop the open and close state
  void _openAndCloseDrawer() {
    if (_isDropdownOpened) {
      _floatingDropdown?.remove();
      _dropDownStateChanged(false);
      widget.dropDownBottomBorderRadius = initialBottomBorderRadius;
      widget.dropDownTopBorderRadius = initialTopBorderRadius;
    } else {
      findDropdownData();
      _floatingDropdown = _createFloatingDropdown(widget.numOfListItemToShow);
      Overlay.of(context)!.insert(_floatingDropdown!);
      initialTopBorderRadius = widget.dropDownTopBorderRadius;
      initialBottomBorderRadius = widget.dropDownBottomBorderRadius;
      widget.dropDownBottomBorderRadius = 0.0;
      widget.dropDownTopBorderRadius = 10.0;
      _dropDownStateChanged(true);
    }
    _isDropdownOpened = !_isDropdownOpened;
  }

  /// it detect if the drop down state changed?
  void _dropDownStateChanged(bool state) {
    if (widget.dropStateChanged != null) {
      widget.dropStateChanged!(state);
    }
  }

  /// this changes the whole drop down width when orientation changes from portrait to landscape or vise versa
  @override
  void didChangeMetrics() {
    Orientation _orientation = MediaQuery.of(context).orientation;
    if (_isDropdownOpened) {
      _openAndCloseDrawer();
      _openAndCloseDrawer();
    }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _orientation = MediaQuery.of(context).orientation;
      if (_isDropdownOpened) {
        _openAndCloseDrawer();
        _openAndCloseDrawer();
      }
    });
    super.didChangeMetrics();
  }

  /// it detects the user click and display the new selected value
  void _dropDownItemClickListener(String selItem) {
    setState(() {
      widget.selectedItem = selItem;
      _openAndCloseDrawer();
    });
    if (widget.onDropDownItemClick != null) {
      widget.onDropDownItemClick!(selItem);
    }
  }
}

/// Widget that builds the dropdown overlay.
///
/// This Widget is responsible to create the dropdown
/// overlay menu every time is open.
/// This menu has a [dropDownItemClick] callback, used to
/// pass upwards the on value changed event, from his children
/// to the [AwesomeDropDown].
class DropDownOverlay extends StatefulWidget {
  final Function dropDownItemClick;
  List<String> dropDownList;
  final double itemHeight;
  final Color overlayBGColor;
  final double dropDownBorderRadius;
  final Function onOverlayOpen;
  final TextStyle dropDownListTextStyle;

  DropDownOverlay(
      {Key? key,
        this.itemHeight = 0.0,
        required this.dropDownList,
        this.overlayBGColor: Colors.white,
        required this.dropDownItemClick,
        this.dropDownBorderRadius = 0.0,
        this.dropDownListTextStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
            backgroundColor: Colors.transparent),
        required this.onOverlayOpen})
      : super(key: key);

  @override
  State<DropDownOverlay> createState() => _DropDownOverlayState();
}

class _DropDownOverlayState extends State<DropDownOverlay> {
  GlobalKey _listItemKey = GlobalKey();
  late List<String> mList;

  double getListItemHeight() {
    RenderBox renderBox =
    _listItemKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  @override
  void initState() {
    mList = widget.dropDownList;
  // _registerBus();
    super.initState();
  }

  // Future<void> _registerBus() async {
  //   RxBus.register<RxBusListModel>(tag: "Loaded").listen(
  //         (event) {
  //           if (mounted) {
  //             mList = event.list;
  //             print(mList.length.toString() + " sizeRabota "  + widget.dropDownList.length.toString());
  //             setState(() {
  //             });
  //           }
  //     },
  //   );  //Loaded
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.onOverlayOpen != null) {
        widget.onOverlayOpen(getListItemHeight());
        print(getListItemHeight().toString() + ' height');
      }
    });
    ScrollController _scrollController = ScrollController();

    /// Create the overlay-ed body of the dropdown.
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(top: 1, bottom: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
      ),
      color: widget.overlayBGColor,
      child: Container(
        transform: Matrix4.translationValues(0, -2.5, 0),
        padding: EdgeInsets.only(top: 10, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.white,
                blurRadius: 0,
                spreadRadius: 0,
                offset: Offset(1, 3))
          ],
          color: widget.overlayBGColor,
        ),

        /// this scrollBar is added here to scroll the list is there are a large numbers of items
        child: CustomScrollbar(
            scrollbarThickness: 3.0,
            isAlwaysShown: true,
            controller: _scrollController,
            child: ScrollConfiguration(
              behavior: OverScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var x in mList)
                      Container(
                          key: _listItemKey = GlobalKey(),
                          color: Colors.transparent,
                          width: double.maxFinite,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black12,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 4),
                                child: Text(
                                  x,
                                  textAlign: TextAlign.left,
                                  textDirection: TextDirection.ltr,
                                  textScaleFactor: MediaQuery.of(context)
                                      .textScaleFactor >
                                      1.5
                                      ? 1.5
                                      : MediaQuery.of(context).textScaleFactor,
                                  style: widget.dropDownListTextStyle,
                                ),
                              ),
                              onTap: () {
                                if (widget.dropDownItemClick != null) {
                                  widget.dropDownItemClick(x);
                                }
                              },
                            ),
                          )),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
