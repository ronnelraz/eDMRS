import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/components/custom_bal.dart';
import 'package:welfare_claim_system/components/reimbursement_tile.dart';
import 'package:welfare_claim_system/sharedpref/sharedpref.dart';
import '../components/config.dart';
import 'reimbursement_form.dart';

class Reimbursement extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const Reimbursement({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _ReimbursementState createState() => _ReimbursementState();
}

class _ReimbursementState extends State<Reimbursement> {
  Map<String, String> _employeeInfo = {};
  List<String> _balAmount = [];
  bool _isLoadingBal = true;
  late Timer _timer;

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
              _balAmount = balAmount;
              _isLoadingBal = false;
            });
          }
        } else {
          log('Loading balance not successful. Response data: ${response.body}');
          if (mounted) {
            setState(() {
              _isLoadingBal = false;
            });
          }
        }
      } else {
        log('Loading balance failed: ${response.statusCode} ${response.body}');
        if (mounted) {
          setState(() {
            _isLoadingBal = false;
          });
        }
      }
    } catch (e) {
      log('An error occurred while loading balance: $e');
      if (mounted) {
        setState(() {
          _isLoadingBal = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 113, 187),
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: "Back to menu",
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/Menu');
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
            color: widget.isDarkMode ? const Color.fromARGB(255, 37, 37, 37) : Colors.yellow[600],
            onPressed: widget.toggleTheme,
          ),
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
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
              Stack(
                children: [
                  Container(
                  height: 120.0,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 64, 113, 187),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                   child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 10.0),
                        child: Text(
                          "Reimbursement",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildBalanceCard(
                      title: "Personal Balance",
                      isLoading: _isLoadingBal,
                      balance: _balAmount.isNotEmpty ? _balAmount[0] : '0',
                      icon: Icons.person_rounded,
                      bgColor: const Color.fromARGB(255, 49, 196, 222),
                    ),
                    const SizedBox(width: 50),
                    _buildBalanceCard(
                      title: "Dependent Balance",
                      isLoading: _isLoadingBal,
                      balance: _balAmount.length > 1 ? _balAmount[1] : '0',
                      icon: Icons.family_restroom_rounded,
                      bgColor: const Color.fromARGB(255, 222, 147, 49),
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
                Navigator.push( 
                  context, 
                  MaterialPageRoute( 
                    builder: (context) => 
                        ReimbursementForm(
                          toggleTheme: widget.toggleTheme,
                          isDarkMode: widget.isDarkMode,
                          reimbursementype: 'Employee',
                        ), 
                  ), 
                ); 
              },
             ),
             ReimburstmentTile(
              img: 'assets/menu/dependent.png',
              text: "DEPENDENT",
              width: 100,
              height: 100,
              onPressed: () {
                Navigator.push( 
                  context, 
                  MaterialPageRoute( 
                    builder: (context) => 
                        ReimbursementForm(
                          toggleTheme: widget.toggleTheme,
                          isDarkMode: widget.isDarkMode,
                          reimbursementype: 'Dependent',
                        ), 
                  ), 
                ); 
              },
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard({
    required String title,
    required bool isLoading,
    required String balance,
    required IconData icon,
    required Color bgColor,
  }) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color.fromARGB(255, 97, 97, 97) : const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: Colors.black.withOpacity(0.4),
        ),
        boxShadow: const [
        BoxShadow(
              color: Colors.black26,
              blurRadius: 0.1,
              spreadRadius: 0.2,
              offset: Offset(0, 1),
            ),
          ],
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w900,
              color: widget.isDarkMode ? const Color.fromARGB(255, 247, 151, 6) : Colors.blueAccent,
            ),
          ),
          isLoading
              ? const CardLoading(
                  height: 15,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  width: 100.0,
                  margin: EdgeInsets.only(top: 8),
                )
              : CustomBalance(
                  balance: '₱${NumberFormat('#,###').format(int.parse(balance))}',
                  iconx: icon,
                  fontSize: 13,
                  colors: widget.isDarkMode ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 46, 47, 47),
                  bgcolor: bgColor,
                ),
        ],
      ),
    );
  }
}
