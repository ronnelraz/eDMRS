import 'package:edmrs/main.dart';
import 'package:edmrs/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
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

const List<String> _list = [
  'Area1',
  'Area2',
];

class _AreaState extends State<Area> {
   String? _selectedArea;

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
                child: CustomDropdown<String>(
                  hintText: 'Select Area',
                  items: _list,
                  decoration: CustomDropdownDecoration(
                    expandedFillColor: widget.isDarkMode ? const Color.fromARGB(255, 66, 66, 66) : const Color.fromARGB(255, 255, 255, 255),
                    closedFillColor: widget.isDarkMode ? const Color.fromARGB(255, 66, 66, 66) : Colors.white,
                    
                    closedBorder: Border.all( // Using BoxBorder with Border.all for a simple solid border
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      width: 1.0,
                    ),
                    expandedBorder:  Border.all( // Using BoxBorder with Border.all for a simple solid border
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      width: 1.0,
                    ),
                    
                  ),
                  onChanged: (value) {
                    // _selectedArea = value;
                    setState(() {
                      _selectedArea = value;
                    });
                    
                  
                  },
                ),
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
                          

                            // bool saved = await setLoginStatus(true);
                            //     if (saved) {
                            //       print('Login status saved successfully.');
                                
                            //     } else {
                            //       print('Failed to save login status.');
                            //     }
                            intent(context, Menu(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode));

                        } else {
                          print('Please select an area');
                          await notification_toast(
                            context,
                            "Location Selection Required",
                            "Oops! It seems like you haven't selected a location yet. Please choose one to continue. Thank you!",
                            toastificationType: ToastificationType.info,
                            toastificationStyle: ToastificationStyle.fillColored,
                            descTextColor: Colors.white,
                            icon: const Icon(Icons.info),
                          );
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
                          intent(context, MyHomePage(title: App.title, toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode));
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
