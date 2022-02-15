import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as Image;
import 'package:image/image.dart';
import 'package:unikids_uz/model/hive/role_data/role_data_model.dart';
import 'package:unikids_uz/rx_bus/rx_bus.dart';
import 'package:unikids_uz/screens/child/add/add_child_screen.dart';
import 'package:unikids_uz/screens/login/login_screen.dart';
import 'package:unikids_uz/screens/update_user/update_screen.dart';
import 'package:unikids_uz/screens/update_user/user_logged_in_event.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:unikids_uz/widgets/select_dialog_screen.dart';
import 'dart:io' as Io;
import 'package:path/path.dart' as path;
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'bloc/main_bloc.dart';
import 'tab/teacher/go_out/go_out_screen.dart';

class MainAdminScreen extends StatefulWidget {
  final CameraDescription camera;
  final RoleDataModel model;
  final String permission;
  final String token;


  static Widget screen(token, camera, model, permission) => BlocProvider(
    create: (context) => MainBloc(context: context),
    child: MainAdminScreen(token: token,
        camera: camera, model: model, permission: permission),
  );

  MainAdminScreen({required this.camera, required this.model, required this.permission, required this.token});

  @override
  _MainAdminScreenState createState() => _MainAdminScreenState();
}

class _MainAdminScreenState extends State<MainAdminScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  double height = 28, widht = 34;
  double heightBig = 56;
  int _selectedIndex = 2;
  bool isResponse = false;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String firstName;
  late String fullName;
  late String lastName;
  late String roleName;

  late List<CameraDescription> cameras;
  bool isReady = false;
  bool noCameraDevice = false;
  int selectedCamera = 1;
  bool _isConnecting = false;
  late ui.Image _image;
  bool isVisibleFloating = true;
  late Size size;
  late MainBloc bloc;


  _loadImage() async {
    ByteData bd = await rootBundle.load("assets/image/clicle_avatar_75.png");

    final Uint8List bytes = Uint8List.view(bd.buffer);

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    final ui.Image image = (await codec.getNextFrame()).image;
    setState(() {
      _image = image;
    });
  }

  Future<void> getCameras() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // Some logic to get the rectangle values

  checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<MainBloc>(context);
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
    _loadImage();
    _getTitle();
  }


  void _getTitle() {
    var box = Hive.box('db');
    RoleDataModel storage = box.getAt(0);
    firstName = storage.firstName;
    fullName = storage.fullName;
    lastName = storage.lastName;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    MyContants.TEXTWIDHT =  MediaQuery.of(context).size.width - 170;
    return Scaffold(
      backgroundColor: MyColors.baseSecondaryColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.baseOrangeColor,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChildAddScreen.screen())).then((value){
            setState(() {
            });
          });
        },
      ),
      appBar: AppBar(
        toolbarHeight: 64,
        elevation: 0,
        backgroundColor: MyColors.baseSecondaryColor,
        // leading: IconButton(icon: Icon(Icons.arrow, color:  MyColors.baseWhiteColor), onPressed: (){}),
        title:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              lastName + " " + firstName,
              style: TextStyle(fontSize: 18, color: MyColors.baseWhiteColor),
            ),
            SizedBox(height: 4),
            Text(context.locale == const Locale('ru', 'RU') ? widget.model.roleRu.toUpperCase() : widget.model.roleUz.toUpperCase(),
                style: TextStyle(fontSize: 12, color: MyColors.baseLightColor))
          ],
        ),
        actions: [
          GestureDetector(
            onTap: (){
              String _vClass, _vGroup;
              if(context.locale == const Locale('ru', 'RU')){
                context.setLocale(const Locale('uz', 'UZ'));
                bloc.add(UpdateLang(lang: "uz"));
              }
              else {
                context.setLocale(const Locale('ru', 'RU'));
                bloc.add(UpdateLang(lang: "ru"));
              }
              print(MyWords.all_class.tr() + " ----------------- " + MyWords.all_group.tr());
              if(context.locale == const Locale('ru', 'RU')){
                _vClass = "Все классы";
                _vGroup = "Все группы";

              }
              else {
                _vClass = "Barcha sinflar";
                _vGroup = "Barcha guruhlar";
              }

              RxBus.post(
                UserLoggedInModel(
                  valueClass: _vClass,
                  valueGroup: _vGroup
                ),
                tag: "EVENT_LIST",
              );
              setState(() {
              });
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image:  AssetImage(context.locale == Locale('uz', 'UZ') ? "assets/image/flag_uzb.png" : "assets/image/flag_rus.png")),
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                final box = await Hive.openBox('db');
                box.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen.screen(widget.camera)),
                ).then((value){
                  setState(() {
                  });
                });
              },
              icon: Icon(
                Icons.exit_to_app,
                color: MyColors.baseWhiteColor,
              ))
        ],
      ),
      body: Column(
        children: [
        Expanded(
            child: UpdateScreen(cameraDescription: widget.camera, token: widget.token),
          ),
        ],
      ),
    );
  }

}
