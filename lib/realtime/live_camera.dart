import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_rtmp_publisher/flutter_rtmp_publisher.dart';
import 'package:object_detection/realtime/bounding_box.dart';
import 'package:object_detection/realtime/camera.dart';
import 'dart:math' as math;
import 'package:tflite/tflite.dart';

class LiveFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  LiveFeed(this.cameras);
  @override
  _LiveFeedState createState() => _LiveFeedState();
}

class _LiveFeedState extends State<LiveFeed> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  initCameras() async {}
  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/models/ssd_mobilenet.tflite",
      labels: "assets/models/labels.txt",
    );
  }

  var _streamURL = TextEditingController();

  /* 
  The set recognitions function assigns the values of recognitions, imageHeight and width to the variables defined here as callback
  */
  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTfModel();
    _streamURL.text = '';
  }

  @override
  void dispose() {
    _streamURL.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Real Time Object Detection"),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.stream),
        //     onPressed: () {
        //       showDialog(
        //           context: context,
        //           builder: (_) {
        //             return SimpleDialog(
        //               title: Text('Please enter your RTMP Stream URL'),
        //               children: [
        //                 TextField(
        //                   controller: _streamURL,
        //                   keyboardType: TextInputType.url,
        //                   decoration: InputDecoration(
        //                       hintText: '<PLACE_YOUR_RTMP_STREAM_URL>'),
        //                   onChanged: (url) => _streamURL.text = url,
        //                 ),
        //                 SizedBox(
        //                   height: 10,
        //                 ),
        //                 RaisedButton(
        //                   child: Text('Stream Video'),
        //                   onPressed: () =>
        //                       RTMPPublisher.streamVideo(_streamURL.text),
        //                 )
        //               ],
        //             );
        //           });
        //     },
        //   )
        // ],
      ),
      body: Stack(
        children: <Widget>[
          CameraFeed(widget.cameras, setRecognitions),
          BoundingBox(
            _recognitions == null ? [] : _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
          ),
        ],
      ),
    );
  }
}
