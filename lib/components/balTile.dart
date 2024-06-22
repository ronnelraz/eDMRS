import 'package:flutter/material.dart';

class BalTile extends StatefulWidget {
  final String title;
  final String balance;
  final double titleSize;
  final double balanceSize;
  final Color titleColor;
  final Color balanceColor;
  final String tag;
  

  const BalTile({
    super.key,
    required this.title,
    required this.balance,
    required this.titleSize,
    required this.balanceSize,
    required this.titleColor,
    required this.balanceColor,
    required this.tag
  });

  @override
  _BalTileState createState() => _BalTileState();
}

class _BalTileState extends State<BalTile> {
  // double _opacity = 0.0;

  // @override
  // void initState() {
  //   super.initState();
  //   // Trigger the fade-in animation when the widget is built
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     setState(() {
  //       _opacity = 1.0;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: widget.titleColor,
                fontSize: widget.titleSize,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.balance,
              style: TextStyle(
                color: widget.balanceColor,
                fontSize: widget.balanceSize,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
      );
  }
}
