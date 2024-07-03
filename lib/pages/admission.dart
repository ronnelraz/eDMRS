
import 'package:card_loading/card_loading.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:toastification/toastification.dart';
import 'package:welfare_claim_system/API/API_Depedents.dart';
import 'package:welfare_claim_system/API/API_Hospital.dart';
import 'package:welfare_claim_system/API/API_MedicalNeeds.dart';
import 'package:welfare_claim_system/API/API_SaveHeader.dart';
import 'package:welfare_claim_system/API/api_service.dart';
import 'package:welfare_claim_system/components/custom_rich_text.dart';
import 'package:welfare_claim_system/model/dependents.dart';
import 'package:welfare_claim_system/model/hospitals.dart';
import 'package:welfare_claim_system/model/medicalneed.dart';
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
import 'package:flutter/foundation.dart' show kIsWeb;


class Admission extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final String title;
  final String subTitle;
  final String welfareSubCode;
  final bool isDependent;
  final String balanceCode;
  final String balance;

  const Admission({
    super.key, 
    required this.toggleTheme, 
    required this.isDarkMode,
    required this.title,
    required this.subTitle,
    required this.welfareSubCode,
    required this.isDependent,
    required this.balanceCode,
    required this.balance
    });

  @override
  // ignore: library_private_types_in_public_api
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

 

  // String _selectedFiles = "";

   Map<String, String> _employeeInfo = {};
  //  bool _isLoading = true;
  //  bool _isLoadingScreen = true;

  //  String uploadFile_name = "";
  //  String uploadFile = "";
  //  bool _isLoadings = true;


  List<HospitalsItem> hospitalsItem = [];
  bool isloadHospital = true;
  String selectedHospitalCode = "";
  String selectedHospitalName = "";

   List<MedicalNeedItem> medicalNeeds = [];
   bool isLoadData = true;
   String selectedMedicalNeedsID = "";
   String selectedMedicalNeedsName = "";

   List<DependentsItem> dependents = [];
   bool isLoadDependent = true;
   String selectedDependentName = "";


   @override
  void initState() {
    super.initState();
     _loadEmployeeInfo();
      dataLoadFunction();
       loadHospitals();
       loadMedicalNeeds();
       loadDependents();
  }

  @override
  void dispose() {
        empNameFocus.dispose();
        departmentFocus.dispose();
        positionFocus.dispose();
        buFocus.dispose();
        admitdateFocus.dispose();
        syntomFocus.dispose();
         medicalNeeds = [];
         hospitalsItem = [];
         dependents = [];
        super.dispose();
  }

  

 Future<void> loadMedicalNeeds() async {
  
    bool success = await medicalneeds((update) {
      setState(update);
    }, medicalNeeds, isLoadData);
    if (success) {
      log("Data loaded successfully");
      isLoadData = false;
    } else {
      log("Failed to load data");
       isLoadData = false;
    }
  }

   Future<void> loadDependents() async {
    if(widget.isDependent){
          Map<String, String> info = await getEmployeeInfo();
          Map<String, dynamic> payload = {
              'emp_ID': info['EMPID'] ?? ''
          };

          bool success = await apidependents((update) {
            setState(update);
          }, dependents,payload,isLoadDependent);
          if (success) {
            log("Data loaded successfully dependent");
            isLoadDependent = false;
          } else {
              PanaraInfoDialog.showAnimatedGrow(
                  context,
                  title: "Dependent",
                  message: "Sorry, no dependent is set up in your account. Please Contact HR to add dependents to continue.",
                  buttonText: "Ok",
                  onTapDismiss: () {
                    //  Navigator.pushNamed(context, '/Menu');
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  panaraDialogType: PanaraDialogType.error,
                );
            isLoadDependent = false;
       }
    }
  }

  

  Future<void> loadHospitals() async {
    bool success = await hospitalList((update) {
      setState(update);
    }, hospitalsItem, isloadHospital);
    if (success) {
      log("Data loaded successfully");
      isloadHospital = false;
    } else {
      log("Failed to load data");
       isloadHospital = false;
    }
  }
  



   dataLoadFunction() async {
  
    await Future.delayed(const Duration(seconds: 0));

    Map<String, String> info = await getEmployeeInfo();

    setState(() {
      _employeeInfo = info;
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
    });
  }





  final ScrollController _scrollController = ScrollController();
    bool _keyboardVisible = false;


  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false, // Disable automatic back button
        leading: Row(
          children: <Widget>[
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Navigator.pushNamed(context, '/Menu');
                 Navigator.of(context).pop();
              },
            ),
            // Add your additional icon here
          ],
        ),
        title:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.title,
              child: Text(
                
                widget.title,
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
            Hero(
              tag: widget.subTitle,
              child: Text(
                widget.subTitle,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Colors.white),
              ),
            ),
          ],
        ),
        // leading: buildImage('assets/menu/admission.png', 40, 40, Alignment.centerRight),
          actions: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0), // Adjust the margin as needed
          //   child: IconButton(
          //     icon: Icon(widget.isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
          //     onPressed: widget.toggleTheme,
          //   ),
          // ),
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
                        color:  Colors.white,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:  Colors.white,
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
         height: MediaQuery.of(context).size.height,
         color:  Colors.blue,
        child: Padding(
          padding: const EdgeInsets.only(right:0.0, left: 0.0 ),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5, 
                    blurRadius: 2, 
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            child: Form(
              key: _formKey,
              child: Padding(
               padding: const EdgeInsets.only(left: 20, right: 20, top: 1),
                child: ListView(
                  controller: _scrollController,
                  reverse: false,
                  shrinkWrap: true,
                  children: [
                     const SizedBox(height: 30),
                    CustomTextField(
                      customerRadius: 10.0,
                      controller: request_date,
                      readonly: true,
                      hintText: "Request Date",
                      cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                    ),
                    // Other form fields
                    const SizedBox(height: 20),
                    CustomTextField(
                      readonly: true,
                      customerRadius: 10.0,
                      controller: emp_name,
                      focusNode: empNameFocus,
                      cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                    ),
                    // Employee Name Field
                      const SizedBox(height: 20),
                    // Business Unit Field
                    CustomTextField(
                      readonly: true,
                      customerRadius: 10.0,
                      controller: bu,
                      focusNode: buFocus,
                      cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                    ),
                    const SizedBox(height: 20),
                    // Department Field
                   CustomTextField(
                    readonly: true,
                      customerRadius: 10.0,
                      controller: department,
                      focusNode: departmentFocus,
                      cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                    ),
                    const SizedBox(height: 20),
                    // Position Field
                     CustomTextField(
                      readonly: true,
                      customerRadius: 10.0,
                      controller: position,
                      focusNode: positionFocus,
                      cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                    ),

                     const SizedBox(height: 20),
                      if(widget.isDependent) ...[
                           isLoadDependent ?
                            CardLoading(
                              height: 25,
                              borderRadius: const BorderRadius.all(Radius.circular(13)),
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(top: 8),
                            )
                          : CustomDropdown<String>.search(
                              hintText: 'Select Dependent',
                              items: dependents.map((e) => '${e.dependentName} - ${e.dependentRelation}').toList(), 
                              excludeSelected: false,
                              decoration: CustomDropdownDecoration(
                                expandedFillColor: widget.isDarkMode ? Color.fromARGB(255, 68, 68, 68) : const Color.fromARGB(255, 255, 255, 255),
                                closedFillColor: widget.isDarkMode ? const Color.fromARGB(255, 68, 68, 68) : Colors.white,
                                
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
                                List<String> name = value!.split(' - ');
                                String getname = name[0];
                                setState(() {
                                    log('Selected value: $getname');
                                    selectedDependentName =  getname;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                      ],
                    

                    isloadHospital ?
                      CardLoading(
                        height: 25,
                        borderRadius: const BorderRadius.all(Radius.circular(13)),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 8),
                      )
                    : CustomDropdown<String>.search(
                        hintText: 'Name of Hospital',
                        items: hospitalsItem.map((e) => e.hospitalfname).toList(), 
                        excludeSelected: false,
                        decoration: CustomDropdownDecoration(
                          expandedFillColor: widget.isDarkMode ? Color.fromARGB(255, 68, 68, 68) : const Color.fromARGB(255, 255, 255, 255),
                          closedFillColor: widget.isDarkMode ? const Color.fromARGB(255, 68, 68, 68) : Colors.white,
                          
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
                              int selectedIndex = hospitalsItem.indexWhere((element) => element.hospitalfname == value);
                              selectedHospitalName = value!;
                              selectedHospitalCode = hospitalsItem[selectedIndex].hospitalcode;
                              log('Selected value: $value, Index: $selectedIndex, code: $selectedHospitalCode');
                           });
                        },
                      ),
                      
                     const SizedBox(height: 20),
                    // Name of Hospital Field (Using CustomDropdown)
                    isLoadData ?
                      CardLoading(
                        height: 25,
                        borderRadius: const BorderRadius.all(Radius.circular(13)),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 8),
                      )
                    : CustomDropdown<String>.search(
                        hintText: 'Medical Needs',
                        items: medicalNeeds.map((e) => e.medname).toList(), 
                        excludeSelected: false,
                        decoration: CustomDropdownDecoration(
                          expandedFillColor: widget.isDarkMode ? Color.fromARGB(255, 68, 68, 68) : const Color.fromARGB(255, 255, 255, 255),
                          closedFillColor: widget.isDarkMode ? const Color.fromARGB(255, 68, 68, 68) : Colors.white,
                          
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
                           selectedMedicalNeedsID = value ?? '';
                           int selectedIndex = medicalNeeds.indexWhere((element) => element.medname == value);
                           selectedMedicalNeedsName = value!;
                           selectedMedicalNeedsID = medicalNeeds[selectedIndex].medcode;
                            log('Selected value: $value, Index: $selectedIndex, code: $selectedMedicalNeedsID');

                           });
                        },
                      ),

                    // const SizedBox(height: 20),
                    // // Admission Date Field
                    //   CustomTextField(
                    //   customerRadius: 10.0,
                    //   controller: admitdate,
                    //    readonly: true,
                    //   hintText: 'Admission Date',
                    //   focusNode: admitdateFocus,
                    //   cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                    //   onTapx: () {
                    //     showDatePicker(
                    //       context: context,
                    //       initialDate: _admissionDate,
                    //       firstDate: DateTime.now(),
                    //       lastDate: DateTime(2100),
                    //     ).then((selectedDate) {
                    //       if (selectedDate != null) {
                    //         setState(() {
                    //           _admissionDate = selectedDate;
                    //           admitdate.text = _dateFormat.format(selectedDate);
                    //         });
                    //       }
                    //     });
                    //   },
                    // ),
                      
                    SizedBox(height: 20),
                    Container(
                        height: 6 * 24.0,
                        child: CustomTextArea(
                          keyboard: TextInputType.multiline,
                          maxL: 200,
                          hintText: 'Symptoms',
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
                              label: 'Exit',
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
          // _selectedFiles = "";
          //   uploadFile_name = "";
          //   uploadFile = "";
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
                //  uploadFile_name = filename;
                //  uploadFile = base64Data;
                // _selectedFiles = filename;
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
              //  uploadFile_name = filename;
              //  uploadFile = base64Data;
              //   _selectedFiles = file.name;
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
    String hostpital = selectedHospitalName;
    String medical = selectedMedicalNeedsName;
    String pos = position.text;
    String businessUnit = bu.text;
    // String admit_date = admitdate.text;
    String synt = syntom.text;
    String dependents = widget.isDependent ? selectedDependentName : '';
    // String file_name = uploadFile_name;
    // String file_data = uploadFile;
    
    if(empname.isEmpty){
      //  FocusScope.of(con).requestFocus(empNameFocus);
      FocusScope.of(context).requestFocus(empNameFocus);
      errorMessage("Fullname", "Please Enter your fullname", context);
    }
    else if(dept.isEmpty){
      FocusScope.of(context).requestFocus(departmentFocus);
      errorMessage("Department", "Please Enter your Department",context);
    }
    else if(hostpital.isEmpty){
      errorMessage("Hospital", "Please select a hospital",context);
    }
    else if(medical.isEmpty){
      errorMessage("Medical", "Please select Medical Need",context);
    }
    else if(widget.isDependent && dependents.isEmpty){
      errorMessage("Dependents", "Please Enter Dependent Name",context);
    }
    else if(pos.isEmpty){
       FocusScope.of(context).requestFocus(positionFocus);
       errorMessage("Position", "Please enter your position",context);
    }
    else if(businessUnit.isEmpty){
       FocusScope.of(context).requestFocus(buFocus);
       errorMessage("Business Unit", "Please enter your business unit",context);
    }
    // else if(admit_date.isEmpty){
    //    FocusScope.of(context).requestFocus(admitdateFocus);
    //    errorMessage("Admission Date", "Please select admission date",context);
    // }
    else if(synt.isEmpty){
       FocusScope.of(context).requestFocus(syntomFocus);
       errorMessage("Symptoms", "Please state your symptoms",context);
    }
    else{
      syntomFocus.unfocus();
      Map<String, String> userData = {
        'requestDate': requestDate,
        'empname': empname,
        'dept': dept,
        'hostpital': hostpital,
        'medical': medical,
        'pos': pos,
        'businessUnit': businessUnit,
        // 'admit_date': admit_date,
        'synt': synt,
        'hosital_code':selectedHospitalCode,
        'medical_code':selectedMedicalNeedsID,
        'dependent': dependents
      };
      showPreviewModal(userData);
    }

  }

void showPreviewModal(Map<String, String> userData) {
  showDialog(
    context: context,
    builder: (BuildContext dialogcontext) {
      return AlertDialog(
        title: const Text('Preview Request Form'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomRichText(
                textBeforeSpan: '',
                spanText: 'Employee',
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
              
              if (widget.isDependent) ...[
                const SizedBox(height: 15),
                const CustomRichText(
                  textBeforeSpan: '',
                  spanText: 'Dependent',
                  spanStyle: TextStyle(
                    fontSize: App.card_textsize,
                    fontWeight: FontWeight.bold,
                  ),
                  icon: Icons.family_restroom,
                  iconSize: 18.0,
                  iconColor: Colors.white,
                  bgColor: Color.fromARGB(128, 206, 143, 48),
                ),
                CustomPreviewData(
                  labelText: 'Dependent Name: ',
                  data: userData['dependent'] ?? '',
                ),
                const SizedBox(height: 15),
              ],

             const CustomRichText(
                textBeforeSpan: '',
                spanText: 'Admission',
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
              // CustomPreviewData(labelText:'Admission Date :',  data: userData['admit_date'] ?? ''),
              CustomPreviewData(labelText:'Hospital :',  data: userData['hostpital'] ?? ''),
              CustomPreviewData(labelText:'Medical Need :',  data: userData['medical'] ?? ''),
              CustomPreviewData(labelText:'Symptoms :',  data: userData['synt'] ?? ''),
            ],
          ),
        ),
        actions: <Widget>[
         CustomButtonWithIcon(
            // icon: 'assets/icon_toast/check-circle.svg',
            label: 'OK',
            onPressed: () async {
              Navigator.of(dialogcontext).pop();
              
               PanaraConfirmDialog.showAnimatedGrow(
                  context,
                  title: "Confirmation",
                  message: "Are you sure you want to request submit this form?",
                  confirmButtonText: "Confirm",
                  cancelButtonText: "Cancel",
                  onTapCancel: () {
                    Navigator.pop(context);
                  },
                  onTapConfirm: () async {
                     
                     Map<String, String> info = await getEmployeeInfo();
                     Map<String, dynamic> payload = {
                        'document_date': convertDateFormat(userData['requestDate'] ?? ''),
                        'welfare_type': widget.welfareSubCode,
                        'med_needs_code': userData['medical_code'] ?? '',
                        'bussiness_unit': info['BU_CODE'] ?? '',
                        'dept_name': userData['dept'] ?? '',
                        'emp_id': info['EMPID'] ?? '',
                        'emp_name': userData['empname'] ?? '',
                        'dependent_name': userData['dependent'] ?? '',
                        'position': userData['pos'] ?? '',
                        'symptoms': userData['synt'] ?? '',
                        'hospital_name': selectedHospitalName,
                        'hos_code': selectedHospitalCode,
                        'balance_code': widget.balanceCode,
                        'balance': widget.balance
                    };
                    log(payload.toString());

                     try {
                          final result = await apisaveHeader(payload,context,widget.isDarkMode);
                          bool success = result['success'];
                          String message = result['message'];

                          if (success) {
                            log('Success: $message');
                            Navigator.pop(context);
                             await notification_toast(
                              // ignore: use_build_context_synchronously
                              context,
                              message,
                              "Submitted successfully!",
                              toastificationType: ToastificationType.success,
                              toastificationStyle: ToastificationStyle.fillColored,
                              descTextColor: Colors.white,
                              icon: const Icon(Icons.info),
                            );

                          } else {
                            log('Failed: $message');
                             Navigator.pop(context);
                            await notification_toast(
                              // ignore: use_build_context_synchronously
                              context,
                              message,
                              "The entry you are trying to add already exists in the system.",
                              toastificationType: ToastificationType.error,
                              toastificationStyle: ToastificationStyle.fillColored,
                              descTextColor: Colors.white,
                              icon: const Icon(Icons.info),
                            );
                          }
                        } catch (error) {
                          log('Error: $error');
                           Navigator.pop(context);
                            await notification_toast(
                              // ignore: use_build_context_synchronously
                              context,
                              "Submit",
                              error.toString(),
                              toastificationType: ToastificationType.info,
                              toastificationStyle: ToastificationStyle.fillColored,
                              descTextColor: Colors.white,
                              icon: const Icon(Icons.info),
                            );
                       }

                      

                    

                    // log(payload.toString());
                    // Navigator.pop(context);
                    //  Navigator.of(context, rootNavigator: true).pop();
                    // Navigator.pushNamed(context, '/Menu');
                  },
                  panaraDialogType: PanaraDialogType.normal,
                );
            },
          
          )
        ],
      );
    },
  );
}



}