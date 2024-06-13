// ignore_for_file: avoid_print, use_build_context_synchronously, sized_box_for_whitespace, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, use_super_parameters, unused_import
import 'dart:convert';
import 'dart:developer';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/components/MyNavigatorObserver.dart';
import 'package:welfare_claim_system/components/annoucement.dart';
import 'package:welfare_claim_system/components/config.dart';
import 'package:welfare_claim_system/pages/admission.dart';
import 'package:welfare_claim_system/pages/area.dart';
import 'package:welfare_claim_system/pages/menu.dart';
import 'package:welfare_claim_system/pages/reimbursement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
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
     if (!mounted) return; // Ensure the widget is still in the tree
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
     navigatorObservers: [MyNavigatorObserver()],
      initialRoute: widget.isLoggedIn
          ? (widget.isSelectedArea ? '/Menu' : '/Area')
          : '/',
      routes: {
        '/': (context) => MyHomePage(title: App.title, toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
        '/Area': (context) => Area(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
        '/Menu': (context) => Menu(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
        '/Admission': (context) => Admission(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
        '/Reimbursement': (context) => Reimbursement(toggleTheme: _toggleTheme, isDarkMode: isDarkMode),
      },
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
      // home: MyHomePage(title: App.title, toggleTheme: _toggleTheme, isDarkMode: isDarkMode)
      // home: widget.isLoggedIn ? //if logint alrady 
      // (widget.isSelectedArea ?  // check if have area
      // Menu(toggleTheme: _toggleTheme, isDarkMode: isDarkMode) :
      // Area(toggleTheme: _toggleTheme, isDarkMode: isDarkMode) ) : 
      // MyHomePage(title: App.title, toggleTheme: _toggleTheme, isDarkMode: isDarkMode),

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 40,
              right: 40
            ),
            child: AnnoucementTile(
            itemList: [
              CarouselItem(
                image: const NetworkImage(
                  'https://miro.medium.com/max/1400/1*RpaR1pTpRa0PUdNdfv4njA.png',
                ),
                title:'Push your creativity to its limits by reimagining this classic puzzle!',
                titleTextStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                leftSubtitle: '\$51,046 in prizes',
                onImageTap: (i) {},
              ),
              CarouselItem(
                image: const NetworkImage(
                  'https://pbs.twimg.com/profile_banners/1444928438331224069/1633448972/600x200',
                ),
                title: '@coskuncay published flutter_custom_carousel_slider!',
                titleTextStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                leftSubtitle: '11 Feb 2022',
                onImageTap: (i) {},
              ),
            ],
                    ),
          ),
          Padding(
                padding: const EdgeInsets.only(top:50.0),
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
                                try {
                                  await notification_toast(
                                    context,
                                    "Username",
                                    "Please enter valid username",
                                    toastificationType: ToastificationType.error,
                                    toastificationStyle: ToastificationStyle.fillColored,
                                    descTextColor: Colors.white,
                                    icon: const Icon(Icons.error),
                                  );
                                } catch (e) {
                                  // Handle any errors that might occur during the toast notification
                                  print("Error showing toast notification: $e");
                                }
          
                               
          
                                FocusScope.of(context).requestFocus(usernameFocus);
                              } else if (enteredPassword.isEmpty) {
                                try {
                                  await notification_toast(
                                    context,
                                    "Password",
                                    "Please enter valid password",
                                    toastificationType: ToastificationType.error,
                                    toastificationStyle: ToastificationStyle.fillColored,
                                    descTextColor: Colors.white,
                                    icon: const Icon(Icons.error),
                                  );
                                 } catch (e) {
                                  // Handle any errors that might occur during the toast notification
                                  print("Error showing toast notification: $e");
                                }
                                FocusScope.of(context).requestFocus(passwordFocus);
                              } else {
                                loading(context, "Please wait...",widget.isDarkMode);
                               
                                try {
                                  var response = await Login('login', enteredUsername, enteredPassword);
                                  log(response.toString());
          
                                  
          
          
                                  if (response.statusCode == 200) {
                                      Map<String, dynamic> responseData = json.decode(response.body);
                                       bool success = responseData['success'] ?? false;
                                      closeDialog(context);
                                      if (success) {
                                      // Process the data
                                      List<dynamic> data = responseData['data'];
                                    for (var employee in data) {
                                      String empId = employee['EMPID'];
                                      String name = employee['EMPL_NAME'];
                                      String department = employee['DEPARTMENT'];
                                      String country = employee['COUNTRY'];
                                      String position = employee['POSITION'];
                                      String bu_code = employee['BU_CODE'];
                                      String businessUnit = employee['BUSINESS_UNIT'];
                                      String email = employee['EMAIL'];
                                      String contactNumber = employee['CONTACT_NUMBER'];
          
                                      // Create a map for each employee
                                      Map<String, String> employeeInfo = {
                                        EMPID: empId,
                                        EMPL_NAME: name,
                                        DEPARTMENT: department,
                                        COUNTRY: country,
                                        POSITION: position,
                                        BU_CODE: bu_code,
                                        BUSINESS_UNIT: businessUnit,
                                        EMAIL: email,
                                        CONTACT_NUMBER: contactNumber
                                      };
          
                                      // Save employeeInfo
                                      bool success = await saveEmployeeInfo(employeeInfo);
                                      if (success) {
                                        print("Employee information for $name saved successfully");
                                      } else {
                                        print("Failed to save employee information for $name");
                                      }
                                    }
                                  
                                        bool saved = await setLoginStatus(true);
                                        if (saved) {
                                          print('Login status saved successfully.');
                                           String credentials = '$enteredUsername:$enteredPassword';
                                           String encodedCredentials = base64Encode(utf8.encode(credentials));
                                          locStorage(App.Auth,encodedCredentials);
                                        } else {
                                          print('Failed to save login status.');
                                        }
                                       
                                        intent(context, Area(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),'/Area');
          
          
          
                                    } else {
                                      print('Login not successful. Response data: ${response.body}');
                                      try {
                                        await notification_toast(
                                          context,
                                          "Invalid username/password",
                                          responseData['message'],
                                          toastificationType: ToastificationType.error,
                                          toastificationStyle: ToastificationStyle.fillColored,
                                          descTextColor: Colors.white,
                                          icon: const Icon(Icons.error),
                                        );
                                      } catch (e) {
                                        // Handle any errors that might occur during the toast notification
                                        print("Error showing toast notification: $e");
                                      }
                                    }
          
          
                                  } else {
                                    // Handle error response
                                    print('Login failed: ${response.statusCode} ${response.body}');
                                    try {
                                      await notification_toast(
                                          context,
                                          "Invalid username/password",
                                          response.statusCode.toString(),
                                          toastificationType: ToastificationType.error,
                                          toastificationStyle: ToastificationStyle.fillColored,
                                          descTextColor: Colors.white,
                                          icon: const Icon(Icons.error),
                                        );
                                      } catch (e) {
                                        // Handle any errors that might occur during the toast notification
                                        print("Error showing toast notification: $e");
                                      }
                                      print('Request failed with status: ${response.statusCode}');
                                  }
                                } catch (e) {
                                  // Handle any errors that occurred during the request
                                  print('An error occurred: $e');
                                  try {
                                    closeDialog(context);
                                   await notification_toast(
                                      context,
                                      "Login",
                                      "Invalid Response",
                                      toastificationType: ToastificationType.error,
                                      toastificationStyle: ToastificationStyle.fillColored,
                                      descTextColor: Colors.white,
                                      icon: const Icon(Icons.error),
                                    );
                                  } catch (e) {
                                    // Handle any errors that might occur during the toast notification
                                    print("Error showing toast notification: $e");
                                  }
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
        ],
      ),
    );
  }
}
