import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_multi_carousel/carousel.dart';

class CarouselPhoto extends StatefulWidget {
  List imgList = [];
  List imgFeeds = [];
  List _imgAll = [];

  CarouselPhoto(List imgFeeds, List imgList) {
    this.imgList = imgList;

    List iList = [];
    if (imgFeeds.length > 0) {
      imgFeeds.forEach((element) {
        iList.add('http://115.133.238.21:96/uploaded/${element.mediaFileName}');
      });
    }
    _imgAll = this.imgList + iList;
  }

  @override
  CarouselPhotoState createState() => CarouselPhotoState();
}

class CarouselPhotoState extends State<CarouselPhoto> {
  CarouselSlider carouselSlider;
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget._imgAll.length > 0
            ? Carousel(
                onPageChange: (index) {
                  setState(() {
//                        _current = index;
//                        print(_current.toString());
                  });
                },
                showArrow: widget._imgAll.length > 1 ? true : false,
                showIndicator: false,
                height: 290.0,
                width: MediaQuery.of(context).size.width,
                initialPage: 0,
                type: Types.simple,
                axis: Axis.horizontal,
                children: widget._imgAll.map((imgUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: '${imgUrl.runtimeType}' != 'String'
                            ? Image.file(imgUrl, fit: BoxFit.scaleDown)
                            : Image.network(imgUrl, fit: BoxFit.scaleDown),
                      );
                    },
                  );
                }).toList(),
              )
            : Container(
                height: 290.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/img/background/cam.png')),
                ),
              )
      ],
    ));
  }
}
