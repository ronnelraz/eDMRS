
import 'dart:async';
import 'dart:convert';

import 'package:card_loading/card_loading.dart';
import 'package:edmrs/API/api_service.dart';
import 'package:edmrs/components/custom_rich_text.dart';
import 'package:edmrs/pages/admission.dart';
import 'package:edmrs/sharedpref/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../components/config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../components/loading.dart';


class Menu extends StatefulWidget {
  
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  Menu({required this.toggleTheme, required this.isDarkMode});


  @override
  _MenuState createState() => _MenuState();
  
}



class _MenuState extends State<Menu> {
   Map<String, String> _employeeInfo = {};
   bool _isLoading = true;
   bool _isLoadingScreen = true;
   List<String> _bal_name = [];
   List<String> _bal_amount = [];
   bool _isloadingBal = true;
   late Timer _timer;
    int _counter = 0;
   
   

   @override
  void initState() {
    super.initState();
    
    _loadEmployeeInfo();
    dataLoadFunction();

    
    Future.delayed(Duration(seconds: 5), () {
      _LoadBalance();
       _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
            _LoadBalance();
          });
      });
    });
    
    // if (kIsWeb) {
    //     pages().then((page) {
    //         if (page != null) {
    //           if(page == 'admission'){
    //               intent(context, Admission(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode));
    //           }
    //         } 
    //         else {
    //             callLocStorage();
    //         }
    //       });
    // } else {
      
    // }
  }

  Future<void> _LoadBalance() async {
    try {

      Map<String, String> body = {
        'year': '2024',
        'empid': _employeeInfo[EMPID] ?? '',
      };
      
      var response = await balance('getBalance',body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        bool success = responseData['success'];

        if (success) {
          List<dynamic> data = responseData['data'];
          List<String> bal_name = data.map((item) => item['BAL_NAME'].toString()).toList();
          List<String> bal_amount = data.map((item) => item['BAL_AMOUNT'].toString()).toList();
          setState(() {
            
            _bal_name = bal_name;
            _bal_amount = bal_amount;
            _isloadingBal = false;
   
          });
         
        } else {
          print('Login not successful. Response data: ${response.body}');
          setState(() {
            _isloadingBal = false;
          });
        }
      } else {
        print('Login failed: ${response.statusCode} ${response.body}');
        setState(() {
          _isloadingBal = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        _isloadingBal = false;
      });
    }
  }

   dataLoadFunction() async {
    setState(() {
      _isLoadingScreen = true; // your loader has started to load
    });
   
   await Future.delayed(Duration(seconds: 3));

    Map<String, String> info = await getEmployeeInfo();

    setState(() {
      _employeeInfo = info;
      _isLoadingScreen = false; // your loder will stop to finish after the data fetch
    });
  }

   Future<void> _loadEmployeeInfo() async {
    Map<String, String> info = await getEmployeeInfo();
    setState(() {
      _employeeInfo = info;
      _isLoading = false;
    });
  }

   void callLocStorage() {
    locStorage("page", "menu");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return 
     _isLoadingScreen
    ? const CustomLoading(img: 'assets/logo.png', text: 'Loading',)    
    : Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(App.title,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700
                )
            ), // Title
            const Text(
              App.Subtitle, // Subtitle
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
        leading: buildImage('assets/logo.png', 40, 40, Alignment.centerRight), // Icon
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0), // Adjust the margin as needed
            child: IconButton(
              icon: Icon(widget.isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
              onPressed: widget.toggleTheme,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), // Adjust the margin as needed
            child: Row(
              children: [
                TextButton(
                  onPressed: () {

                  },
                  child: Row(
                    children: [
                      buildSvgPicture(
                        'assets/icon_toast/logout.svg',
                        BoxFit.scaleDown,
                        width: 18,
                        height: 18,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 802) {
                  return buildWideLayout(context,constraints,400.0);
                } else {
                  return buildNarrowLayout(context,constraints,700.0);
                }
              },
      ),
    );
  }

  Widget buildWideLayout(BuildContext context, BoxConstraints constraints,double cardwidth) {
    return 
    _isLoading
    ? SpinKitDoubleBounce(
      color: widget.isDarkMode ? Colors.white : Colors.blue[700],
      size: 50.0,
    )
    : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(1.0), // Adjust the padding as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLeftColumn(cardwidth),
              buildRightColumn(cardwidth),
            ],
          ),
        ),
         buildFourColumnGrid(constraints,cardwidth,constraints.maxWidth ~/ 210)
      ],
    );
  }

  Widget buildNarrowLayout(BuildContext context,BoxConstraints constraints,double cardwidth) {
    return 
    _isLoading
    ? SpinKitChasingDots(
      color: widget.isDarkMode ? Colors.white : Colors.blue[700],
      size: 50.0,
    )
    : SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0), // Adjust the padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLeftColumn(cardwidth),
            const SizedBox(height: 1),
            buildRightColumn(cardwidth),
            const SizedBox(height: 1),
            buildFourColumnGrid(constraints,cardwidth,2),
          ],
        ),
      ),
    );
  }


