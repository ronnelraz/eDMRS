// ignore_for_file: no_leading_underscores_for_local_identifiers, constant_identifier_names, non_constant_identifier_names, unused_local_variable, unused_import

import 'dart:async';
import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:toastification/toastification.dart';
import 'package:encrypt/encrypt.dart' as encrypt;



class App {
  static Color primaryColor = const Color(0xFFE1AA74);
  static String title =  "eDMRS";
  static Color border = const Color.fromRGBO(49, 101, 196,1);
  static Color textColor = const Color(0xFF000000);
  static Color textfieldBgColor = const Color.fromARGB(255, 255, 255, 255);
  static Color textcolor_white = const Color.fromARGB(255, 255, 255, 255);
  static Color primaryButton = Color.fromARGB(255, 63, 117, 251);
  static Color iconColor = Color.fromARGB(255, 0, 0, 0);
  static const String baseURL = 'https://agro.cpf-phil.com/api/PSCfood/home/';
  static const String baseURLNEW = 'https://agro.cpf-phil.com/edmrs/api/';
  static const String str_logout = 'Are you sure you want to logout?';
  static const String fontFamily = 'Urbanist';
  static const String Subtitle = 'Online Medical Record';
  static const String name = "Name : ";
  static const String position = "Position : ";
  static const String department = "Department : ";
  static const String currentBal = "Welfare Balance";
  static const String personalBal = "Personal : ";
  static const String dependentBal = "Dependent : ";
  static const String employee = "Employee Information";
  static const double card_height = 140.0;
  static const double card_textsize = 13;
  static const double elevation = 5.0;


// localstorage
  static const String Mykey = "oeH9boH6uboIubyu9eI96yabb@eyboue";
  static const String Login_area = "Login_Area";
  static const String Auth = "Auth";
 
}


String getGreeting() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour < 12) {
    return 'Hi! good morning ';
  } else if (hour < 17) {
    return 'Hello! good afternoon ';
  } else {
    return 'Hi! good evening ';
  }
}

String iconGreeting() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour < 12) {
    return 'm';
  } else if (hour < 17) {
    return 'a';
  } else {
    return 'e';
  }
}


Future<void> locStorage(String key, String value) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  localStorage.setItem(key, value);
  // String? tes = localStorage.getItem(key);
  // print(tes);  
}

Future<bool> getArea() async {
  await initLocalStorage();
  String? Area = localStorage.getItem(App.Login_area);
  return Area != null && Area.isNotEmpty;
}

Future<String> pages() async {
  await initLocalStorage();
  String? page = localStorage.getItem('page');
   return page ?? '';
}

String decrypt(String base64EncryptedData) {
  final key = encrypt.Key.fromUtf8(App.Mykey);
  final iv = encrypt.IV.fromUtf8(App.Mykey.substring(0, 16));
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encryptedBytes = base64.decode(base64EncryptedData);
  final encryptedData = encrypt.Encrypted(encryptedBytes);
  return encrypter.decrypt(encryptedData, iv: iv);
}

String encrypted(String plainText) {
    final key = encrypt.Key.fromUtf8(App.Mykey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final initVector = encrypt.IV.fromUtf8(App.Mykey.substring(0, 16));
    encrypt.Encrypted encryptedData = encrypter.encrypt(plainText, iv: initVector);
    return encryptedData.base64;
}



final Location location = Location();



void checkLocationPermission() async {
  final Location location = Location();
  location.enableBackgroundMode(enable: true);

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();
}



void intent(BuildContext context, Widget page,String newpage) {
  
  try {
  Navigator.pushNamed(context, newpage);
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (BuildContext context) => page,
  ));
  } catch (e) {
    print("Error navigating to page: $e");
  }
}

void Pages(BuildContext context, String page){
  Navigator.pushNamed(context, page);
}





Future<String> reverseGeocode(double latitude, double longitude) async {
  // Perform reverse geocoding operation
  final result = await NominatimGeocoding.to.reverseGeoCoding(
     Coordinate(latitude: latitude, longitude: longitude),
  );
  // Extract and return the address from the result
  return result.address.toString();
}




TextStyle builderStyle(double size, Color color, {FontWeight? fontWeight}) {
  return TextStyle(
    fontFamily: 'Urbanist',
    fontSize: size,
    color: color,
    fontWeight: fontWeight,
  );
}


