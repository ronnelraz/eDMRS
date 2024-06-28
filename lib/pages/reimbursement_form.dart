import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:welfare_claim_system/components/config.dart';

import '../components/custom_text_field.dart';

class ReimbursementForm extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final String reimbursementype;

  const ReimbursementForm({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.reimbursementype,
  });

  @override
  _ReimbursementFormState createState() => _ReimbursementFormState();
}

class _ReimbursementFormState extends State<ReimbursementForm> {
   ScrollController _scrollController = ScrollController();
  double _cardOpacity = 1.0; // Initial opacity value when fully visible
  bool _isScrolledUp = false; // To track if user is scrolling up


 @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if user is scrolling up
    bool scrolledUp = _scrollController.position.userScrollDirection == ScrollDirection.reverse;

    setState(() {
      _isScrolledUp = scrolledUp;
      // Update opacity based on scroll direction
      _cardOpacity = scrolledUp ? 0.0 : 1.0; // Fade out when scrolling up
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color.fromARGB(255, 46, 46, 46) : Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            bottom: PreferredSize(
              child: Container(),
              preferredSize: Size(0, 30),
            ),
          
            floating: false,
            pinned: true,
            centerTitle: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.2,
             flexibleSpace: Stack(
              children: [
                const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image(
                      fit: BoxFit.cover,
                     image: AssetImage('assets/reimburse.png'),
                    )),
                Positioned(
                  bottom: -1,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? Color.fromARGB(255, 46, 46, 46) : Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
                
                Positioned(
                  top: 120.0, // Adjust this value to control the overlap more or less
                  left: 25.0,
                  right: 25.0,
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            widget.reimbursementype,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1),
                          // Add more content here if needed
                          const Text(
                            'Additional information can go here.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
            backgroundColor: const Color.fromARGB(255, 64, 113, 187),
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.6),
                ),
                child: IconButton(
                  tooltip: "Back to Reimbursement",
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/Reimbursement');
                  },
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: IconButton(
                    icon: Icon(widget.isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
                    color: widget.isDarkMode
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 248, 213, 11),
                    onPressed: widget.toggleTheme,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.6)),
                  ),
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
              ),
            ],
          ),
          SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                 const SizedBox(height: 10),
                CustomTextField(
                  labelText: 'Employee Name',
                  customerRadius: 10.0,
                  controller: TextEditingController(),
                  focusNode: FocusNode(),
                  cursorColor: const Color.fromRGBO(43, 42, 42, 1),
                ),
                
                // Add more widgets here if needed
              ],
            ),
          ),
        ),
            
        ],
      ),
    );
  }
}
