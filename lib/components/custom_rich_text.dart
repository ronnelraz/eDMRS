import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String textBeforeSpan;
  final String spanText;
  final TextStyle spanStyle;
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  const CustomRichText({
    Key? key,
    required this.textBeforeSpan,
    required this.spanText,
    required this.spanStyle,
    required this.icon,
    this.iconSize = 24.0,
    this.iconColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded( // Wrap with Expanded
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          SizedBox(width: 4), // Add some space between the icon and the text
          Flexible( // Use Flexible for the RichText to allow it to wrap
            child: RichText(
              overflow: TextOverflow.ellipsis, // Handle overflow
              maxLines: 1, // Limit to a single line
              text: TextSpan(
                text: textBeforeSpan,
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: spanText,
                    style: spanStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
