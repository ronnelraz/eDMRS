import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final Color bgColor;
  final double width;
  final double height;  // Add height parameter

  const CustomIcon({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.bgColor,
    required this.width,  // Add width parameter to constructor
    required this.height,  // Add height parameter to constructor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,  // Set the width of the SizedBox
      height: height,  // Set the height of the SizedBox
      child: Card(
        color: bgColor,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
