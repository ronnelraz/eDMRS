
import 'package:edmrs/components/custom_rich_text.dart';
import 'package:edmrs/pages/admission.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../components/config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class Menu extends StatefulWidget {
  
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  Menu({required this.toggleTheme, required this.isDarkMode});


  @override
  _MenuState createState() => _MenuState();
  
}



class _MenuState extends State<Menu> {

   @override
  void initState() {
    super.initState();
    // Call locStorage to save the page information when the widget is initialized

    if (kIsWeb) {
        pages().then((page) {
            if (page != null) {
              if(page == 'admission'){
                  intent(context, Admission(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode));
              }
            } 
            else {
                callLocStorage();
            }
          });
    } else {
      // NOT running on the web! You can check for additional platforms here.
    }



  }

   void callLocStorage() {
    locStorage("page", "menu");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(App.title,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700
                )
            ), // Title
            const Text(
              App.Subtitle, // Subtitle
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400
              ),
            ),
          ],
        ),
        leading: buildImage('assets/logo.png', 40, 40, Alignment.centerRight), // Icon
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
      
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 802) {
            return buildWideLayout(context,constraints,400.0);
          } else {
            return buildNarrowLayout(context,constraints,700.0);
          }
        },
      ),
    );
  }

  Widget buildWideLayout(BuildContext context, BoxConstraints constraints,double cardwidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(1.0), // Adjust the padding as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLeftColumn(cardwidth),
              buildRightColumn(cardwidth),
            ],
          ),
        ),
         buildFourColumnGrid(constraints,cardwidth,constraints.maxWidth ~/ 210)
   


      ],
    );
  }

  Widget buildNarrowLayout(BuildContext context,BoxConstraints constraints,double cardwidth) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0), // Adjust the padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLeftColumn(cardwidth),
            const SizedBox(height: 1),
            buildRightColumn(cardwidth),
            const SizedBox(height: 1),
            buildFourColumnGrid(constraints,cardwidth,2),
          ],
        ),
      ),
    );
  }


Widget buildFourColumnGrid(BoxConstraints constraints, double cardWidth, int crossAxisCount) {
  double spacing = 10.0; // Define your spacing value here

  double screenWidth = constraints.maxWidth;
  double sidePadding = (screenWidth > 802) ? (screenWidth - 802) / 2 : 16; // Adjust the 802 as needed
  double cardWidth = (screenWidth - sidePadding * 2 - (4 - 1) * 10) / 4; // 4 columns and 10 spacing
  final iconSize = screenWidth < 802 ? 90.0 : 100.0;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ResponsiveGridRow(
          children: List.generate(
            Menutitle.length,
            (index) => ResponsiveGridCol(
              xs: 6,
              md: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    splashColor: Colors.blue.withOpacity(0.5),
                    highlightColor: Colors.blue.withOpacity(0.5),
                    onTap: () {
                      if (index == 0) {
                      alert(
                        "IMPORTANT NOTICE",
                        "This accredited hospital request form is specifically designed for employees who have availed the hospitalization benefit at our affiliated hospitals. Please do not use this form for your Medical Expense Reimbursement.",
                        context,
                        onConfirm: () {
                          intent(context, Admission(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode));
                        },
                      );
                    }
                    if (index == 1) {
                      print("New Card tapped!");
                    }
                    },
                    child: Card(
                      elevation: App.elevation,
                      color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : Color.fromARGB(255, 255, 255, 255),
                      shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              buildImage(Menuicons[index], iconSize, iconSize, Alignment.center),
                              const SizedBox(height: 10),
                              Text(
                                Menutitle[index].toUpperCase(),
                                style: TextStyle(
                                  color: widget.isDarkMode ? Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  
Widget buildLeftColumn(double cardwidth) {
  return Container(
    //constraints: BoxConstraints(maxWidth: 400), // Set the maximum width here
    width: cardwidth, // Set the width here
    child: Card(
      elevation: App.elevation,
      color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : Color.fromARGB(255, 255, 255, 255),
      shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
      borderOnForeground: true,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SizedBox(
        height: App.card_height,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                App.employee,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              CustomRichText(
                textBeforeSpan: getGreeting(),
                spanText: 'Ronnel Ronnel Ronnel Razo',
                spanStyle: const TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: iconGreeting() == 'm' ? Icons.sunny : (iconGreeting() == 'a' ? Icons.wb_sunny_sharp : Icons.nights_stay),
                iconSize: 24.0,
                iconColor: iconGreeting() == 'm' ? const Color.fromARGB(255, 193, 174, 1) : (iconGreeting() == 'a' ? Colors.orange : const Color.fromARGB(255, 91, 91, 91)),
              ),
              const CustomRichText(
                textBeforeSpan: '',
                spanText: 'position',
                spanStyle: TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.info_outline_rounded,
                iconSize: 24.0,
                iconColor: Colors.blue,
              ),
              const CustomRichText(
                textBeforeSpan: '',
                spanText: 'IT Department',
                spanStyle: TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.work,
                iconSize: 24.0,
                iconColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


Widget buildRightColumn(double width) {
  return Container(
    // constraints: BoxConstraints(maxWidth: 400), // Set the maximum width here
     width: width, 
    child: Card(
      color: widget.isDarkMode ? const Color.fromARGB(255, 81, 81, 81) : Color.fromARGB(255, 255, 255, 255),
      shadowColor: widget.isDarkMode ? const Color.fromARGB(255, 109, 109, 109) : const Color.fromARGB(255, 67, 67, 67),
      borderOnForeground: true,
      elevation: App.elevation,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const SizedBox(
        height: App.card_height,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                App.currentBal,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const CustomRichText(
                textBeforeSpan: App.personalBal,
                spanText: '₱100,000',
                spanStyle: TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.wallet_rounded,
                iconSize: 24.0,
                iconColor: Color.fromARGB(255, 12, 149, 30),
              ),
              const CustomRichText(
                textBeforeSpan: App.dependentBal,
                spanText: '₱50,000',
                spanStyle: TextStyle(
                  fontSize: App.card_textsize,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.wallet_rounded,
                iconSize: 24.0,
                iconColor: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


}
