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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 2), // Add some space between label and value
        Expanded(
          child: Text(
            widget.data,
            style: const TextStyle(
              fontSize: 15,
            ),
            overflow: TextOverflow.clip, // Ensure text wraps to the next line
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
