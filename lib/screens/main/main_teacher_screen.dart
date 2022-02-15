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
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as Image;
import 'package:image/image.dart';
import 'package:unikids_uz/model/hive/role_data/role_data_model.dart';
import 'package:unikids_uz/model/login_model.dart';
import 'package:unikids_uz/model/response_model.dart';
import 'package:unikids_uz/screens/info/info_screen.dart';
import 'package:unikids_uz/screens/login/login_screen.dart';
import 'package:unikids_uz/screens/main/tab/nurse/nurse_screen.dart';
import 'package:unikids_uz/screens/main/tab/teacher/receive/receiver_screen.dart';
import 'package:unikids_uz/screens/update_user/update_screen.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:http/http.dart' as http;
import 'package:unikids_uz/widgets/camera_painter.dart';
import 'package:unikids_uz/widgets/select_dialog_screen.dart';
import 'dart:io' as Io;
import 'package:path/path.dart' as path;
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'bloc/main_bloc.dart';
import 'tab/teacher/go_out/go_out_screen.dart';

class MainTeacherScreen extends StatefulWidget {
  final CameraDescription camera;
  final RoleDataModel model;
  final String permission;

  static Widget screen(camera, model, permission) => BlocProvider(
        create: (context) => MainBloc(context: context),
        child: MainTeacherScreen(
            camera: camera, model: model, permission: permission),
      );

  MainTeacherScreen(
      {required this.camera, required this.model, required this.permission});

  @override
  _MainTeacherScreenState createState() => _MainTeacherScreenState();
}

