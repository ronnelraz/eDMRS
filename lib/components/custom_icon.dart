import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomIcon extends StatefulWidget {
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
  required this.width,
  required this.height,
});


   @override
  _CustomIcon createState() => _CustomIcon();
}

class _CustomIcon extends State<CustomIcon> {
 
  
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        width: widget.width,  // Set the width of the SizedBox
        height: widget.height,  // Set the height of the SizedBox
        child: Container(
          child: Card(
            color: widget.bgColor,
            elevation: 4,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
             gradient: const LinearGradient(
                begin: Alignment.topLeft,  // Adjust the gradient begin point
                end: Alignment.bottomRight, 
                stops: [
                  0.0,
                  0.7,
                ],
                colors: [
                  Color(0xFF8721F3),
                  Color(0xFF309CFB),
                ],
              )
            ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Center(
                  child: FaIcon(
                    widget.icon,
                    size: widget.iconSize,
                    color: widget.iconColor,
                  ),
                  //  Icon(
                  //   icon,
                  //   size: iconSize,
                  //   color: iconColor,
                  // ),
                ),
              ),
            ),
          ),
        ),
      );
  }
}
