import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart';
import 'package:unikids_uz/screens/camera/bloc/camera_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:unikids_uz/widgets/camera_painter.dart';
import 'dart:io' as Io;
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription cameraDescription;
  final id;

  static Widget screen(camera, id) => BlocProvider(
    create: (context) => CameraBloc(),
    child: CameraScreen(cameraDescription: camera, id: id),
  );

  CameraScreen({required this.cameraDescription, required this.id});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  double height = 28, widht = 34;
  late ui.Image _image;
  late Size size;
  bool _isConnecting = false;
  late CameraBloc bloc;
  int selectedCamera = 1;
  late List<CameraDescription> cameras;
  bool isReady = false;
  var appBarSize = AppBar().preferredSize.height;
  var safePadding;

  @override
  void initState() {
    bloc = BlocProvider.of<CameraBloc>(context);
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameraDescription,
      // Define the resolution to use.
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
    _loadImage();
    super.initState();
  }

  _loadImage() async {
    ByteData bd = await rootBundle.load("assets/image/clicle_avatar_75.png");

    final Uint8List bytes = Uint8List.view(bd.buffer);

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    final ui.Image image = (await codec.getNextFrame()).image;
    setState(() {
      _image = image;
    });
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    safePadding = MediaQuery.of(context).padding.top;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.baseSecondaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
       floatingActionButton:  Column(
         children: [
           SizedBox(height: safePadding + appBarSize + 50),
           Row(
             children: [
               Spacer(),
               SizedBox(
                     height: height,
                     width: widht,
                 child: IconButton(onPressed: (){
                   toggleCamera();
                 },
                     icon: Icon(Icons.cameraswitch_outlined, color: MyColors.baseWhiteColor)
                 // SvgPicture.asset("assets/svg/btn_change_camera.svg",
                 //     height: height,
                 //     width: widht,
                 //     color:MyColors.baseWhiteColor
                 //        )
                 ),
               ),
               SizedBox(width: 30)
             ],
           ),
           Expanded(child: SizedBox()),
           FloatingActionButton(
             backgroundColor: MyColors.baseSecondaryColor,
             child: Icon(Icons.camera),
             onPressed: () async {
                 try {
                   await _initializeControllerFuture;
                   final image = await _controller.takePicture();
                   requestResponse(image.path);
                 } catch (e) {
                 }
             },
           ),
         ],
       ),
       body: BlocConsumer<CameraBloc, CameraState>(
  listener: (context, state) {
    if(state is CameraLoading){
      _onLoading();
    }
   if(state is CameraError) {
     Navigator.pop(context);
     Fluttertoast.showToast(
         msg: state.error,
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.CENTER,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.red,
         textColor: Colors.white,
         fontSize: 16.0
     );
   }
   if(state is CameraSuccess) {
     Fluttertoast.showToast(
         msg: MyWords.photo_update.tr(),
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.CENTER,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.green,
         textColor: Colors.white,
         fontSize: 16.0
     );
     Navigator.pop(context);
     Navigator.pop(context);
     }
  },
  builder: (context, state) {
    return Column(
      children: [
        FutureBuilder<void>(
             future: _initializeControllerFuture,
             builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.done) {
                 return
                   Expanded(
                     child: Container(
                         width: size.height,
                         height: size.width,
                         child: CustomPaint(
                           foregroundPainter: ImageEditor(_image, size),
                           child: CameraPreview(
                             _controller,
                           ),
                         )
                     ),
                   );
               } else {
                 return Expanded(
                   child: Container(
                       width: double.infinity,
                       color: MyColors.baseSecondaryColor,
                       child: Center(child: CircularProgressIndicator())),
                 );
               }
             },
           ),
      ],
    );
  },
),
    );
  }

  Future<void> requestResponse(String imagePaths) async {
    final image = decodeImage(Io.File(imagePaths).readAsBytesSync());
    final thumbnail = copyResize(image!, width: 354, height: 472);
    Directory directory = await getApplicationDocumentsDirectory();
    String myPath = directory.path;
    File file = Io.File('$myPath/test.jpg')
      ..writeAsBytesSync(encodePng(thumbnail));
    print("path: " + file.path);
    print(file.lengthSync());
    String fileName = file.path.split('/').last;
    _isConnecting = await checkInternetConnection();
    if (_isConnecting) {
      bloc.add(LoadEvent(
          isConnect: true, fileName: fileName, filePath: file.path, id: widget.id));
    }
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

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: MyColors.baseSecondaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: CircularProgressIndicator(color: MyColors.baseLightColor)),
          ),
        );
      },
    );
  }
}
