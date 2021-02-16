import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/realtime/live_camera.dart';
import 'package:object_detection/static%20image/static.dart';
import 'package:flutter_rtmp_publisher/flutter_rtmp_publisher.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  // initialize the cameras when the app starts
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  // running the app
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _streamURL = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Object Detector App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: aboutDialog,
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: 170,
                child: RaisedButton(
                  child: Text("Detect in Image"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StaticImage(),
                      ),
                    );
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 170,
                child: RaisedButton(
                  child: Text("Real Time Detection"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveFeed(cameras),
                      ),
                    );
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 170,
                child: RaisedButton(
                  child: Text("Stream Video"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return SimpleDialog(
                            title: Text('Please enter your RTMP Stream URL'),
                            children: [
                              TextField(
                                controller: _streamURL,
                                keyboardType: TextInputType.url,
                                decoration: InputDecoration(
                                    hintText: '<PLACE_YOUR_RTMP_STREAM_URL>'),
                                onChanged: (url) => _streamURL.text = url,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              RaisedButton(
                                child: Text('Stream Video'),
                                onPressed: () =>
                                    RTMPPublisher.streamVideo(_streamURL.text),
                              )
                            ],
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  aboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "Object Detector App",
      applicationLegalese: "By Rupak Karki",
      applicationVersion: "1.0",
      children: <Widget>[
        Text("www.rupakkarki.com.np"),
      ],
    );
  }
}
