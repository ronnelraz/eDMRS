
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:card_loading/card_loading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/components/balTile.dart';
import 'package:welfare_claim_system/components/custom_bal.dart';
import 'package:welfare_claim_system/components/custom_rich_text.dart';
import 'package:welfare_claim_system/pages/sub_menu.dart';
import 'package:welfare_claim_system/sharedpref/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../components/config.dart';


import '../components/custom_icon.dart';
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
   bool loadBalanceData = false;

   final RefreshController _refreshController = RefreshController(initialRefresh: false);



   
  
   @override
  void initState() {
    super.initState();
    _initializeData();
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

    void _onRefresh() async{
    // monitor network fetch
      await Future.delayed(const Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
       await loadBalance();
      _refreshController.refreshCompleted();
    }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if(mounted) {
      setState(() {
       
      });
    }
    _refreshController.loadComplete();
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
          //  loadBalance();
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
            loadBalanceData = true;
          });
          }
        
        } else {
          log('Loading balance not successful. Response data: ${response.body}');
          if (mounted) {
            setState(() {
              _isloadingBal = false;
               loadBalanceData = false;
              _bal_name = ['--','--','--'];
              _bal_amount = ['0','0','0'];
               alert(
                "connection Error",
                responseData['message'],
                context,
              );
            });
          }
        }
      } else {
        log('Loading balance failed: ${response.statusCode} ${response.body}');
        if (mounted) {
          setState(() {
            _isloadingBal = false;
             loadBalanceData = false;
             _bal_name = ['--','--','--'];
             _bal_amount = ['0','0','0'];
              alert(
                "Balance failed",
                'Please check your connection, or contact IT',
                context,
              );
          });
        }
      }
    } catch (e) {
      log('An error occurred while loading balance: $e');
      if (mounted) {
        setState(() {
          _isloadingBal = false;
           loadBalanceData = false;
            _bal_name = ['--','--','--'];
            _bal_amount = ['0','0','0'];
             alert(
                "connection Error",
                'An error occurred while loading balance: $e',
                context,
              );
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return 
     _isLoadingScreen
    ? const CustomLoading(img: 'assets/logo.png', text: 'Please wait...',)    
    : Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black87 : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
            fit: BoxFit.scaleDown,
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
                    text: ' ${_employeeInfo[EMPL_NAME]!.split(" ")[1]}', 
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold, 
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
            padding: const EdgeInsets.all(8.0), 
            child: IconButton(
              icon: Icon(widget.isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
              onPressed: widget.toggleTheme,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0), 
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                      logout(context);
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
      
      body: SmartRefresher(
         enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return buildWideLayout(context,constraints,800.0);
                  } else {
                    return buildNarrowLayout(context,constraints,700.0);
                  }
                },
        ),
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
              // buildRightColumn(cardwidth,false),
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
            // buildRightColumn(cardwidth,true),
            // const SizedBox(height: 1),
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
                          //  Navigator.pushNamed(context, '/Submenu');
                          //  Navigator.push( 
                          //   context, 
                          //   MaterialPageRoute( 
                          //     builder: (context) => 
                          //         Submenu(
                          //           toggleTheme: widget.toggleTheme,
                          //           isDarkMode: widget.isDarkMode,
                          //           menuType: Menutitle[index],
                          //         ), 
                          //   ), 
                          // ); 

                          if(loadBalanceData){
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                reverseTransitionDuration: const Duration(seconds: 1),
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  final curvedAnimation = CurvedAnimation(
                                    parent: animation,
                                    curve: const Interval(0.1, 0.1, curve: Curves.linear),
                                  );

                                  return FadeTransition(
                                    opacity: curvedAnimation,
                                    child: 
                                    Submenu(
                                      toggleTheme: widget.toggleTheme,
                                      isDarkMode: widget.isDarkMode,
                                      menuType: Menutitle[index],
                                      animation: animation,
                                      empName:  _employeeInfo[EMPL_NAME] ?? '',
                                      balanceName: _bal_name,
                                      balanaceAmount: _bal_amount,
                                    ), 
                                  );
                                },
                              ),
                            );
                             //  Navigator.pushNamed(context, '/Admission');
                          }

                            

                         
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
                              Hero(
                                tag: Menutitle[index],
                                child: Text(
                                  Menutitle[index].toUpperCase(),
                                  style: TextStyle(
                                    color: widget.isDarkMode ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Urbanist',
                                  ),
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
    height: 170,
    //constraints: BoxConstraints(maxWidth: 400), // Set the maximum width here
    width: cardwidth, // Set the width here
    child: Stack(
      children: [
         
        Card(
        elevation: 0,
        color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : Colors.blue[500],
        shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
        borderOnForeground: true,
        margin: const EdgeInsets.only(top:10.0,left: 15.0, right:25.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SizedBox(
          height: App.card_height,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Hero(
                      tag: 'balance',
                      child: Text(
                        "Your Current Balance",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                    ),
                      Hero(
                        tag:  _employeeInfo[EMPL_NAME] ?? '',
                        child: Text(
                        _employeeInfo[EMPL_NAME] ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                                            ),
                      ),
                   
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Hero(
                           tag: '1',
                           child: CustomIcon(
                            width: 50.0,
                            height: 50.0,
                            icon: FontAwesomeIcons.person,
                            iconSize: 20.0,
                            iconColor: Colors.white,
                            bgColor: Colors.white.withOpacity(0.2),
                                                   ),
                         ),
                          const SizedBox(height: 2,),
                         _isloadingBal 
                          ? const SpinKitFadingCircle(
                            color: Colors.white,
                            size: 25)
                          : BalTile(
                            tag: _bal_name[0],
                            title: _bal_name[0], 
                            balance: NumberFormat('#,###').format(int.parse(_bal_amount[0])), 
                            titleSize: 14, 
                            balanceSize: 15, 
                            titleColor:  Colors.yellow,
                            balanceColor: Colors.white,)
                      ],
                    ),
                     Container(
                      width: 1,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                     ),
                     Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Hero(
                           tag: '2',
                           child: CustomIcon(
                            width: 50.0,
                            height: 50.0,
                            icon: Icons.family_restroom_rounded,
                            iconSize: 20.0,
                            iconColor: Colors.white,
                            bgColor: Colors.white.withOpacity(0.2),
                                                   ),
                         ),
                          _isloadingBal 
                          ? const SpinKitFadingCircle(
                            color: Colors.white,
                            size: 25)
                          : BalTile(
                            tag: _bal_name[1],
                            title: _bal_name[1], 
                            balance: NumberFormat('#,###').format(int.parse(_bal_amount[1])), 
                            titleSize: 14, 
                            balanceSize: 14, 
                            titleColor:  Colors.yellow,
                            balanceColor: Colors.white,)
                      ],
                    ),
                     Container(
                      width: 1,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                     ),
                     Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Hero(
                           tag: '3',
                           child: CustomIcon(
                            width: 50.0,
                            height: 50.0,
                            icon: FontAwesomeIcons.carBurst,
                            iconSize: 20.0,
                            iconColor: Colors.white,
                            bgColor: Colors.white.withOpacity(0.2),
                                                   ),
                         ),
                          _isloadingBal 
                          ? const SpinKitFadingCircle(
                            color: Colors.white,
                            size: 25)
                          : BalTile(
                            tag: _bal_name[2],
                            title: _bal_name[2], 
                            balance: NumberFormat('#,###').format(int.parse(_bal_amount[2])), 
                            titleSize: 14, 
                            balanceSize: 14, 
                            titleColor:  Colors.yellow,
                            balanceColor: Colors.white,)
                      ],
      
      
                    ),
      
                  ],
                )
                // CustomRichText(
                //   textBeforeSpan: "",
                //   spanText: _employeeInfo[EMPL_NAME] ?? '',
                //   spanStyle: const TextStyle(
                //     fontSize: App.card_textsize,
                //     fontWeight: FontWeight.bold,
                //   ),
                //    icon: Icons.person,
                //   iconSize: 18.0,
                //   iconColor: Colors.white,
                //   bgColor: const Color.fromARGB(154, 78, 169, 255),
                // ),
                //  CustomRichText(
                //   textBeforeSpan: '',
                //   spanText: _employeeInfo[POSITION] ?? '',
                //   spanStyle: const TextStyle(
                //     fontSize: App.card_textsize,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   icon: Icons.info_outline_rounded,
                //   iconSize: 18.0,
                //   iconColor: Colors.white,
                //   bgColor: const Color.fromARGB(128, 78, 78, 255),
                // ),
                //  CustomRichText(
                //   textBeforeSpan: '',
                //   spanText: _employeeInfo[DEPARTMENT] ?? '',
                //   spanStyle: const TextStyle(
                //     fontSize: App.card_textsize,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   icon: Icons.work,
                //   iconSize: 18.0,
                //   iconColor: Colors.white,
                //   bgColor: const Color.fromARGB(128, 255, 119, 78),
                // ),
              ],
            ),
          ),
        ),
      ),
    
        // Container(
        //   width: 50,
        //   height: 50,
        //   margin: const EdgeInsets.all(1.0),
        //   decoration: BoxDecoration(
        //     color: Colors.black.withOpacity(0.5), // Adjust the opacity here
        //     borderRadius: BorderRadius.circular(10.0),
        //   ),
        // ),
      ],
    ),
  );
}


Widget buildRightColumn(double width, bool isMobile) {

  if(isMobile){
  double cardWidth = (width - 350) / 2; 
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
                        fontSize: 13.0,
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
                          bgcolor: Colors.blue,
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
                        fontSize: 12.0,
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
