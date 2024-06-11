
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:card_loading/card_loading.dart';
import 'package:edmrs/API/api_service.dart';
import 'package:edmrs/components/custom_bal.dart';
import 'package:edmrs/components/custom_icon.dart';
import 'package:edmrs/components/custom_rich_text.dart';
import 'package:edmrs/sharedpref/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../components/config.dart';


import '../components/loading.dart';


class Menu extends StatefulWidget {
  
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const Menu({super.key, required this.toggleTheme, required this.isDarkMode});


  @override
  // ignore: library_private_types_in_public_api
  _MenuState createState() => _MenuState();
  
}



class _MenuState extends State<Menu> {
   Map<String, String> _employeeInfo = {};
   bool _isLoading = true;
   bool _isLoadingScreen = true;
   // ignore: non_constant_identifier_names
   List<String> _bal_name = [];
   // ignore: non_constant_identifier_names
   List<String> _bal_amount = [];
   bool _isloadingBal = true;
   late Timer _timer = Timer(const Duration(seconds: 0), () {});
   
  
   @override
  void initState() {
    super.initState();
    _initializeData();;
  }

 @override
  void dispose() {
    _timer.cancel();  
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _loadEmployeeInfo();
    await dataLoadFunction();
    _startBalanceLoading();
  }

  Future<void> _loadEmployeeInfo() async {
    try {
      Map<String, String> info = await getEmployeeInfo();
      setState(() {
        _employeeInfo = info;
         _isLoading = false;
      });
    } catch (e) {
      log('Error loading employee info: $e');
    }
  }

  Future<void> dataLoadFunction() async {
   

    await Future.delayed(const Duration(seconds: 3));  

    setState(() {
      _isLoadingScreen = false; 
    });
  }

  void _startBalanceLoading() {
    Future.delayed(const Duration(seconds: 5), () {
      loadBalance();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
           loadBalance();
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> loadBalance() async {
    try {
      Map<String, String> body = {
        'year': '2024',
        'empid': _employeeInfo['EMPID'] ?? '',
      };

      var response = await balance('getBalance', body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        bool success = responseData['success'];

        if (success) {
          List<dynamic> data = responseData['data'];
          List<String> balName = data.map((item) => item['BAL_NAME'].toString()).toList();
          List<String> balAmount = data.map((item) => item['BAL_AMOUNT'].toString()).toList();
          if (mounted) {
            setState(() {
            _bal_name = balName;
            _bal_amount = balAmount;
            _isloadingBal = false;
          });
          }
        
        } else {
          log('Loading balance not successful. Response data: ${response.body}');
          if (mounted) {
            setState(() {
              _isloadingBal = false;
            });
          }
        }
      } else {
        log('Loading balance failed: ${response.statusCode} ${response.body}');
        if (mounted) {
          setState(() {
            _isloadingBal = false;
          });
        }
      }
    } catch (e) {
      log('An error occurred while loading balance: $e');
      if (mounted) {
        setState(() {
          _isloadingBal = false;
        });
      }
    }
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
            FittedBox(
            fit: BoxFit.scaleDown, // or BoxFit.contain, BoxFit.cover, etc. depending on your needs
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: getGreeting(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: ' ${_employeeInfo[EMPL_NAME]!.split(" ")[1]}', // Assuming you want to display the second part after splitting by space
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold, // You can set different styles for different parts of the text
                    ),
                  ),
                ],
              ),
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
                if (constraints.maxWidth > 600) {
                  return buildWideLayout(context,constraints,280.0);
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
              buildRightColumn(cardwidth,false),
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
            buildRightColumn(cardwidth,true),
            const SizedBox(height: 1),
            buildFourColumnGrid(constraints,cardwidth,2),
          ],
        ),
      ),
    );
  }


