// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import '../components/config.dart';


Future<http.Response> postData(String url, Map<String, String> body) async {
  try {
    var response = await http.post(Uri.parse(App.baseURLNEW+url), body: body);
    return response;
  } catch (e) {
    // Exception occurred during the request
    print('Error: $e');
    throw Exception('Failed to post data: $e'); // throw an exception
  }
}

Future<http.Response> Login(String url, String username, String password) async {
  try {
    // Combine username and password
    String credentials = '$username:$password';
    String encodedCredentials = base64Encode(utf8.encode(credentials));
    Map<String, String> headers = {
      'authorization': 'Basic $encodedCredentials'
    };

    var response = await http.post(
      Uri.parse(App.baseURLNEW + url),
      headers: headers
    );

    log('Encoded credentials: $encodedCredentials');
    log('Response: ${response.body}'); // Log the response body

    return response;
  } catch (e) {
    // Exception occurred during the request
    print('Error: $e');
    throw Exception('Failed to post data: $e'); // Throw an exception
  }
}

Future<http.Response> Location(String url) async {
  try {
    // Combine username and password
    WidgetsFlutterBinding.ensureInitialized();
    await initLocalStorage();
    String encodedCredentials = localStorage.getItem(App.Auth) ?? '';
    Map<String, String> headers = {
      'authorization': 'Basic $encodedCredentials'
    };

    var response = await http.post(
      Uri.parse(App.baseURLNEW + url),
      headers: headers,
    );

    return response;
  } catch (e) {
    // Exception occurred during the request
    print('Error: $e');
    throw Exception('Failed to post data: $e'); // Throw an exception
  }
}


Future<http.Response> Hospital(String url) async {
  try {
    // Combine username and password
    WidgetsFlutterBinding.ensureInitialized();
    await initLocalStorage();
    String encodedCredentials = localStorage.getItem(App.Auth) ?? '';
    Map<String, String> headers = {
      'authorization': 'Basic $encodedCredentials'
    };

    var response = await http.post(
      Uri.parse(App.baseURLNEW + url),
      headers: headers,
    );

    return response;
  } catch (e) {
    // Exception occurred during the request
    print('Error: $e');
    throw Exception('Failed to post data: $e'); // Throw an exception
  }
}


Future<http.Response> balance(String url, Map<String, dynamic> body) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await initLocalStorage();
    String encodedCredentials = localStorage.getItem(App.Auth) ?? '';
    Map<String, String> headers = {
      'authorization': 'Basic $encodedCredentials',
      'Content-Type': 'application/json', // Specify the content type as JSON
    };

    var response = await http.post(
      Uri.parse(App.baseURLNEW + url),
      headers: headers,
      body: jsonEncode(body), // Encode the body to JSON
    );

    return response;
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to post data: $e');
  }
}



Future<http.Response> getLocation(String url, Map<String, String> body) async {
  try {
    var response = await http.post(Uri.parse(App.baseURLNEW+url), body: body);
    return response;
  } catch (e) {
    // Exception occurred during the request
    print('Error: $e');
    throw Exception('Failed to post data: $e'); // throw an exception
  }
}
