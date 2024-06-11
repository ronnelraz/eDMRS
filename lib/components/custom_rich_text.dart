import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String textBeforeSpan;
  final String spanText;
  final TextStyle spanStyle;
  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final Color bgColor;

  const CustomRichText({
    super.key,
    required this.textBeforeSpan,
    required this.spanText,
    required this.spanStyle,
    this.icon,
    this.iconSize = 24.0,
    this.iconColor = Colors.black,
    this.bgColor = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) // Only show the card if an icon is provided
          Card(
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
        if (icon != null) const SizedBox(width: 8), // Add some space between the icon and the text if the icon is present
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
    );
  }
}
