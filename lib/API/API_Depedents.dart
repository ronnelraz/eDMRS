import 'dart:convert';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/model/dependents.dart';

Future<bool> apidependents(Function(Function()) setState, List<DependentsItem> dependents,Map<String, dynamic> payload, bool isLoadData,) async {
  try {
    var response = await api('dependents',payload);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      bool success = responseData['success'];

      if (success) {
        List<dynamic> data = responseData['data'];
        List<DependentsItem> loadItems = data.map((item) => DependentsItem.fromJson(item)).toList();
        setState(() {
          dependents.clear();
          dependents.addAll(loadItems);
          isLoadData = false;
        });
        return true;
      } else {
        setState(() {
          isLoadData = false;
        });
        return false;
      }
    } else {
      setState(() {
        isLoadData = false;
      });
      return false;
    }
  } catch (e) {
    setState(() {
      isLoadData = false;
    });
    return false;
  }
}