Widget buildFourColumnGrid(BoxConstraints constraints, double cardWidth, int crossAxisCount) {
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
                    else if(index == 1){
                       alert(
                        "Welfare Claim Procedure:",
                        """1. Fill-up welfare claim form and attach supporting documents
2. Submit documents to HR Dept. for checking
3. Retrieve documents from HR Dept. and have it approved by supervisor.
4. Park document at SAP system for payment
5. Submit approved park document to Accounting Department.""",
                        context,
                        onConfirm: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.pushNamed(context, '/Reimbursement');
                        },
                      );
                     
                    }
                    if (index == 1) {
                      log("New Card tapped!");
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
                                  color: widget.isDarkMode ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
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
  return SizedBox(
    //constraints: BoxConstraints(maxWidth: 400), // Set the maximum width here
    width: cardwidth, // Set the width here
    child: Card(
      elevation: App.elevation,
      color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : const Color.fromARGB(255, 255, 255, 255),
      shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
      borderOnForeground: true,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        height: App.card_height,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
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
                textBeforeSpan: "",
                spanText: _employeeInfo[EMPL_NAME] ?? '',
                spanStyle: const TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                 icon: Icons.person,
                iconSize: 18.0,
                iconColor: Colors.white,
                bgColor: const Color.fromARGB(154, 78, 169, 255),
              ),
               CustomRichText(
                textBeforeSpan: '',
                spanText: _employeeInfo[POSITION] ?? '',
                spanStyle: const TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.info_outline_rounded,
                iconSize: 18.0,
                iconColor: Colors.white,
                bgColor: const Color.fromARGB(128, 78, 78, 255),
              ),
               CustomRichText(
                textBeforeSpan: '',
                spanText: _employeeInfo[DEPARTMENT] ?? '',
                spanStyle: const TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.work,
                iconSize: 18.0,
                iconColor: Colors.white,
                bgColor: const Color.fromARGB(128, 255, 119, 78),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


Widget buildRightColumn(double width, bool isMobile) {

  if(isMobile){
  double cardWidth = (width - 280) / 2; 
  return SizedBox(
    width: width,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // First Card
        SizedBox(
          width: cardWidth,
          child: Card(
            color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : const Color.fromARGB(255, 255, 255, 255),
            shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
            borderOnForeground: true,
            elevation: App.elevation,
            margin: const EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              height: App.card_height,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Personal Balance",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    _isloadingBal 
                        ? const CardLoading(
                            height: 15,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            width: 100.0,
                            margin: EdgeInsets.only(top: 8),
                          )
                        : CustomBalance(
                          balance: ' ₱${NumberFormat('#,###').format(int.parse(_bal_amount[0]))}',
                          iconx: Icons.person_rounded,
                          fontSize: 20,
                           colors: widget.isDarkMode ? Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 46, 47, 47),
                          bgcolor: const Color.fromARGB(255, 49, 196, 222),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Second Card
        SizedBox(
          width: cardWidth,
          child: Card(
            color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : const Color.fromARGB(255, 255, 255, 255),
            shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
            borderOnForeground: true,
            elevation: App.elevation,
            margin: const EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              height: App.card_height,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                     const Text(
                      "Dependents Balance",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    _isloadingBal 
                        ? const CardLoading(
                            height: 15,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            width: 100.0,
                            margin: EdgeInsets.only(top: 8),
                          )
                        : CustomBalance(
                          balance: ' ₱${NumberFormat('#,###').format(int.parse(_bal_amount[1]))}',
                          iconx: Icons.family_restroom_rounded,
                          fontSize: 20,
                          colors: widget.isDarkMode ? Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 46, 47, 47),
                          bgcolor: const Color.fromARGB(255, 222, 147, 49),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  }
  else{
    return SizedBox(
     width: width, 
    child: Card(
      color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : const Color.fromARGB(255, 255, 255, 255),
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
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
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
                  borderRadius: const BorderRadius.all(Radius.circular(13)),
                  width: width,
                  margin: const EdgeInsets.only(top: 8),
                )
               :
                 CustomRichText(
                textBeforeSpan: _bal_name[0],
                spanText:  ' ₱${NumberFormat('#,###').format(int.parse(_bal_amount[0]))}',
                spanStyle: const TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.wallet_rounded,
                iconSize: 18.0,
                iconColor: Colors.white,
                bgColor: Color.fromARGB(119, 58, 158, 204),
              ),
               _isloadingBal ? 
                 CardLoading(
                  height: 25,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  width: width,
                  margin: const EdgeInsets.only(top:12),
                )
               :
                 CustomRichText(
                textBeforeSpan: _bal_name[1],
                spanText:  ' ₱${NumberFormat('#,###').format(int.parse(_bal_amount[1]))}',
                spanStyle: const TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.wallet_rounded,
                iconSize: 18.0,
                iconColor: Colors.white,
                bgColor: Color.fromARGB(146, 181, 108, 25),
              )
             
            ],
          ),
        ),
      ),
    ),
  );
  }
  
  
}


}
