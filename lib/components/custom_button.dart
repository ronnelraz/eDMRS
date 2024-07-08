// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import '../components/config.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final String? icon; // Accepts either IconData or Widget
  final String label;
  final Function onPressed;
  final Color color;
  final Color iconColor;
  final double? brnRadius;

  const CustomButtonWithIcon({
    Key? key,
    this.icon,
    required this.label,
    required this.onPressed,
    this.color = Colors.blue,
    this.iconColor = Colors.white,
    this.brnRadius = 10.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = icon != null
        ? buildSvgPicture(
            icon!, 
            BoxFit.scaleDown,
            width: 20,
            height: 20,
            color: Colors.white
          )
        : SizedBox(); // Use SizedBox if icon is null

    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(brnRadius ?? 8.00),
      child: Ink(
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(brnRadius ?? 8.00),
        ),
        child: InkWell(
          onTap: () {
            onPressed();
          },
          borderRadius: BorderRadius.circular(brnRadius ?? 8.00),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                iconWidget,
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
