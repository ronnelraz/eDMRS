import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboard;
  final String? hintText;
  final Widget? prefixIcon;
  final Color cursorColor;
  final bool? isPassword;
  final FocusNode? focusNode;
  final double? customerRadius;
  final bool? readonly;
  final String? labelText;
  final VoidCallback? onTapx;
  // final int? maxLines;
  final int? maxL;

  const CustomTextField({
    super.key,
    required this.controller,
    this.keyboard = TextInputType.text,
    this.hintText,
    this.prefixIcon,
    required this.cursorColor,
    this.isPassword = false,
    this.focusNode,
    this.customerRadius,
    this.readonly = false,
    this.labelText,
    this.onTapx,
    // this.maxLines,
    this.maxL
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ?? false;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final fillColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];
    final borderColor = isDarkMode ? Colors.grey[600]! : Colors.grey[400]!;
    final focusedBorderColor = isDarkMode ? Color.fromARGB(255, 0, 187, 255) : Colors.blue[700]!;

    return TextField(
      // maxLines: 40,
      maxLength: widget.maxL,
      controller: widget.controller,
      keyboardType: widget.keyboard,
      obscureText: _obscureText,
      readOnly: widget.readonly?? false,
      style: TextStyle(fontSize: 18, color: textColor), // Change as per your requirements
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          fontSize: 18, 
          color: Colors.black,
          fontWeight: FontWeight.w900,
          inherit: true
        ),
        contentPadding: const EdgeInsets.only(top: 12.0,left: 10.0),
        constraints: BoxConstraints(maxHeight: height * 0.065, maxWidth: width),
        filled: true,
        fillColor: fillColor, // Change as per your requirements
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: 14, color: textColor.withOpacity(0.6)), // Change as per your requirements
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword!
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey[700], // Change as per your requirements
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.customerRadius ?? 10.0),
          borderSide: BorderSide(
            color: widget.focusNode?.hasFocus ?? false ? const Color.fromARGB(255, 33, 243, 37) : borderColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.customerRadius ?? 10.0),
          borderSide: BorderSide(
            color: focusedBorderColor, // Change the color when focused
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.customerRadius ?? 10.0),
          borderSide: BorderSide(
            color: borderColor, // Change as per your requirements
            width: 1.0,
          ),
        ),
      ),
      cursorColor: widget.cursorColor,
       onTap: widget.onTapx,
    );
  }
}
