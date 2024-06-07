import 'package:flutter/material.dart';
import '../components/config.dart';

class CustomLoading extends StatelessWidget {
  final String img; 
  final String text;

  const CustomLoading({
    Key? key,
    required this.img,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildImage(img, 100, 100, Alignment.center), // Changed Widget.img to img
          const SizedBox(height: 10),
          Text(
            text, // Changed Widget.text to text
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 15.0,
              fontWeight: FontWeight.w900,
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ),
    );
  }
}
