import 'dart:io';

import 'package:card_loading/card_loading.dart';
import 'package:edmrs/API/api_service.dart';
import 'package:edmrs/sharedpref/sharedpref.dart';
import 'package:flutter/material.dart';
import '../components/config.dart';
import 'package:intl/intl.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
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


class Admission extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  Admission({required this.toggleTheme, required this.isDarkMode});

  @override
  _AdmissionState createState() => _AdmissionState();
}


class _AdmissionState extends State<Admission> {
  final _formKey = GlobalKey<FormState>();


  // Other form field variables
  final TextEditingController request_date = TextEditingController(text: DateFormat('MM/dd/yyyy').format(DateTime.now()));
  final TextEditingController emp_name = TextEditingController();
  final FocusNode empNameFocus = FocusNode();
  final TextEditingController department = TextEditingController();
  final FocusNode departmentFocus = FocusNode();
  final TextEditingController position = TextEditingController();
  final FocusNode positionFocus = FocusNode();

  final TextEditingController bu = TextEditingController();
  final FocusNode buFocus = FocusNode();

  DateTime _admissionDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');
  final TextEditingController admitdate = TextEditingController();
  final FocusNode admitdateFocus = FocusNode();

  final TextEditingController syntom = TextEditingController();
  final FocusNode syntomFocus = FocusNode();
  late String getHospital = "";

  String _selectedFiles = "";

   Map<String, String> _employeeInfo = {};
   bool _isLoading = true;
   bool _isLoadingScreen = true;

   List<String> HOSPITAL_LNAME = [];
   List<String> hospital_code = [];
   List<String> HOSPITAL_SNAME = [];
   bool _isLoadings = true;
   


   @override
  void initState() {
    super.initState();
     _loadEmployeeInfo();
      dataLoadFunction();
       _loadHospital();
  
  }

