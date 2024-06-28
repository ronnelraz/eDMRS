import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/components/balTile.dart';
import 'package:welfare_claim_system/components/custom_icon.dart';
import 'package:welfare_claim_system/components/loading.dart';
import 'package:welfare_claim_system/components/reimbursement_tile.dart';
import 'package:welfare_claim_system/pages/admission.dart';
import '../components/config.dart';
import '../model/submenu.dart';
import 'reimbursement_form.dart';

class Submenu extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final String menuType;
  final Animation<double> animation;
  final List<String> balanceName;
  final List<String> balanceAmount;
  final String empName;
  final String welfareCode;

  const Submenu({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.menuType,
    required this.animation,
    required this.balanceName,
    required this.balanceAmount,
    required this.empName,
    required this.welfareCode,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SubmenuState createState() => _SubmenuState();
}

class _SubmenuState extends State<Submenu> {
  bool isLoadData = false;
  List<SubMenuItem> subMenuItems = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    subMenuItems = [];
    _initializeData();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await loadSubMenu();
  }

  Future<void> loadSubMenu() async {
    try {
      Map<String, String> body = {
        'welfare_main_code': widget.welfareCode,
      };

      var response = await subMenu('getSubmenu', body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        bool success = responseData['success'];

        if (success) {
          List<dynamic> data = responseData['data'];
          List<SubMenuItem> loadedSubMenuItems =
              data.map((item) => SubMenuItem.fromJson(item)).toList();

          if (mounted) {
            setState(() {
              subMenuItems = loadedSubMenuItems;
              isLoadData = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isLoadData = false;
              alert(
                "Connection Error",
                responseData['message'],
                context,
              );
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isLoadData = false;
            alert(
              "Sub Menu failed",
              'Please check your connection, or contact IT',
              context,
            );
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadData = false;
          alert(
            "Connection Error",
            'An error occurred while loading Sub Menu: $e',
            context,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 113, 187),
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: "Back to menu",
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
            color: widget.isDarkMode
                ? const Color.fromARGB(255, 37, 37, 37)
                : Colors.yellow[600],
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
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30.0, right: 30.0),
                        child:Text(
                            widget.menuType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                              height: 1.2,
                            ),
                          )
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, left: 5, right: 5),
                  child: Card(
                    elevation: 3,
                    color: widget.isDarkMode
                        ? const Color.fromARGB(255, 81, 81, 81)
                        : Colors.blue[500],
                    shadowColor: widget.isDarkMode
                        ? const Color.fromARGB(255, 109, 109, 109)
                        : const Color.fromARGB(255, 67, 67, 67),
                    borderOnForeground: true,
                    margin: const EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SizedBox(
                      height: 140,
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
                                  tag: 'balance-menu', // Unique tag
                                  child: Text(
                                    "Your Current Balance",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ),
                                Hero(
                                  tag: 'empName-${widget.empName}', // Unique tag
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
                                      tag: 'icon-1', // Unique tag
                                      child: CustomIcon(
                                        width: 50.0,
                                        height: 50.0,
                                        icon: FontAwesomeIcons.person,
                                        iconSize: 20.0,
                                        iconColor: Colors.white,
                                        bgColor:
                                            Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    BalTile(
                                      tag: 'balanceName-0', // Unique tag
                                      title: widget.balanceName[0],
                                      balance: NumberFormat('#,###').format(
                                          int.parse(widget.balanceAmount[0])),
                                      titleSize: 14,
                                      balanceSize: 15,
                                      titleColor: Colors.yellow,
                                      balanceColor: Colors.white,
                                    )
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
                                      tag: 'icon-2', // Unique tag
                                      child: CustomIcon(
                                        width: 50.0,
                                        height: 50.0,
                                        icon: Icons.family_restroom_rounded,
                                        iconSize: 20.0,
                                        iconColor: Colors.white,
                                        bgColor:
                                            Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    BalTile(
                                      tag: 'balanceName-1', // Unique tag
                                      title: widget.balanceName[1],
                                      balance: NumberFormat('#,###').format(
                                          int.parse(widget.balanceAmount[1])),
                                      titleSize: 14,
                                      balanceSize: 14,
                                      titleColor: Colors.yellow,
                                      balanceColor: Colors.white,
                                    )
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
                                      tag: 'icon-3', // Unique tag
                                      child: CustomIcon(
                                        width: 50.0,
                                        height: 50.0,
                                        icon: FontAwesomeIcons.carBurst,
                                        iconSize: 20.0,
                                        iconColor: Colors.white,
                                        bgColor:
                                            Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    BalTile(
                                      tag: 'balanceName-2', // Unique tag
                                      title: widget.balanceName[2],
                                      balance: NumberFormat('#,###').format(
                                          int.parse(widget.balanceAmount[2])),
                                      titleSize: 14,
                                      balanceSize: 14,
                                      titleColor: Colors.yellow,
                                      balanceColor: Colors.white,
                                    )
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
            isLoadData
                ? const CustomLoading(
                    img: 'assets/logo.png',
                    text: 'Please wait...',
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subMenuItems.length,
                    itemBuilder: (context, index) {
                      final item = subMenuItems[index];
                      return ReimburstmentTile(
                        img: item.urlImg, // Update with relevant image path
                        text: item.sname,
                        subTitle: item.fname,
                        width: 60,
                        height: 60,
                        onPressed: () {

                            if(widget.welfareCode == "WG01"){
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
                                          Admission(
                                            toggleTheme: widget.toggleTheme,
                                            isDarkMode: widget.isDarkMode,
                                            title: item.sname,
                                            subTitle: item.fname,
                                          ), 
                                        );
                                      },
                                    ),
                                  );
                            }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ReimbursementForm(
                          //       toggleTheme: widget.toggleTheme,
                          //       isDarkMode: widget.isDarkMode,
                          //       reimbursementype: item.fname, // Passing the relevant data
                          //     ),
                          //   ),
                          // );
                        },
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
