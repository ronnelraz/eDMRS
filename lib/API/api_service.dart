// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import '../components/config.dart';


Future<http.Response> postData(String url, Map<String, String> body) async {
  try {
    var response = await http.post(Uri.parse(App.baseURL+url), body: body);
    return response;
  } catch (e) {
    // Exception occurred during the request
    print('Error: $e');
    throw Exception('Failed to post data: $e'); // throw an exception
  }
}
