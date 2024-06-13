import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:card_loading/card_loading.dart';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/components/custom_bal.dart';
import 'package:welfare_claim_system/components/reimbursement_tile.dart';
import 'package:welfare_claim_system/sharedpref/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/config.dart';


class Reimbursement extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const Reimbursement({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  // ignore: library_private_types_in_public_api
  _ReimbursementState createState() => _ReimbursementState();
}


class _ReimbursementState extends State<Reimbursement> {
    Map<String, String> _employeeInfo = {};
   // ignore: non_constant_identifier_names
   List<String> _bal_amount = [];
   bool _isloadingBal = true;
   late Timer _timer = Timer(const Duration(seconds: 0), () {});
   
  
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
    _startBalanceLoading();
  }

  Future<void> _loadEmployeeInfo() async {
    try {
      Map<String, String> info = await getEmployeeInfo();
      setState(() {
        _employeeInfo = info;
      });
    } catch (e) {
      log('Error loading employee info: $e');
    }
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
          List<String> balAmount = data.map((item) => item['BAL_AMOUNT'].toString()).toList();
          if (mounted) {
            setState(() {
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


    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable automatic back button
        leading: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/Menu');
              },
            ),
            // Add your additional icon here
          ],
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
        ),
        // leading: buildImage('assets/menu/admission.png', 40, 40, Alignment.centerRight),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0,right: 10.0),
                  child: Text(
                    "Reimbursement",
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      height: 1.2
                    ),
                    ),
                ),
              
                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 1),
                  child: Text(
                    App.welfareNote,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                    ),
                ),
              ],
            ),

            Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), 
              color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              margin: const EdgeInsets.all(10),
              height: 1, 
              width: double.infinity, 
            ),
            
            Row(
               crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
              children: [
              Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                  color: widget.isDarkMode ? const Color.fromARGB(255, 97, 97, 97) : const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: Colors.black.withOpacity(0.12)
                  ),

                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                       Text(
                        "Personal Balance",
                        style: TextStyle(
                          fontSize: 12.0,
                           fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w900,
                          color: widget.isDarkMode ?  Color.fromARGB(255, 247, 151, 6) : Colors.blueAccent ,
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
                            fontSize: 13,
                             colors: widget.isDarkMode ? Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 46, 47, 47),
                            bgcolor: const Color.fromARGB(255, 49, 196, 222),
                          ),
                    ],
                  ),
              ),
              const SizedBox(width: 50),
                Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                    color: widget.isDarkMode ? const Color.fromARGB(255, 97, 97, 97) : const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1,
                      color: Colors.black.withOpacity(0.12)
                    ),

                  ),
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                        Text(
                        "Dependent Balance",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Urbanist',
                           fontWeight: FontWeight.w900,
                          color: widget.isDarkMode ? Color.fromARGB(255, 247, 151, 6) : Colors.blueAccent ,
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
                            fontSize: 13,
                            colors: widget.isDarkMode ? Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 46, 47, 47),
                            bgcolor: const Color.fromARGB(255, 222, 147, 49),
                          ),
                    ],
                  ),
                ),
              ],

            ),         
           ReimburstmentTile(
            img: 'assets/menu/employee.png',
            text: "Employee",
            width: 100,
            height: 100,
            onPressed: () {
              log("okok");
            },
           ),
           ReimburstmentTile(
            img: 'assets/menu/dependent.png',
            text: "DEPENDENT",
            width: 100,
            height: 100,
            onPressed: () {
              log("okok");
            },
           ),
      
          ],
        ),
      )
    );
  }
  
  

 

}