class _MainTeacherScreenState extends State<MainTeacherScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  double height = 28, widht = 34;
  double heightBig = 56;
  int _selectedIndex = 2;
  late MainBloc bloc;
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
  late TabController _tabController;
  List<Tab> myTabs = <Tab>[
    Tab(text: MyWords.come_in.tr()),
    Tab(text: MyWords.come_out.tr()),
  ];

  late ui.Image _image;

  bool tab = false;
  bool isVisibleFloating = true;
  late Size size;

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
    _tabController = TabController(vsync: this, length: myTabs.length);
    _loadImage();
    _getTitle();
  }

  @override
  void dispose() {
    bloc.close();
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    MyContants.TEXTWIDHT =  MediaQuery.of(context).size.width - 120;
    return Scaffold(
      backgroundColor: MyColors.baseSecondaryColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomSheet: Padding(padding: EdgeInsets.only(bottom: 130.0)),
      floatingActionButton: Visibility(
        visible: isVisibleFloating,
        child: Column(
          children: [
            Spacer(),
            Text(
                MyContants.COMEIN == 0
                    ? MyWords.come_in.tr()
                    : MyWords.come_out.tr(),
                style: TextStyle(color: MyColors.baseSecondaryColor, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            FloatingActionButton(
              backgroundColor: MyColors.baseSecondaryColor,
              child: Icon(Icons.camera),
              onPressed: () async {
                if (isVisibleFloating) {
                  try {
                    await _initializeControllerFuture;
                    final image = await _controller.takePicture();
                    requestResponse(image.path);
                  } catch (e) {
                    print("Error " + e.toString());
                  }
                }
              },
            ),
            SizedBox(height: 90),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 64,
        elevation: 0,
        backgroundColor: MyColors.baseSecondaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              lastName + " " + firstName,
              style: TextStyle(fontSize: 18, color: MyColors.baseWhiteColor),
            ),
            SizedBox(height: 4),
            Text(
                context.locale == const Locale('ru', 'RU')
                    ? widget.model.roleRu.toUpperCase()
                    : widget.model.roleUz.toUpperCase(),
                style: TextStyle(fontSize: 12, color: MyColors.baseLightColor))
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (context.locale == const Locale('ru', 'RU')) {
                context.setLocale(const Locale('uz', 'UZ'));
                bloc.add(UpdateLang(lang: "uz"));
              } else {
                context.setLocale(const Locale('ru', 'RU'));
                context.locale == Locale('uz', 'UZ')
                    ? print("saslom")
                    : print("ex");
                bloc.add(UpdateLang(lang: "ru"));
              }
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(context.locale == const Locale('uz', 'UZ')
                        ? "assets/image/flag_uzb.png"
                        : "assets/image/flag_rus.png")),
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
                );
              },
              icon: Icon(
                Icons.exit_to_app,
                color: MyColors.baseWhiteColor,
              ))
        ],
        bottom: tab
            ? TabBar(
                controller: _tabController,
                tabs: <Tab>[
                  Tab(text: MyWords.come_in.tr()),
                  Tab(text: MyWords.come_out.tr()),
                ],
              )
            : PreferredSize(
                child: SizedBox(),
                preferredSize: Size.fromHeight(0),
              ),
      ),
      body: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {
          if(state is TeacherResponseState)
            _showResultat(state.code);

        },
        builder: (context, state) {
          return Column(
            children: [
              tab
                  ? Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          ReceiverScreen.screen(),
                          GoOutScreen.screen(),
                        ],
                      ),
                    )
                  : FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Expanded(
                            child: buildCameraView(),
                          );
                        } else {
                          return Expanded(
                            child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: MyColors.baseSecondaryColor,
                                child:
                                Center(child: CircularProgressIndicator())),
                          );
                        }
                      },
                    ),
              Container(
                height: 94,
                padding: EdgeInsets.only(top: 4, left: 16, right: 16),
                color: MyColors.baseSecondaryColor,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        if(_selectedIndex != 3) {
                          if (!tab) {
                            toggleCamera();
                          }
                          _selectedIndex = 0;
                          setState(() {});
                        }
                      }, icon: Icon(Icons.cameraswitch_rounded,
                        size: height,
                        color: _selectedIndex == 0
                            ? MyColors.baseWhiteColor
                            : MyColors.baseLightColor,
                      )),
                      GestureDetector(
                        onTap: () {
                          _selectedIndex = 1;
                          _showDialog();
                          setState(() {});
                        },
                        child: SvgPicture.asset(
                            "assets/svg/directions_walk.svg",
                            height: height,
                            width: widht,
                            color: _selectedIndex == 1
                                ? MyColors.baseWhiteColor
                                : MyColors.baseLightColor),
                      ),
                      GestureDetector(
                        onTap: () async {
                          tab = false;
                          _selectedIndex = 2;
                          isVisibleFloating = true;
                          setState(() {});
                          // try {
                          //   await _initializeControllerFuture;
                          //   final image = await _controller.takePicture();
                          //   requestResponse(image.path);
                          // } catch (e) {
                          //   print(e);
                          // }
                        },
                        child: SvgPicture.asset("assets/svg/btn_rescan.svg",
                            height: _selectedIndex == 2 ? heightBig : height,
                            width: widht,
                            color: _selectedIndex == 2
                                ? MyColors.baseWhiteColor
                                : MyColors.baseLightColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          tab = true;
                          _selectedIndex = 3;
                          isVisibleFloating = false;
                          setState(() {});
                        },
                        child: SvgPicture.asset("assets/svg/btn_journal.svg",
                            height: height,
                            width: widht,
                            color: _selectedIndex == 3
                                ? MyColors.baseWhiteColor
                                : MyColors.baseLightColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          // _selectedIndex = 4;
                          // print(_selectedIndex.toString() + " okk");
                          // setState(() {});
                        },
                        child: SvgPicture.asset("assets/svg/btn_settings.svg",
                            height: height,
                            width: widht,
                            color:
                            // _selectedIndex == 4
                            //     ? MyColors.baseWhiteColor
                            //     :
                            MyColors.baseLightColor
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget  buildCameraView() {
    var camera = _controller.value;
    if (_controller.value.previewSize == null) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          color: MyColors.baseSecondaryColor,
          child:
          Center(child: CircularProgressIndicator()));
    }
    else {
      var scale = size.aspectRatio * camera.aspectRatio;
      if (scale < 1) scale = 1 / scale;
      return Transform.scale(
        scale: scale,
        child: Center(
          child: CustomPaint(
            foregroundPainter: ImageEditor(_image, size),
            child: CameraPreview(
              _controller,
            ),
          ),
        ),
      );


      // else {
      //   return Container(
      //       width: double.infinity,
      //       height: double.infinity,
      //       color: MyColors.baseSecondaryColor,
      //       child:
      //           Center(child: CircularProgressIndicator()));
      // }
    }
  }

  Future<void> requestResponse(String imagePaths) async {
    final image = decodeImage(Io.File(imagePaths).readAsBytesSync());
    final thumbnail = copyResize(image!, width: 354, height: 472);
    Directory directory = await getApplicationDocumentsDirectory();
    String myPath = directory.path;
    _deleteImageFromCache('$myPath/test.jpg');
    File file = Io.File('$myPath/test.jpg')
      ..writeAsBytesSync(encodePng(thumbnail));
    print("path: " + file.path);
    print(file.lengthSync());
    String fileName = file.path.split('/').last;
    _isConnecting = await checkInternetConnection();
    if (!_isConnecting)
      Fluttertoast.showToast(
          msg: MyWords.no_internet_connection.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    else
      bloc.add(MainTeacherLoadEvent(
          isConnect: true,
          fileName: fileName,
          filePath: file.path,
          comeIn: MyContants.COMEIN));
  }

  Future _deleteImageFromCache(String url) async {
    await DefaultCacheManager().removeFile(url);
  }

  void toggleCamera() {
    setState(() {
      selectedCamera = (selectedCamera == 1) ? 0 : 1;
      _setupCamera();
    });
  }

  Future<void> _setupCamera() async {
    try {
      // initialize cameras.
      cameras = await availableCameras();
      // initialize camera controllers.
      _controller = new CameraController(
          cameras[selectedCamera], ResolutionPreset.medium);

      await _controller.initialize();
    } on CameraException catch (_) {
      debugPrint("Some error occured!");
    }

    if (!mounted) {
      return;
    }

    setState(() {
      isReady = true;
    });
  }

  void _getTitle() {
    var box = Hive.box('db');
    RoleDataModel storage = box.getAt(0);
    firstName = storage.firstName;
    fullName = storage.fullName;
    lastName = storage.lastName;
    if (widget.permission[0] == "admin_all") isVisibleFloating = false;
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (_) {
          // Future.delayed(Duration(seconds: 3), () {
          //   Navigator.of(context).pop(true);
          // });
          return AlertDialog(
              backgroundColor: MyColors.baseSecondaryColor,
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                //    side: BorderSide(color: MyColor.loginBtnColor2)
              ),
              content: SelectDiaalogUI());
        }).then((value) => setState(() {}));
  }

  Widget cameraWidget(context) {
    var camera = _controller.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(_controller),
      ),
    );
  }


  _showResultat(int code) {
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: code == 200 ? MyWords.add_list.tr() : (code == 404 ? MyWords.child_not_found.tr() : (code == 400 ? MyWords.not_in_journal.tr() : MyWords.server_error.tr())),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: code == 400 ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
