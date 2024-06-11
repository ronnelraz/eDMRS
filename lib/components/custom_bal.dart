import 'package:flutter/material.dart';
import 'custom_icon.dart';

class CustomBalance extends StatelessWidget {
  final IconData iconx;
  final String balance;
  final double fontSize;
  final Color colors;
  final Color bgcolor;

  const CustomBalance({
    super.key,
    required this.iconx,
    required this.balance,
    required this.fontSize,
    required this.colors,
    required this.bgcolor
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomIcon(
            width: 50.0,
            height: 50.0,
            icon: iconx,
            iconSize: 30.0,
            iconColor: Colors.white,
            bgColor: bgcolor,
          ),
          Text(
            balance,
            style:  TextStyle(
              fontSize: fontSize,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w900,
              color: colors,
            ),
          ),
        ],
      ),
    );
  }
}
