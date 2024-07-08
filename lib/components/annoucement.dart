import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';


class AnnoucementTile extends StatelessWidget {
  final List<CarouselItem> itemList;

  const AnnoucementTile({
    super.key,
    required this.itemList,
  });

  @override
  Widget build(BuildContext context) {
    return Container( // adjust width as needed
      height: 210, // adjust height as needed
      child:  CustomCarouselSlider(
        items: itemList,
        height: 150,
        subHeight: 50,
        width: MediaQuery.of(context).size.width * .9,
        autoplay: true,
        animationCurve: Curves.ease,
        autoplayDuration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 300),
        // animationDuration: const Duration(seconds: 0),
        // indicatorPosition: IndicatorPosition.insidePicture,
      ),
    );
  }
}
