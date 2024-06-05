import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final double height;
  final VoidCallback onTap;
  final bool isWideLayout;
  final String status;
  final Color color;

  CustomCard({
    required this.icon,
    required this.title,
    required this.height,
    required this.onTap,
    this.isWideLayout = false, // Default is false for narrow layout (mobile)
    required this.status,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    // Check if the layout is wide (desktop)
    final bool isWideLayout = MediaQuery.of(context).size.width > 600;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Status section (Approved/Pending/Submitted)
                Container(
                 
                  width: 80,
                  padding: const EdgeInsets.all(8.0),
                  color: color, // Implement getStatusColor() function
                  alignment: Alignment.center,
                  child: RotatedBox(
                    quarterTurns: isWideLayout ? 0 : 3, // Rotate text for narrow layout (mobile)
                    child: Text(
                      status, // Implement getStatusText() function
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Content section (Icon and Title)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(icon, size: 50, color: Theme.of(context).primaryColor),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Implement getStatusColor() function to determine the color based on status
  Color getStatusColor() {
    // You can implement your logic here to determine the color based on status
    return Colors.blue; // Default color
  }

  // Implement getStatusText() function to determine the text based on status
  String getStatusText() {
    // You can implement your logic here to determine the text based on status
    return "Approved"; // Default status text
  }
}



 //   body: ListView.builder(
      //   itemCount: 4, // Number of cards
      //   itemBuilder: (context, index) {
      //     // Sample status list, replace this with your actual status list
      //     List<String> statusList = ['Approved', 'Pending', 'Submitted', 'Approved'];
      //     List<Color> colorList = [Colors.blue, Colors.orange, Colors.yellow, Colors.green];

      //     return Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      //       child: CustomCard(
      //         title: 'Card ${index + 1}',
      //         icon: Icons.local_hospital, // Replace with appropriate icons
      //         onTap: () {
      //           // Define actions on tap
      //           print('Card ${index + 1} tapped');
      //         },
      //         height: 150, // Fixed height for each card
      //         status: statusList[index],
      //         color: colorList[index],
      //       ),
      //     );
      //   },
      // ),

      // floatingActionButton: FloatingActionButton(
      //   elevation: App.elevation, // Customize elevation
      //   backgroundColor: Colors.blue, // Customize background color
      //   hoverColor: Color.fromARGB(255, 146, 196, 236), // Customize hover color
      //   onPressed: () {
      //     // Define actions when the FAB is pressed
      //     print('FAB pressed');
      //   },
      //   child: Icon(Icons.add),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0), // Make the FAB circular
      //   ), // You can change the icon as needed
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position the FAB at the bottom right corner