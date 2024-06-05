import 'package:flutter/material.dart';
import '../components/config.dart';

class GridItem extends StatefulWidget {
  final int index;
  final VoidCallback onTap; // Add this line to accept the onTap callback

  const GridItem({Key? key, required this.index, required this.onTap}) : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final iconSize = screenWidth < 650 ? 60.0 : 80.0;
    final textSize = screenWidth < 650 ? 12.0 : 13.0;
    final containerHeight = screenWidth < 650 ? screenHeight * 0.12 : screenHeight * 0.85;
    final containerWidth = screenWidth < 650 ? screenWidth * 0.35 : screenWidth * 0.28;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _controller.forward(from: 500.0); // Trigger the bounce animation
          widget.onTap(); // Call the onTap function passed to the widget
        },
        onHover: (isHovered) {
          setState(() {
            _isHovered = isHovered;
          });
        },
        borderRadius: BorderRadius.circular(20.0),
        splashColor: Colors.blue.withOpacity(0.5),
        highlightColor: Colors.blue.withOpacity(0.5),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                alignment: Alignment.center,
                scale: _animation.value,
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100), // Adjust duration here
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? (isDarkMode ? Color.fromARGB(255, 95, 196, 255) : const Color.fromARGB(255,  95, 196, 255) )
                        : (isDarkMode ? Color.fromARGB(255, 81, 81, 81) : const Color.fromARGB(255, 255, 255, 255) ),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      if (_isHovered)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  height: containerHeight,
                  width: containerWidth,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        buildImage(Menuicons[widget.index], iconSize, iconSize, Alignment.center),
                        const SizedBox(height: 10),
                        Text(
                          Menutitle[widget.index].toUpperCase(),
                          style: TextStyle(
                            color: isDarkMode ? Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
                            fontSize: textSize,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
