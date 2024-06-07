import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String loginKey = "isLoggedIn";
const String fullName = "fullName";
const String islandCode = "islandCode";
const String islandShortName = "islandShortName";
const String islandName = "islandName";
const String operation = "operation";
const String darkModeKey = "isDarkMode";


const String EMPID = "EMPID";
const String EMPL_NAME = "EMPL_NAME";
const String DEPARTMENT = "DEPARTMENT";
const String COUNTRY = "COUNTRY";
const String POSITION = "POSITION";
const String BU_CODE = "BU_CODE";
const String BUSINESS_UNIT = "BUSINESS_UNIT";
const String EMAIL = "EMAIL";
const String CONTACT_NUMBER = "CONTACT_NUMBER";

const String LOCATION_CODE = "LOCATION_CODE";
const String LOCATION_NAME = "LOCATION_NAME";
const String LOCATION_BU_CODE = "LOCATION_BU_CODE";


Future<bool> saveEmployeeInfo(Map<String, String> employeeInfo) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  employeeInfo.forEach((key, value) async {
    await prefs.setString(key, value);
  });
  return true;
}


Future<Map<String, String>> getEmployeeInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> employeeInfo = {};

  // Add all the keys you want to retrieve here
  List<String> keys = [
    EMPID, EMPL_NAME, DEPARTMENT, COUNTRY, POSITION, BU_CODE, BUSINESS_UNIT, EMAIL, CONTACT_NUMBER
  ];

  for (String key in keys) {
    if (prefs.containsKey(key)) {
      String? value = prefs.getString(key);
      if (value != null) {
        employeeInfo[key] = value;
      }
    }
  }
  return employeeInfo;
}

Future<bool> saveSelectedLocation(Map<String, String> location) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  location.forEach((key, value) async {
    await prefs.setString(key, value);
  });
  return true;
}






// Save dark mode status to SharedPreferences
Future<bool> setDarkMode(bool isDarkMode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool success = await prefs.setBool(darkModeKey, isDarkMode);
  return success;
}

// Retrieve dark mode status from SharedPreferences
Future<bool> getDarkMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool(darkModeKey) ?? false;
  return isDarkMode;
}




Future<bool> operations(List<Map<String, String>> array) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(array); // Convert the array to a JSON string
  bool success = await prefs.setString(operation, jsonString); // Save the JSON string with the key 'operations'
  return success;
}

Future<List<Map<String, String>>?> getOperations() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(operation); 
  if (jsonString == null) {
    // If no data is found, return null or handle the absence of data as needed
    return null;
  }
  // Decode the JSON string back into a List<Map<String, String>>
  List<dynamic> decodedData = jsonDecode(jsonString);
  List<Map<String, String>> operationsList = decodedData.map((item) {
    return Map<String, String>.from(item);
  }).toList();
  return operationsList;
}


// Save login status to SharedPreferences
Future<bool> setFullName(String d) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool success = await prefs.setString(fullName, d);
  return success;
}

Future<bool> setIslandCode(String d) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool success = await prefs.setString(islandCode, d);
  return success;
}

Future<bool> setIslandShortName(String d) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool success = await prefs.setString(islandShortName, d);
  return success;
}

Future<bool> setIslandName(String d) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool success = await prefs.setString(islandName, d);
  return success;
}

 
// Save login status to SharedPreferences
Future<bool> setLoginStatus(bool isLoggedIn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool success = await prefs.setBool(loginKey, isLoggedIn);
  return success;
}


// Retrieve login status from SharedPreferences
Future<bool> getLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool(loginKey) ?? false;
  return isLoggedIn;
}


// Retrieve login status from SharedPreferences
Future<String> getFullName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String d = prefs.getString(fullName) ?? "default";
  return d;
}

Future<String> getIslandName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String d = prefs.getString(islandName) ?? "default";
  return d;
}