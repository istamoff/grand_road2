import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unikids_uz/screens/login/login_screen.dart';
import 'package:unikids_uz/screens/main/main_admin_screen.dart';
import 'package:unikids_uz/screens/main/main_teacher_screen.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/styles.dart';
import 'package:unikids_uz/utils/words.dart';
import 'di/locator.dart';
import 'model/hive/role_data/role_data_model.dart';
import 'model/response_model.dart';
import 'screens/child/info/main/child_info_main_screen.dart';
import 'screens/main/main_nurse_screen.dart';
import 'utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  Hive.registerAdapter<RoleDataModel>(RoleDataModelAdapter());
  await Hive.initFlutter();
  final box = await Hive.openBox('db');
  String token = box.get('token') ?? '';
  String permission = token != "" ? box.get("permission") : "";
  MyContants.BASE_URL = box.get("base_url") ?? "";
  RoleDataModel model = token != "" ? box.getAt(0) : RoleDataModel.empty();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  locatorSetUp();
  runApp( EasyLocalization(
          supportedLocales: const [Locale('uz', 'UZ'), Locale('ru', 'RU')],
          path: 'assets/lang',
          fallbackLocale: const Locale('uz', 'UZ'),
          saveLocale: true,
          child:  MyApp(camera: firstCamera, model: model, token: token, permission: permission)
      )
  );
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  final RoleDataModel model;
  final String token;
  final String permission;

  MyApp(
      {required this.camera,
      required this.model,
      required this.token,
      required this.permission});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniKids',
      debugShowCheckedModeBanner: false,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: token == "" ? LoginScreen.screen(camera) :  (permission == MyContants.TEACHER_ALL ?  MainTeacherScreen.screen(camera, model, permission) : (
        permission == MyContants.NURSE_ALL ? MainNurseScreen.screen(camera, model, permission) : MainAdminScreen.screen(token, camera, model, permission))),
         );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


