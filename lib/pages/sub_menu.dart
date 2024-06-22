
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:welfare_claim_system/components/balTile.dart';
import 'package:welfare_claim_system/components/custom_bal.dart';
import 'package:welfare_claim_system/components/custom_icon.dart';
import 'package:welfare_claim_system/components/hero_tag.dart';
import 'package:welfare_claim_system/components/hero_widget.dart';
import 'package:welfare_claim_system/components/reimbursement_tile.dart';

import '../components/config.dart';
import 'reimbursement_form.dart';

class Submenu extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final String menuType;
  final Animation<double> animation;
  final List<String> balanceName; 
  final List<String> balanaceAmount;
  final String empName;

  const Submenu({
    super.key, 
    required this.toggleTheme, 
    required this.isDarkMode,
    required this.menuType,
    required this.animation,
    required this.balanceName,
    required this.balanaceAmount,
    required this.empName
    });

  @override
  // ignore: library_private_types_in_public_api
  _SubmenuState createState() => _SubmenuState();
}

class _SubmenuState extends State<Submenu> {
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
            Navigator.of(context).pop();
            // Navigator.pushNamed(context, '/Menu');
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
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black26,
                      //     blurRadius: 10,
                      //     spreadRadius: 2,
                      //     offset: Offset(0, 5),
                      //   ),
                      // ],
                    ),
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Hero(
                          tag: widget.menuType,
                          child: Text(
                            widget.menuType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 5, right: 5),
                child: Card(
                    elevation: 3,
                    color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : Colors.blue[500],
                    shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
                    borderOnForeground: true,
                    margin: const EdgeInsets.all(20.0),
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
                                    tag: widget.empName,
                                    child: Text(
                                    widget.empName,
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
                                      BalTile(
                                        tag: widget.balanceName[0],
                                        title: widget.balanceName[0], 
                                        balance: NumberFormat('#,###').format(int.parse(widget.balanaceAmount[0])), 
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
                                       BalTile(
                                         tag: widget.balanceName[1],
                                        title: widget.balanceName[1], 
                                        balance: NumberFormat('#,###').format(int.parse(widget.balanaceAmount[1])), 
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
                                      BalTile(
                                         tag: widget.balanceName[2],
                                        title: widget.balanceName[2], 
                                        balance: NumberFormat('#,###').format(int.parse(widget.balanaceAmount[2])), 
                                        titleSize: 14, 
                                        balanceSize: 14, 
                                        titleColor:  Colors.yellow,
                                        balanceColor: Colors.white,)
                                  ],
                  
                  
                                ),
                  
                              ],
                            )
                        
                          ],
                        ),
                      ),
                    ),
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
