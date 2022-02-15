import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unikids_uz/rx_bus/rx_bus.dart';
import 'package:unikids_uz/screens/login/bloc/login_bloc.dart';
import 'package:unikids_uz/utils/colors.dart';
import 'package:unikids_uz/utils/constants.dart';
import 'package:unikids_uz/utils/words.dart';
import 'package:unikids_uz/widgets/login_button.dart';

class LoginScreen extends StatefulWidget {
  late final CameraDescription camera;

  LoginScreen({Key? key, required this.camera}) : super(key: key);

  static Widget screen(camera) => BlocProvider(
        create: (context) => LoginBloc(context: context),
        child: LoginScreen(camera: camera),
      );

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginBloc bloc;
  bool _isConnecting = false;
  bool _passwordVisible = false;
  double wPadding = 4;
  late String _selectedItem;
  bool isDropDownSelect = false;

  bool _isPanDown = false;

  final _focusNodeName = FocusNode();
  final _focusNodePassword = FocusNode();

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
    bloc = BlocProvider.of<LoginBloc>(context);
    _selectedItem = MyWords.select_garden.tr();
    // bloc.add(DropDown());
    _focusNodeName.addListener(() {
      if (_focusNodeName.hasFocus) _isPanDown = false;
      RxBus.post(
        false,
        tag: "Focus",
      );
    });
    _focusNodePassword.addListener(() {
      if (_focusNodePassword.hasFocus) {
        _isPanDown = false;
        RxBus.post(
          false,
          tag: "Focus",
        );
      }
    });
    _registerBus();
    super.initState();
  }

  Future<void> _registerBus() async {
    RxBus.register<String>(tag: "UnFocus").listen(
      (event) {
        if (event == "Ok") {
          FocusScope.of(context).unfocus();
          // _nameController.clear();
          // _passwordController.clear();
        }
      },
    );
  }

  @override
  void dispose() {
    _focusNodeName.dispose();
    _focusNodePassword.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.baseWhiteColor,
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/image/login_background.jpg'),
            fit: BoxFit.fill),
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.black45),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: SvgPicture.asset('assets/svg/logoo.svg')),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(width: wPadding),
                  Text(MyWords.login_title.tr(),
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      if (context.locale == const Locale('ru', 'RU')) {
                        context.setLocale(const Locale('uz', 'UZ'));
                      } else {
                        context.setLocale(const Locale('ru', 'RU'));
                      }

                      setState(() {});
                    },
                    icon: Image.asset(context.locale == const Locale('uz', 'UZ')
                        ? "assets/image/flag_uzb.png"
                        : "assets/image/flag_rus.png"),
                    iconSize: 50,
                  ),
                  SizedBox(width: wPadding),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.only(left: wPadding, right: wPadding),
                child: TextFormField(
                  cursorColor: MyColors.yellow,
                  style: const TextStyle(color: Colors.yellow, fontSize: 16),
                  focusNode: _focusNodeName,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: MyWords.login_name.tr(),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.yellow, width: 2.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.yellow, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelStyle: const TextStyle(color: Colors.yellow),
                    //   fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: !_isPanDown ? Colors.yellow : Colors.yellow,
                          width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.only(left: wPadding, right: wPadding),
                child: TextFormField(
                  cursorColor: MyColors.yellow,
                  style: const TextStyle(color: Colors.yellow, fontSize: 16),
                  focusNode: _focusNodePassword,
                  keyboardType: TextInputType.text,
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: MyWords.login_password.tr(),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.yellow, width: 2.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.yellow, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelStyle: const TextStyle(color: Colors.yellow),
                    //   fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: !_isPanDown ? Colors.yellow : Colors.yellow,
                          width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LoginBtn(
                  onPressed: () async {
                    // if (_nameController.text == "" ||
                    //     _passwordController.text == "") {
                    //   MyContants.showToast(
                    //       MyWords.fields_empty.tr(), MyColors.yellow);
                    // } else {
                    _isConnecting = await checkInternetConnection();
                    if (_isConnecting) {
                      String lang;
                      if (context.locale == const Locale('ru', 'RU')) {
                        lang = "ru";
                      } else {
                        lang = "uz";
                      }
                      bloc.add(SignInEvent(
                          baseUrl: _selectedItem,
                          username: _nameController.text,
                          password: _passwordController.text,
                          camera: widget.camera,
                          lang: lang));
                    } else {
                      Fluttertoast.showToast(
                          msg: MyWords.no_internet_connection.tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    //      }
                  },
                  text: MyWords.login_sign.tr()),
              const SizedBox(height: 16),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginInitial) return const SizedBox();
                  if (state is LoginLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.yellow,
                    ));
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
