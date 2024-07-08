import 'package:flutter/material.dart';
import '../components/config.dart';

class ReimburstmentTile extends StatelessWidget {
  final String img; 
  final String text;
  final double width;
  final double height;
  final Function onPressed;
  final String subTitle;

  const ReimburstmentTile({
    super.key,
    required this.img,
    required this.text,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.subTitle
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return  Padding(
                padding: const EdgeInsets.only(
                   top: 5,
                   left: 25,
                   right: 25,
                ),
                child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    splashColor: colorBlue.withOpacity(0.5),
                    highlightColor: colorBlue.withOpacity(0.5),
                     onTap: () {
                      onPressed();
                    },
                    child: Card(
                      elevation: App.elevation,
                      color: colorWhite,
                      shadowColor: colorDarkBlue,
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(width: 1, color: colorDarkBlue)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              buildImageURL(img, width, height, Alignment.center),
                              const SizedBox(height: 1),
                              Hero(
                                tag: text,
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    color: isDarkMode ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ),
                              Hero(
                                tag: subTitle,
                                child: Text(
                                  subTitle,
                                  style: TextStyle(
                                    color: isDarkMode ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w200,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              );
  }
}
