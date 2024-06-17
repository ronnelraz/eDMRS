import 'dart:convert';

import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';

import '../components/config.dart';
import '../components/custom_button.dart';
import '../sharedpref/sharedpref.dart';

class Area extends StatefulWidget {
  
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  Area({required this.toggleTheme, required this.isDarkMode});


  @override
  _AreaState createState() => _AreaState();
}



class _AreaState extends State<Area> {
   String? _selectedArea;
   List<String> _list = [];
   List<String> _loc_code = [];
   List<String> _loc_bu_code = [];
   bool _isLoading = true;
   int? _selectedIndex;

  String _selectedCode = "";
   String _selectedBU = "";

   @override
    void initState() {
      super.initState();
      _loadData();
    }

  Future<void> _loadData() async {
    try {
      var response = await getlocation('getLocation');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        bool success = responseData['success'];

        if (success) {
          try {
              List<dynamic> data = responseData['data'];
            List<String> locations = data.map((item) => item['location_name'].toString()).toList();
            List<String> location_code = data.map((item) => item['location_code'].toString()).toList();
            List<String> bu_code = data.map((item) => item['bu_code'].toString()).toList();
            setState(() {
              _list = locations;
              _loc_code = location_code;
              _loc_bu_code = bu_code;

              _isLoading = false;
            });
          }
          catch (e) {
            print("Error fetching data: $e");
          }
        } else {
          print('Login not successful. Response data: ${response.body}');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Login failed: ${response.statusCode} ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 32.0, right: 32.0 ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Lottie.asset('assets/lottie/area.json',repeat: false, width: 100, backgroundLoading: true),
             const SizedBox(height: 20),
            const Text(
                'Select Location', // Add logic to display the selected area here
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400, // Adjust the width as needed
                child: _isLoading
              ? SpinKitDoubleBounce(
                color: widget.isDarkMode ? Colors.white : Colors.blue[700],
                size: 50.0,
              )
              : (_list.isNotEmpty
                ? CustomDropdown<String>(
                  hintText: 'Select Location',
                  items: _list,
                  decoration: CustomDropdownDecoration(
                    expandedFillColor: widget.isDarkMode
                        ? const Color.fromARGB(255, 66, 66, 66)
                        : const Color.fromARGB(255, 255, 255, 255),
                    closedFillColor: widget.isDarkMode
                        ? const Color.fromARGB(255, 66, 66, 66)
                        : Colors.white,
                    closedBorder: Border.all(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      width: 1.0,
                    ),
                    expandedBorder: Border.all(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      width: 1.0,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedArea = value;
                      _selectedIndex = _list.indexOf(value!);
                     _selectedCode = _loc_code[_selectedIndex!];
                     _selectedBU = _loc_bu_code[_selectedIndex!];

                     

                    });
                  },
                )
                : Text(
                  'No locations available. Please try again later.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                )),
              ),
              const SizedBox(height: 20),
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150, // Set the desired width
                    child: CustomButtonWithIcon(
                      icon: 'assets/icon_toast/check-circle.svg',
                      label: 'Continue',
                      onPressed: () async {
                        if (_selectedArea != null) {
                          print('Selected Area: $_selectedArea');
                          locStorage(App.Login_area,encrypted(_selectedArea!));
                          String _getSelectedArea = _selectedArea ?? '';
                          String _getSelectedLocCode = _selectedCode ?? '';
                          String _getSeletedLocBuCode = _selectedBU ?? '';

                          
                            // Create a map for each employee
                            Map<String, String> location = {
                              LOCATION_CODE: _getSelectedArea,
                              LOCATION_NAME: _getSelectedLocCode,
                              LOCATION_BU_CODE: _getSeletedLocBuCode
                            };

                            // Save employeeInfo
                            bool success = await saveSelectedLocation(location);
                            if (success) {
                              print("Employee location $_getSelectedArea saved successfully");
                            } else {
                              print("Failed to save employee location $_getSelectedArea");
                            }

                          intent(context, Menu(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),'/Menu');

                        } else {
                          print('Please select an area');
                           try {
                            await notification_toast(
                              context,
                              "Location Selection Required",
                              "Oops! It seems like you haven't selected a location yet. Please choose one to continue. Thank you!",
                              toastificationType: ToastificationType.info,
                              toastificationStyle: ToastificationStyle.fillColored,
                              descTextColor: Colors.white,
                              icon: const Icon(Icons.info),
                            );
                          } catch (e) {
                            // Handle any errors that might occur during the toast notification
                            print("Error showing toast notification: $e");
                          }
                        } 
                      },
                      color: widget.isDarkMode ? Color.fromARGB(255, 38, 130, 196) : App.primaryButton,
                      iconColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 20), // Add some spacing between buttons
                  Container(
                    width: 150, // Set the desired width
                    child: CustomButtonWithIcon(
                      icon: 'assets/icon_toast/logout.svg',
                      label: 'Logout',
                      onPressed: () async {
                        WidgetsFlutterBinding.ensureInitialized();
                        await initLocalStorage();
                        String? user = localStorage.getItem(App.Auth);

                      
                        alert(
                          "Logout",
                          "Are you sure you want logout?", 
                          context,
                          onConfirm: () async {
                          bool saved = await setLoginStatus(false);
                            if (saved) {
                              print('outout status saved successfully.');
                            } else {
                              print('Failed to save logout status.');
                            }
                              // intent(context, MyHomePage(title: App.title, toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),'/');
                               Navigator.pushNamed(context, '/');
                          
                          });
                        
                      },
                      color: widget.isDarkMode ? Colors.grey : Colors.blueGrey,
                      iconColor: Colors.white,
                    ),
                  ),
                ],
              ),            
            ],
          ),
        )
      ),
    );
  }
}
