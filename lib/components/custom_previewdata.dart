import 'package:flutter/material.dart';

class CustomPreviewData extends StatefulWidget {
  final String labelText;
  final String data;


  const CustomPreviewData({
    super.key,
    required this.labelText,
    required this.data,
    
  });

  @override
  _CustomPreviewDataState createState() => _CustomPreviewDataState();
}

class _CustomPreviewDataState extends State<CustomPreviewData> {

  @override
  Widget build(BuildContext context) {
   
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(width: 2), // Add some space between label and value
        Text(
          widget.data,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
