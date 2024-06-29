
import 'dart:convert';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/model/medicalneed.dart';

Future<bool> medicalneeds(Function(Function()) setState, List<MedicalNeedItem> medicalNeeds, bool isLoadData) async {
  try {
    var response = await api_medicalNeeds('medical_needs');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      bool success = responseData['success'];

      if (success) {
        List<dynamic> data = responseData['data'];
        List<MedicalNeedItem> loadedSubMenuItems = data.map((item) => MedicalNeedItem.fromJson(item)).toList();
        setState(() {
          medicalNeeds.clear();
          medicalNeeds.addAll(loadedSubMenuItems);
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