   Future<void> _loadHospital() async {
    try {
      var response = await Hospital('getHospital');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        bool success = responseData['success'];

        if (success) {
          List<dynamic> data = responseData['data'];
          List<String> _hospital_code = data.map((item) => item['hospital_code'].toString()).toList();
          List<String> _HOSPITAL_LNAME = data.map((item) => item['HOSPITAL_LNAME'].toString()).toList();
          List<String> _HOSPITAL_SNAME = data.map((item) => item['HOSPITAL_SNAME'].toString()).toList();
          setState(() {
            hospital_code = _hospital_code;
            HOSPITAL_LNAME = _HOSPITAL_LNAME;
            HOSPITAL_SNAME = _HOSPITAL_SNAME;

            _isLoadings = false;
          });
        } else {
          print('Login not successful. Response data: ${response.body}');
          setState(() {
            _isLoadings = false;
          });
        }
      } else {
        print('Login failed: ${response.statusCode} ${response.body}');
        setState(() {
          _isLoadings = false;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        _isLoadings = false;
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
      _isLoadingScreen = false; 

      emp_name.text = _employeeInfo[EMPL_NAME] ?? '';
      department.text = _employeeInfo[DEPARTMENT] ?? '';
      position.text = _employeeInfo[POSITION] ?? '';
      bu.text =  _employeeInfo[BUSINESS_UNIT] ?? '';


    });
  }

   Future<void> _loadEmployeeInfo() async {
    Map<String, String> info = await getEmployeeInfo();
    setState(() {
      _employeeInfo = info;
      _isLoading = false;
    });
  }



    @override
  void dispose() {
    empNameFocus.dispose();
    departmentFocus.dispose();
    positionFocus.dispose();
    buFocus.dispose();
    admitdateFocus.dispose();
    syntomFocus.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  _isLoadingScreen
    ? const CustomLoading(img: 'assets/logo.png', text: 'Loading',)    
    : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable automatic back button
        leading: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                
                // Navigator.of(context).pop(); // Navigate back to the previous screen
                // Navigator.pushNamed(context, '/Menu');
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
              'Admission',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
            Text(
              'ACCREDITED HOSPITAL REQUEST',
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
      body: Padding(
        padding: const EdgeInsets.only(right:16.0, left: 16.0 ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
               SizedBox(height: 5),
              CustomTextField(
                labelText: 'Request Date',
                customerRadius: 10.0,
                controller: request_date,
                readonly: true,
                hintText: "Request Date",
                cursorColor: const Color.fromRGBO(43, 42, 42, 1),
              ),
              // Other form fields
              SizedBox(height: 20),
              CustomTextField(
                readonly: true,
                labelText: 'Employee Name',
                customerRadius: 10.0,
                controller: emp_name,
                focusNode: empNameFocus,
                cursorColor: const Color.fromRGBO(43, 42, 42, 1),
              ),
              // Employee Name Field
              SizedBox(height: 20),
              // Department Field
             CustomTextField(
              readonly: true,
                labelText: 'Department',
                customerRadius: 10.0,
                controller: department,
                focusNode: departmentFocus,
                cursorColor: const Color.fromRGBO(43, 42, 42, 1),
              ),
              SizedBox(height: 20),
              // Name of Hospital Field (Using CustomDropdown)
              _isLoading ?
                CardLoading(
                  height: 25,
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 8),
                )
              : CustomDropdown<String>.search(
                  hintText: 'Name of Hospital',
                  items: HOSPITAL_LNAME,
                  excludeSelected: false,
                  decoration: CustomDropdownDecoration(
                    expandedFillColor: widget.isDarkMode ? const Color.fromARGB(255, 189, 189, 189) : const Color.fromARGB(255, 255, 255, 255),
                    closedFillColor: widget.isDarkMode ? const Color.fromARGB(255, 189, 189, 189) : Colors.white,
                    
                    closedBorder: Border.all( // Using BoxBorder with Border.all for a simple solid border
                      color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 189, 189, 189),
                      width: 1.0,
                    ),
                    expandedBorder:  Border.all( // Using BoxBorder with Border.all for a simple solid border
                      color: widget.isDarkMode ? Colors.white : Color.fromARGB(255, 189, 189, 189),
                      width: 1.0,
                    ),
                    
                  ),
                  onChanged: (value) {
                     setState(() {
                       getHospital = value;
                     });
                  },
                ),
              SizedBox(height: 20),
              // Position Field
               CustomTextField(
                readonly: true,
                labelText: 'Position',
                customerRadius: 10.0,
                controller: position,
                focusNode: positionFocus,
                cursorColor: const Color.fromRGBO(43, 42, 42, 1),
              ),
              SizedBox(height: 20),
              // Business Unit Field
              CustomTextField(
                readonly: true,
                labelText: 'Business Unit',
                customerRadius: 10.0,
                controller: bu,
                focusNode: buFocus,
                cursorColor: const Color.fromRGBO(43, 42, 42, 1),
              ),
              SizedBox(height: 20),
              // Admission Date Field
                CustomTextField(
                labelText: 'Admission Date',
                customerRadius: 10.0,
                controller: admitdate,
                focusNode: admitdateFocus,
                cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                onTapx: () {
                  showDatePicker(
                    context: context,
                    initialDate: _admissionDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        _admissionDate = selectedDate;
                        admitdate.text = _dateFormat.format(selectedDate);
                      });
                    }
                  });
                },
              ),

              SizedBox(height: 20),
              Container(
                  height: 6 * 24.0,
                  child: CustomTextArea(
                    keyboard: TextInputType.multiline,
                    maxL: 200,
                    labelText: 'Symptoms',
                    customerRadius: 10.0,
                    controller: syntom,
                    focusNode: syntomFocus,
                    cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                  ),
                ),

              SizedBox(height: 20),
              if (_selectedFiles.isEmpty)
                CustomButtonWithIcon(
                  icon: 'assets/clip.svg',
                  label: 'Attach File ',
                  onPressed:_pickFiles,
                  color: Color.fromARGB(255, 46, 83, 218),
                  iconColor: Colors.white,
                ),
              SizedBox(height: 20),
              if (_selectedFiles.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedIconButton(
                      color: const Color.fromARGB(255, 243, 33, 33),
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 15,
                      ),
                      onPressed: () {
                         setState(() {
                            _selectedFiles = "";
                         });
                      },
                    ),
                    Text(' Selected Files: ${_selectedFiles}'),
                  ],
                ),
              ),

              SizedBox(height: 20),
              // Save, Submit, and Cancel Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25, // Adjust the width as needed
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtonWithIcon(
                        icon: 'assets/icon_toast/logout.svg',
                        label: 'Save',
                        onPressed: () async {
                          saveData("save");
                        },
                        color: Colors.green,
                        iconColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25, // Adjust the width as needed
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtonWithIcon(
                        icon: 'assets/icon_toast/check-circle.svg',
                        label: 'Submit',
                        onPressed: () async {
                          saveData("save");
                        },
                        color: Colors.blue,
                        iconColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25, // Adjust the width as needed
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButtonWithIcon(
                        icon: 'assets/icon_toast/circle-xmark.svg',
                        label: 'Cancel',
                        onPressed: () async {
                          Navigator.of(context).pop(); // Navigate back to the previous screen
                          locStorage("page", "menu");
                        },
                        color: Colors.red,
                        iconColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
        withData: !kIsWeb
      );

      if(kIsWeb){
        print("s");
      }
      else{
          if (result != null && result.files.single.path != null) {
            PlatformFile file = result.files.first;
            String base64Data = base64Encode(file.bytes!);
            log(base64Data);
            setState(() {
                _selectedFiles = file.name;
            });
          } else {
            // User canceled the picker
            print("error talga");
          }
      }
    } catch (e) {
      print('Error picking files: $e');
      // Handle any errors that occur during file picking
    }
}
  

  void saveData(String type){
    String requestDate = request_date.text;
    String empname = emp_name.text;
    String dept = department.text;
    String hostpital = getHospital.toString();
    String pos = position.text;
    String businessUnit = bu.text;
    String admit_date = admitdate.text;
    String synt = syntom.text;
    
    if(empname.isEmpty){
      //  FocusScope.of(con).requestFocus(empNameFocus);
      FocusScope.of(context).requestFocus(empNameFocus);
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please Enter your full name')),
      );

    }
    else if(dept.isEmpty){
      FocusScope.of(context).requestFocus(departmentFocus);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please Enter your Department')),
      );
    }
    else if(hostpital.isEmpty){
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a hospital')),
      );
    }
    else if(pos.isEmpty){
       FocusScope.of(context).requestFocus(positionFocus);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter your position')),
      );
    }
    else if(businessUnit.isEmpty){
       FocusScope.of(context).requestFocus(buFocus);
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter your business unit')),
      );
    }
    else if(admit_date.isEmpty){
       FocusScope.of(context).requestFocus(admitdateFocus);
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select admission date')),
      );
    }
    else if(synt.isEmpty){
       FocusScope.of(context).requestFocus(syntomFocus);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('please state your symptoms')),
        );
    }
    else{

    }


    
  }
}