Future<void> notification_toast(BuildContext context, String title ,String desc,{ToastificationType? toastificationType, ToastificationStyle? toastificationStyle, Color? descTextColor, Icon? icon} ){
  
  final completer = Completer(); // Create a Completer
  
  toastification.show(
    type: toastificationType,
    style: toastificationStyle,
    context: context, // optional if you use ToastificationWrapper
    title: Text(title),
     description: RichText(
      text: TextSpan(
        text: desc,
        style: TextStyle(color: descTextColor ?? Colors.black), // Setting text color for description
      ),
    ),
    alignment: Alignment.topRight,
    icon: icon,
    autoCloseDuration: const Duration(seconds: 3),
    showProgressBar: false,
    // animationDuration: const Duration(milliseconds: 300),
    // animationBuilder: (context, animation, alignment, child) {
    //   return FadeTransition(
    //     opacity: animation,
    //     child: child,
    //   );
    // },
  );
  // Return the Completer to allow awaiting its completion
  return completer.future;
}


Widget image(bool isDarkMode) {
  return SpinKitDoubleBounce(
    color: isDarkMode ? Colors.white : Colors.blue[700],
    size: 50.0,
  );
}

void loading(BuildContext context, String message, bool isDarkMode) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Color.fromARGB(139, 0, 0, 0),
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: isDarkMode ? Color.fromARGB(255, 70, 69, 69) : Color.fromRGBO(255, 255, 255, 1), // Semi-transparent black color
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            image(isDarkMode), 
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
      );
    },
  );
}


void closeDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}


void sweetAlert(BuildContext context, String title, String text, ArtSweetAlertType type, {Function? onConfirm, String? confirmText, Color? confirmButtonColor}) {
  ArtSweetAlert.show(
    context: context,
    artDialogArgs: ArtDialogArgs(
      type: type,
      title: title,
      text: text,
      onConfirm: onConfirm,
      showCancelBtn: true,
      confirmButtonText: confirmText ?? 'Confirm',
      confirmButtonColor: confirmButtonColor ?? const Color.fromARGB(255, 28, 108, 222)
    ),
  );
}






void toast(String msg){
  Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0,
        webPosition: 'center',
        webBgColor: '#1F1F1F'
    );
}

 void alert(String title, String msg, BuildContext context, {Function? onConfirm}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              // Navigator.of(context).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              // If onConfirm is not provided, simply close the dialog
              if (onConfirm != null) {
                onConfirm();
              }
            },
          ),
        ],
      );
    },
  );
}


void DialogSelectArea(String title, String msg, BuildContext context, List<String> items, {String? initialItem, Function? onConfirm}) {
  String? selectedValue = initialItem;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg),
            const SizedBox(height: 20),
            CustomDropdown<String>(
              hintText: 'Select Area',
              items: items,
              initialItem: initialItem,
              onChanged: (value) {
                selectedValue = value;
                // Log or perform any other action when value changes
                print('Selected value: $value');
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              // If onConfirm is not provided, simply close the dialog
              if (onConfirm != null) {
                onConfirm(selectedValue);
              }
              // Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




List<String> Menuicons = [
  'assets/menu/admission.png',
  'assets/menu/reimbursement.png',
  'assets/menu/appointment.png',
  'assets/menu/history.png'
];

List<String> Menutitle = [
  'Admission',
  'Reimbursement',
  'Appointment',
  'History'
];




SvgPicture buildSvgPicture(String icon, BoxFit boxFit, {double? width, double? height, Color? color}) {
  return SvgPicture.asset(
    icon,
    fit: boxFit,
    width: width,
    height: height,
    // ignore: deprecated_member_use
    color: color,
  );
}

SvgPicture buildSvgMenu(String icon, BoxFit boxFit, {double? width, double? height, Color? color}) {
  return SvgPicture.asset(
    icon,
    fit: boxFit,
    width: width,
    height: height,
    // ignore: deprecated_member_use
    color: color,
     alignment: Alignment.center
  );
}

Widget buildImage(String imagePath, double width, double height, AlignmentGeometry alignment) {
  return Container(
    alignment: alignment,
    child: Image.asset(
      imagePath,
      width: width,
      height: height,
    ),
  );
}

BoxDecoration buildBoxDecoration() {
  return BoxDecoration(
    border: Border.all(color: Colors.grey), // Add border
    borderRadius: BorderRadius.circular(10), // Add border radius
  );
}

InputDecoration buildInputDecoration(InputBorder inputBorder, String label, String hint) {
  return InputDecoration(
    border: inputBorder,
    labelText: label,
    hintText: hint,
  );
}


