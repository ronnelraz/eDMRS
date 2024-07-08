// ignore_for_file: no_leading_underscores_for_local_identifiers, constant_identifier_names, non_constant_identifier_names, unused_local_variable, unused_import

import 'dart:async';
import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:localstorage/localstorage.dart';
import 'package:location/location.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:toastification/toastification.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../sharedpref/sharedpref.dart';



class App {
  static Color primaryColor = const Color(0xFFE1AA74);
  static String title =  "Welfare Claim System";
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
  static const double card_height = 170.0;
  static const double card_textsize = 13;
  static const double elevation = 1.0;
  


static const String welfareNote = '''
Welfare Claim Procedure:
1. Fill-up welfare claim form and attach supporting documents
2. Submit documents to HR Dept. for checking
3. Retrieve documents from HR Dept. and have it approved by supervisor
4. Park document at SAP system for payment
5. Submit approved park document to Accounting Department.
''';


// localstorage
  static const String Mykey = "oeH9boH6uboIubyu9eI96yabb@eyboue";
  static const String Login_area = "Login_Area";
  static const String Auth = "Auth";
 
}

const Color colorGreen = Color(0xFF00964E);
const Color colorBlue = Color(0xFF01539F);
const Color colorWhite = Color(0xFFFFFFFF);
const Color colorDarkBlue = Color(0xFF2E4A70);
const Color colorOrange = Color(0xFFCF8A40);


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



void errorMessage(String title, String message,BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.orange, // Customize background color as needed
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(message),
        ],
      ),
      duration: Duration(seconds: 5), // Adjust duration as needed
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.black,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}


void logout(BuildContext context){
     PanaraConfirmDialog.showAnimatedGrow(
      context,
      barrierDismissible: false,
      title: "Logout",
      message: "Are you sure you want to sign out?",
      confirmButtonText: "Confirm",
      cancelButtonText: "Cancel",
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () async {
        bool saved = await setLoginStatus(false);
      if (saved) {
        print('outout status saved successfully.');
      } else {
        print('Failed to save logout status.');
      }
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/');
      },
      panaraDialogType: PanaraDialogType.warning,
    );
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
  return SpinKitFadingCircle(
    color: isDarkMode ? Colors.white : Colors.blue[700],
    size: 50.0,
  );
}

void loading(BuildContext context, String message, {bool isDarkMode = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color.fromARGB(139, 0, 0, 0),
    builder: (BuildContext context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 130.0), // Adjust the margin as needed
          child: Card(
            color: isDarkMode ? const Color.fromARGB(255, 70, 69, 69) : const Color.fromRGBO(255, 255, 255, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  image(isDarkMode),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

int getCurrentYear() {
  DateTime now = DateTime.now();
  int currentYear = now.year;
  return currentYear;
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

void alert(String title, String msg, BuildContext context, {Function? onConfirm, String? icon, Color? colorIcon}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null && icon.isNotEmpty)
            buildSvgPicture(
              icon, 
              BoxFit.cover,
              width: 80,
              height: 80,
              color: colorIcon
            ),
            SizedBox(height: icon != null && icon.isNotEmpty ? 20 : 10), 
            Text(title),
          ],
        ),
        content: Text(
          msg,
          textAlign: TextAlign.left,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              if (onConfirm != null) {
                onConfirm();
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
          ),
        ],
      );
    },
  );
}


String convertDateFormat(String inputDate) {
 
  List<String> dateParts = inputDate.split('/');

  // Ensure there are three parts (MM, dd, YYYY)
  if (dateParts.length != 3) {
    return ''; // Invalid format handling
  }

  // Extract parts
  int month = int.tryParse(dateParts[0]) ?? 0; // Month (MM)
  int day = int.tryParse(dateParts[1]) ?? 0;   // Day (dd)
  int year = int.tryParse(dateParts[2]) ?? 0;  // Year (YYYY)

  // Create DateTime object
  DateTime dateTime = DateTime(year, month, day);

  // Format DateTime to YYYY-MM-dd
  String formattedDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

  return formattedDate;
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
              if (onConfirm != null) {
                onConfirm(selectedValue);
              }
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
  'assets/menu/history.png',
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

Widget buildImageURL(String imageUrl, double width, double height, AlignmentGeometry alignment) {
  return Container(
    alignment: alignment,
    child:  CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      alignment: Alignment.center,
      placeholder: (context, url) => const SizedBox(
        width: 10, 
        height: 10, 
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error, size: 10), // Adjust the size if needed
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


