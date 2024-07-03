import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/components/config.dart'; // Assuming this is where your API service is defined

Future<Map<String, dynamic>> apisaveHeader(Map<String, dynamic> payload, BuildContext dialog, bool isDarkMode) async {
  try {
     loading(dialog, "Please wait...");
    var response = await saveHeader('header',payload); // Assuming apihospital is a function to fetch hospitals
   
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      bool success = responseData['success'];
      String message = responseData['message'];
      Navigator.pop(dialog);
      return {
        'success': success,
        'message': message,
      };
       
    } else {
       Navigator.pop(dialog);
      return {
        'success': false,
        'message': 'Failed to connect to server',
      };
    }
  } catch (e) {
     Navigator.pop(dialog);
    return {
      'success': false,
      'message': 'Error: $e',
    };
  }
}
