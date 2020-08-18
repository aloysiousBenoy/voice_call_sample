import 'package:flutter/material.dart';
import 'package:voice_call_sample/voice.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  TextEditingController callCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "DinoMeet",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 32,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                width: 200,
                child: TextField(
                  style: TextStyle(color: Colors.blueGrey),
                  controller: callCode,
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  if (callCode.text != '' || callCode.text != null) {
                    await PermissionHandler().requestPermissions(
                      [PermissionGroup.camera, PermissionGroup.microphone],
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoiceCall(
                          channel: callCode.text,
                        ),
                      ),
                    );
                  }
                },
                child: Text("Join Call"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
