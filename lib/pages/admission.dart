
import 'package:card_loading/card_loading.dart';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/components/custom_rich_text.dart';
import 'package:welfare_claim_system/sharedpref/sharedpref.dart';
import 'package:flutter/material.dart';
import '../components/config.dart';
import 'package:intl/intl.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../components/custom_previewdata.dart';
import '../components/custom_text_area.dart';
import '../components/custom_text_field.dart';
import '../components/custom_button.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
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
   String uploadFile_name = "";
   String uploadFile = "";
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
   
    await Future.delayed(const Duration(seconds: 3));

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

  ScrollController _scrollController = new ScrollController();
    bool _keyboardVisible = false;


  @override
  Widget build(BuildContext context) {
    return  _isLoadingScreen
    ? const CustomLoading(img: 'assets/logo.png', text: 'Loading',)    
    : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              'Admission',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
            Text(
              'Request Form',
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
            controller: _scrollController,
            reverse: false,
            shrinkWrap: true,
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
                    onTapx: () {
                        setState(() {
                              _keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
                              if (_keyboardVisible) {
                                // Scroll to the bottom when the keyboard is shown
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              }
                            });
                    },
                  ),
                ),

              // SizedBox(height: 20),
              // if (_selectedFiles.isEmpty)
              //   CustomButtonWithIcon(
              //     icon: 'assets/clip.svg',
              //     label: 'Attach File ',
              //     onPressed:_pickFiles,
              //     color: Color.fromARGB(255, 46, 83, 218),
              //     iconColor: Colors.white,
              //   ),
              // SizedBox(height: 20),
              // if (_selectedFiles.isNotEmpty)
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       SizedIconButton(
              //         color: const Color.fromARGB(255, 243, 33, 33),
              //         icon: Icon(
              //           Icons.delete,
              //           color: Colors.white,
              //           size: 15,
              //         ),
              //         onPressed: _remove,
              //         // onPressed: () {
              //         //   // 
              //         // },
              //       ),
              //       Text(' Selected Files: ${_selectedFiles}'),
              //     ],
              //   ),
              // ),

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
                        icon: 'assets/icon_toast/check-circle.svg',
                        label: 'Submit',
                        onPressed: saveData,
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
                          Navigator.pushNamed(context, '/Menu');
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


  void _remove() async {
      alert(
      "Remove",
      "Are you sure you want to remove this file?", 
      context,
      onConfirm: () async {
         setState(() {
          Navigator.of(context).pop();
          _selectedFiles = "";
            uploadFile_name = "";
            uploadFile = "";
        }); 
      });
   
  }

  void _pickFiles() async {
   
      if(kIsWeb){
         try {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
             type: FileType.custom,
              allowedExtensions: ['jpg', 'pdf', 'doc'],
            );
            if (result != null) {
              PlatformFile file = result.files.first;
              String filename = file.name;
              String base64Data = base64Encode(file.bytes!);
              setState(() {
                 uploadFile_name = filename;
                 uploadFile = base64Data;
                _selectedFiles = filename;
            });
         
            } else {
              // User canceled the picker
          }
        } catch (e) {
          print('Error picking files: $e');
          // Handle any errors that occur during file picking
        }
      }
      else{
         try {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'pdf', 'doc'],
            withData: true
          );

          if (result != null && result.files.single.path != null) {
            PlatformFile file = result.files.first;
            String base64Data = base64Encode(file.bytes!);
            String filename = file.name;
            log(base64Data);
            setState(() {
               uploadFile_name = filename;
               uploadFile = base64Data;
                _selectedFiles = file.name;
            });
          } else {
            // User canceled the picker
            print("error talga");
          }
          } catch (e) {
            print('Error picking files: $e');
            // Handle any errors that occur during file picking
          }
      }
  
}
  

  void saveData(){
    String requestDate = request_date.text;
    String empname = emp_name.text;
    String dept = department.text;
    String hostpital = getHospital.toString();
    String pos = position.text;
    String businessUnit = bu.text;
    String admit_date = admitdate.text;
    String synt = syntom.text;
    String file_name = uploadFile_name;
    String file_data = uploadFile;
    
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
      Map<String, String> userData = {
        'requestDate': requestDate,
        'empname': empname,
        'dept': dept,
        'hostpital': hostpital,
        'pos': pos,
        'businessUnit': businessUnit,
        'admit_date': admit_date,
        'synt': synt,
        'file_name': file_name,
        'file_data': file_data,
      };
      showPreviewModal(userData);
    }

  }

void showPreviewModal(Map<String, String> userData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Preview Request Form'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomRichText(
                textBeforeSpan: '',
                spanText: 'Employee Details',
                spanStyle: TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.person_rounded,
                iconSize: 18.0,
                iconColor: Colors.white,
                bgColor: Color.fromARGB(128, 48, 206, 171),
              ),
              CustomPreviewData(labelText:'Employee Name :',  data: userData['empname'] ?? ''),
              CustomPreviewData(labelText:'Department :',  data: userData['dept'] ?? ''),
              CustomPreviewData(labelText:'Position :',  data: userData['pos'] ?? ''),
              CustomPreviewData(labelText:'Business Unit :',  data: userData['businessUnit'] ?? ''),
              const SizedBox(height: 15),
             const CustomRichText(
                textBeforeSpan: '',
                spanText: 'Admission Details',
                spanStyle: TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.info_rounded,
                iconSize: 18.0,
                iconColor: Colors.white,
                bgColor: Color.fromARGB(128, 22, 104, 255),
              ),
              CustomPreviewData(labelText:'Request Date :',  data: userData['requestDate'] ?? ''),
              CustomPreviewData(labelText:'Admission Date :',  data: userData['admit_date'] ?? ''),
              CustomPreviewData(labelText:'Hospital :',  data: userData['hostpital'] ?? ''),
              CustomPreviewData(labelText:'Symptoms :',  data: userData['synt'] ?? ''),
            ],
          ),
        ),
        actions: <Widget>[
         CustomButtonWithIcon(
            // icon: 'assets/icon_toast/check-circle.svg',
            label: 'OK',
            onPressed: () async {
               Navigator.pop(context);
            },
          
          )
        ],
      );
    },
  );
}



}