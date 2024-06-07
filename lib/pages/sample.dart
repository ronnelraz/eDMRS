import 'dart:io';

import 'package:card_loading/card_loading.dart';
import 'package:edmrs/API/api_service.dart';
import 'package:edmrs/sharedpref/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import '../components/config.dart';
import 'package:intl/intl.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../components/custom_previewdata.dart';
import '../components/custom_text_area.dart';
import '../components/custom_text_field.dart';
import '../components/custom_button.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:sized_icon_button/sized_icon_button.dart';
import 'dart:developer';

import '../components/loading.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class Sample extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  Sample({required this.toggleTheme, required this.isDarkMode});

  @override
  _SampleState createState() => _SampleState();
}


class _SampleState extends State<Sample> {
  Color _red = Colors.grey;
  Color _yellow = Colors.grey;
  Color _green = Colors.grey;

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
          children: [
            Text(
              'sample',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
            Text(
              'sample',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
          ],
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
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
               Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _red,
                ),
              ),
              SizedBox(height: 20),

                  Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _yellow,
                ),
              ),
              SizedBox(height: 20),

                  Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _green,
                ),
              ),
              SizedBox(height: 20),

              Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                 ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.red), 
                    ),
                    onPressed:() {
                       setState(() {
                        _red = Colors.red;
                        _yellow = Colors.grey;
                        _green = Colors.grey;
                      });
                    },
                    child: Text('Red'),
                  ),
                   SizedBox(width: 10),
                  ElevatedButton(
                     style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.yellow), 
                    ),
                    onPressed:() {
                      setState(() {
                        _red = Colors.grey;
                        _yellow = Colors.yellow;
                        _green = Colors.grey;
                      });
                    },
                    child: Text('Yellow'),
                  ),
                   SizedBox(width: 10),
                  ElevatedButton(
                     style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.green), 
                    ),
                    onPressed:() {
                       setState(() {
                        _red = Colors.grey;
                        _yellow = Colors.grey;
                        _green = Colors.green;
                      });
                    },
                    child: Text('Green'),
                  ),
                ],
              )
           


            ],
          ),
        ),

      )
    );
  }


 

}