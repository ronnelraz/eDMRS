// ignore_for_file: avoid_print, use_build_context_synchronously, sized_box_for_whitespace, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, use_super_parameters, unused_import
import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:edmrs/API/api_service.dart';
import 'package:edmrs/components/config.dart';
import 'package:edmrs/pages/area.dart';
import 'package:edmrs/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../sharedpref/sharedpref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure all bindings are initialized
  await initLocalStorage();
  bool isLoggedIn = await getLoginStatus();
  bool isHasArea =  await getArea();

  print('selected area : $isHasArea');


  runApp(MyApp(isLoggedIn: isLoggedIn, isSelectedArea:isHasArea ));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final bool isSelectedArea;

  const MyApp({required this.isLoggedIn, required this.isSelectedArea, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   late ThemeMode _themeMode =  ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _initializeThemeMode(); // Initialize the theme mode during initialization
  }

  void _initializeThemeMode() async {
    bool isDarkMode = await getDarkMode(); // Retrieve the saved theme mode
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      setDarkMode(_themeMode == ThemeMode.dark); // Update with the current theme mode
    });
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: App.primaryColor,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255,31, 31, 31),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(backgroundColor:   Color.fromARGB(255,31, 31, 31))
      ),
      themeMode: _themeMode,
      home: widget.isLoggedIn ? //if logint alrady 
      (widget.isSelectedArea ?  // check if have area
      Menu(toggleTheme: _toggleTheme, isDarkMode: isDarkMode) :
      Area(toggleTheme: _toggleTheme, isDarkMode: isDarkMode) ) : 
      MyHomePage(title: App.title, toggleTheme: _toggleTheme, isDarkMode: isDarkMode),

    );
  }
}


class MyHomePage extends StatefulWidget {
  final String title;
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  MyHomePage({required this.title, required this.toggleTheme, required this.isDarkMode});

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<MyHomePage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // title: Text(widget.title),
        automaticallyImplyLeading: false,
        actions: [
        Padding(
            padding: const EdgeInsets.all(8.0), // Adjust the margin as needed
            child: IconButton(
              icon: Icon(widget.isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
              onPressed: widget.toggleTheme,
            ),
          ),
        ],
      ),
      body: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildImage('assets/logo.png', 100, 100, Alignment.center),
                    const SizedBox(height: 20),
                    Text(
                      widget.title,
                      style: builderStyle(30, widget.isDarkMode ? Colors.white : Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 350, // Set the desired width
                      height: 50,
                      child: CustomTextField(
                        customerRadius: 10.0,
                        controller: username,
                        hintText: "Username",
                        cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                        focusNode: usernameFocus,
                        prefixIcon: Align(
                          widthFactor: 2.0,
                          heightFactor: 2.0,
                          child: buildSvgPicture(
                            'assets/user.svg',
                            BoxFit.scaleDown,
                            width: 25,
                            height: 25,
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 350, // Set the desired width
                      height: 50,
                      child: CustomTextField(
                        customerRadius: 10.0,
                        controller: password,
                        hintText: "Password",
                        cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                        isPassword: true,
                        focusNode: passwordFocus,
                        prefixIcon: Align(
                          widthFactor: 2.0,
                          heightFactor: 2.0,
                          child: buildSvgPicture(
                            'assets/password.svg',
                            BoxFit.scaleDown,
                            width: 25,
                            height: 25,
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 350, // Set the desired width
                      child: CustomButtonWithIcon(
                        icon: 'assets/login.svg',
                        label: 'Login',
                        onPressed: () async {
                          String enteredUsername = username.text;
                          String enteredPassword = password.text;

                          if (enteredUsername.isEmpty) {
                            await notification_toast(
                              context,
                              "Username",
                              "Please enter valid username",
                              toastificationType: ToastificationType.error,
                              toastificationStyle: ToastificationStyle.fillColored,
                              descTextColor: Colors.white,
                              icon: const Icon(Icons.error),
                            );

                            FocusScope.of(context).requestFocus(usernameFocus);
                          } else if (enteredPassword.isEmpty) {
                            await notification_toast(
                              context,
                              "Password",
                              "Please enter valid password",
                              toastificationType: ToastificationType.error,
                              toastificationStyle: ToastificationStyle.fillColored,
                              descTextColor: Colors.white,
                              icon: const Icon(Icons.error),
                            );
                            FocusScope.of(context).requestFocus(passwordFocus);
                          } else {
                            loading(context, "Please wait...",widget.isDarkMode);
                            Map<String, String> body = {
                              'username': enteredUsername,
                              'password': enteredPassword,
                            };

                            try {
                              var response = await postData('login', body);
                              if (response != null) {
                                if (response.statusCode == 200) {
                                  closeDialog(context);
                                  Map<String, dynamic> responseData = json.decode(response.body);
                                  if (responseData['success'] == 0) {
                                    await notification_toast(
                                      context,
                                      "Logged In",
                                      responseData['message'],
                                      toastificationType: ToastificationType.success,
                                      toastificationStyle: ToastificationStyle.fillColored,
                                      descTextColor: Colors.white,
                                      icon: const Icon(Icons.check),
                                    );

                                    bool saved = await setLoginStatus(true);
                                    if (saved) {
                                      print('Login status saved successfully.');
                                      locStorage(App.Auth,encrypted(enteredUsername+":"+enteredPassword));
                                    } else {
                                      print('Failed to save login status.');
                                    }
                                    intent(context, Area(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode));

                                  } else {
                                    await notification_toast(
                                      context,
                                      "Invalid username/password",
                                      responseData['message'],
                                      toastificationType: ToastificationType.error,
                                      toastificationStyle: ToastificationStyle.fillColored,
                                      descTextColor: Colors.white,
                                      icon: const Icon(Icons.error),
                                    );
                                  }
                                } else {
                                  await notification_toast(
                                    context,
                                    "Invalid username/password",
                                    response.statusCode.toString(),
                                    toastificationType: ToastificationType.error,
                                    toastificationStyle: ToastificationStyle.fillColored,
                                    descTextColor: Colors.white,
                                    icon: const Icon(Icons.error),
                                  );
                                  print('Request failed with status: ${response.statusCode}');
                                }
                              } else {
                                await notification_toast(
                                  context,
                                  "Login",
                                  "Invalid Response",
                                  toastificationType: ToastificationType.error,
                                  toastificationStyle: ToastificationStyle.fillColored,
                                  descTextColor: Colors.white,
                                  icon: const Icon(Icons.error),
                                );
                              }
                            } catch (e) {
                              print('Exception occurred: $e');
                            }
                          }
                        },
                        color: widget.isDarkMode ? Color.fromARGB(255, 12, 167, 71) : App.primaryButton,
                        iconColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }
}