Widget buildFourColumnGrid(BoxConstraints constraints, double cardWidth, int crossAxisCount) {
  double spacing = 10.0; // Define your spacing value here

  double screenWidth = constraints.maxWidth;
  double sidePadding = (screenWidth > 802) ? (screenWidth - 802) / 2 : 16; // Adjust the 802 as needed
  double cardWidth = (screenWidth - sidePadding * 2 - (4 - 1) * 10) / 4; // 4 columns and 10 spacing
  final iconSize = screenWidth < 802 ? 90.0 : 100.0;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ResponsiveGridRow(
          children: List.generate(
            Menutitle.length,
            (index) => ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    splashColor: Colors.blue.withOpacity(0.5),
                    highlightColor: Colors.blue.withOpacity(0.5),
                    onTap: () {
                      if (index == 0) {
                      alert(
                        "IMPORTANT NOTICE",
                        "This accredited hospital request form is specifically designed for employees who have availed the hospitalization benefit at our affiliated hospitals. Please do not use this form for your Medical Expense Reimbursement.",
                        context,
                        onConfirm: () {
                           Navigator.of(context, rootNavigator: true).pop();
                           Navigator.pushNamed(context, '/Admission');
                          // intent(context, Admission(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),'/Admission');
                        },
                      );
                    }
                    if (index == 1) {
                      print("New Card tapped!");
                    }
                    },
                    child: Card(
                      elevation: App.elevation,
                      color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : Color.fromARGB(255, 255, 255, 255),
                      shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              buildImage(Menuicons[index], iconSize, iconSize, Alignment.center),
                              const SizedBox(height: 10),
                              Text(
                                Menutitle[index].toUpperCase(),
                                style: TextStyle(
                                  color: widget.isDarkMode ? Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  
Widget buildLeftColumn(double cardwidth) {
  return Container(
    //constraints: BoxConstraints(maxWidth: 400), // Set the maximum width here
    width: cardwidth, // Set the width here
    child: Card(
      elevation: App.elevation,
      color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : Color.fromARGB(255, 255, 255, 255),
      shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
      borderOnForeground: true,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        height: App.card_height,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                App.employee,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              CustomRichText(
                textBeforeSpan: getGreeting(),
                spanText: _employeeInfo[EMPL_NAME] ?? '',
                spanStyle: const TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: iconGreeting() == 'm' ? Icons.sunny : (iconGreeting() == 'a' ? Icons.wb_sunny_sharp : Icons.nights_stay),
                iconSize: 24.0,
                iconColor: iconGreeting() == 'm' ? const Color.fromARGB(255, 193, 174, 1) : (iconGreeting() == 'a' ? Colors.orange : const Color.fromARGB(255, 91, 91, 91)),
              ),
               CustomRichText(
                textBeforeSpan: '',
                spanText: _employeeInfo[POSITION] ?? '',
                spanStyle: const TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.info_outline_rounded,
                iconSize: 24.0,
                iconColor: Colors.blue,
              ),
               CustomRichText(
                textBeforeSpan: '',
                spanText: _employeeInfo[DEPARTMENT] ?? '',
                spanStyle: const TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.work,
                iconSize: 24.0,
                iconColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


Widget buildRightColumn(double width) {
  return Container(
    // constraints: BoxConstraints(maxWidth: 400), // Set the maximum width here
     width: width, 
    child: Card(
      color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : Color.fromARGB(255, 255, 255, 255),
      shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
      borderOnForeground: true,
      elevation: App.elevation,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:  SizedBox(
        height: App.card_height,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                App.currentBal,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
                _isloadingBal ? 
                 CardLoading(
                  height: 25,
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  width: width,
                  margin: EdgeInsets.only(top: 8),
                )
               :
                 CustomRichText(
                textBeforeSpan: _bal_name[0],
                spanText:  ' ₱${NumberFormat('#,###').format(int.parse(_bal_amount[0]))}',
                spanStyle: TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.wallet_rounded,
                iconSize: 24.0,
                iconColor: Colors.blueAccent,
              ),
               _isloadingBal ? 
                 CardLoading(
                  height: 25,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  width: width,
                  margin: EdgeInsets.only(top:12),
                )
               :
                 CustomRichText(
                textBeforeSpan: _bal_name[1],
                spanText:  ' ₱${NumberFormat('#,###').format(int.parse(_bal_amount[1]))}',
                spanStyle: TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.wallet_rounded,
                iconSize: 24.0,
                iconColor: Colors.blueAccent,
              )
             
            ],
          ),
        ),
      ),
    ),
  );
}


}
