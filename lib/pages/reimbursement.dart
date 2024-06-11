import 'dart:async';
import 'dart:developer';

import 'package:edmrs/components/reimbursement_tile.dart';
import 'package:flutter/material.dart';
import '../components/config.dart';


class Reimbursement extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  Reimbursement({required this.toggleTheme, required this.isDarkMode});

  @override
  _ReimbursementState createState() => _ReimbursementState();
}


class _ReimbursementState extends State<Reimbursement> {
  // Map<String, String> _employeeInfo = {};
  //   List<String> balName = [];
  //  // ignore: non_constant_identifier_names
  //  List<String> balAmount = [];
  //  bool isLoadingBalance = true;
  //  late Timer _timer = Timer(const Duration(seconds: 0), () {});

  //     @override
  // void initState() {
  //   super.initState();
  //   _initializeData();;
  // }

  //  @override
  // void dispose() {
  //   _timer.cancel();  
  //   super.dispose();
  // }

  //   void _startBalanceLoading() {
  //   Future.delayed(const Duration(seconds: 5), () {
  //     loadBalance();
  //     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //       if (mounted) {
  //          loadBalance();
  //       } else {
  //         timer.cancel();
  //       }
  //     });
  //   });
  // }

  // Future<void> _initializeData() async {
  //   _startBalanceLoading();
  // }

  // Future<void> loadBalance() async {
  //   try {
  //     Map<String, String> body = {
  //       'year': '2024',
  //       'empid': _employeeInfo['EMPID'] ?? '',
  //     };

  //     var response = await balance('getBalance', body);
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseData = json.decode(response.body);
  //       bool success = responseData['success'];

  //       if (success) {
  //         List<dynamic> data = responseData['data'];
  //         List<String> balName = data.map((item) => item['BAL_NAME'].toString()).toList();
  //         List<String> balAmount = data.map((item) => item['BAL_AMOUNT'].toString()).toList();
  //         if (mounted) {
  //           setState(() {
  //           _bal_name = balName;
  //           _bal_amount = balAmount;
  //           _isloadingBal = false;
  //         });
  //         }
        
  //       } else {
  //         log('Loading balance not successful. Response data: ${response.body}');
  //         if (mounted) {
  //           setState(() {
  //             _isloadingBal = false;
  //           });
  //         }
  //       }
  //     } else {
  //       log('Loading balance failed: ${response.statusCode} ${response.body}');
  //       if (mounted) {
  //         setState(() {
  //           _isloadingBal = false;
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     log('An error occurred while loading balance: $e');
  //     if (mounted) {
  //       setState(() {
  //         _isloadingBal = false;
  //       });
  //     }
  //   }
  // }

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
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [

            // Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       mainAxisSize: MainAxisSize.max,
            //       children: [
            //         const Text(
            //           "Personal Balance",
            //           style: TextStyle(
            //             fontSize: 15.0,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.blueAccent,
            //           ),
            //         ),
            //         _isloadingBal 
            //             ? const CardLoading(
            //                 height: 15,
            //                 borderRadius: BorderRadius.all(Radius.circular(5)),
            //                 width: 100.0,
            //                 margin: EdgeInsets.only(top: 8),
            //               )
            //             : CustomBalance(
            //               balance: ' ₱${NumberFormat('#,###').format(int.parse(_bal_amount[0]))}',
            //               iconx: Icons.person_rounded,
            //               fontSize: 20,
            //                colors: widget.isDarkMode ? Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 46, 47, 47),
            //               bgcolor: const Color.fromARGB(255, 49, 196, 222),
            //             ),
            //       ],
            //     ),
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