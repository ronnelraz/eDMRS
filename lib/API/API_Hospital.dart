
import 'dart:convert';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/model/hospitals.dart';


Future<bool> hospitalList(Function(Function()) setState, List<HospitalsItem> hospitals, bool isLoadData) async {
  try {
    var response = await apihospital('getHospital');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      bool success = responseData['success'];

      if (success) {
        List<dynamic> data = responseData['data'];
        List<HospitalsItem> loadedHospitalItems = data.map((item) => HospitalsItem.fromJson(item)).toList();
        setState(() {
          hospitals.clear();
          hospitals.addAll(loadedHospitalItems);
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