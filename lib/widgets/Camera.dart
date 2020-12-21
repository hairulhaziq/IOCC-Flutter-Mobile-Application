import 'package:c4ivc_flutter/utils/LookUpService.dart';
import 'package:c4ivc_flutter/widgets/Carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

GlobalKey<_CameraState> globalKeyCamera = GlobalKey();

class Camera extends StatefulWidget {
  List imageFeeds = [];

  Camera({Key key, this.imageFeeds}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  List _imageList = [];
  File _image;
  int pageIndex = 0;
  final picker = ImagePicker();

  void executeUploadImage(reportId) {
    if (_imageList.length > 0) {
      _imageList.forEach((file) async {
        await _uploadImage(file, reportId);
      });
    }
  }

  Future<void> _uploadImage(File file, int reportId) async {
    final String fileName = file.path.split('/').last;

    String mimeType = mime(fileName);
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path,
          filename: fileName, contentType: MediaType(mimee, type)),
    });

    Dio dio = new Dio();

    dio.options.headers["Content-Type"] = "multipart/form-data";

    var main = {};
    main["CreatedByAccountId"] = 210;
    main["MediaFileName"] = fileName;
    main["MediaTypeId"] = 1;
    main["ReportId"] = reportId;
    main["ReportStatusId"] = 3;

    String str = json.encode(main);
    Response _response;

    _response = await dio.post(
      "http://115.133.238.21:9696/api/reportFeeds?json=[" + str + "]",
      data: data,
      //Listening the uploading progress:
      onSendProgress: (int sent, int total) {
        print("$sent $total");
      },
    );

    if (_response.statusCode == 200) {
      print("Successful");
    } else {
      print("Failed");
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {

      if(pageIndex == 0)
        {
          _image = File(pickedFile.path);
          _imageList.add(_image);
        }

      else
      {
        _image = File(pickedFile.path);
        _imageList.add(_image);
        pageIndex= pageIndex + 1;
      }
    });
  }

  Future getGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      // _image = File(pickedFile.path);
      // _imageList.add(_image);

      if(pageIndex == 0)
      {
        _image = File(pickedFile.path);
        _imageList.add(_image);
      }

      else
      {
        _image = File(pickedFile.path);
        _imageList.add(_image);
        pageIndex= pageIndex + 1;
      }

    });
  }

  Future deleteImage() async {
    setState(() {
      _imageList.removeAt(pageIndex);
    });
  }


  // Components ================================================================

  Widget buttonGallery() {
    return FloatingActionButton(
      hoverColor: Colors.red,
      backgroundColor: Colors.red,
      onPressed: () {
        setState(() {
          _image = null;
        });
      },
      child: Icon(Icons.cancel),
    );
  }

  Widget buttonCamera() {
    return FloatingActionButton(
      hoverColor: Colors.red,
      backgroundColor: Colors.red,
      onPressed: () {
        setState(() {
          _image = null;
        });
      },
      child: Icon(Icons.cancel),
    );
  }

  Widget buttonRemove() {
    return FloatingActionButton(
      hoverColor: Colors.red,
      backgroundColor: Colors.red,
      onPressed: () {
        setState(() {
          print(pageIndex);
          deleteImage();
          _image = null;
        });
      },
      child: Icon(Icons.cancel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      color: Colors.grey.withOpacity(0.2),
      child: Column(
        children: <Widget>[
          CarouselPhoto(widget.imageFeeds, _imageList),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  heroTag: null, // Must have
                  onPressed: getImage,
                  child: Icon(Icons.add_a_photo),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Visibility(
                child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  heroTag: null, // Must have
                  onPressed: getGallery,
                  child: Icon(Icons.image),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Visibility(
                visible: _imageList.length > 0 ? true : false,
                child: buttonRemove()
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Reference:
// https://stackoverflow.com/questions/53692798/flutter-calling-child-class-function-from-parent-class
