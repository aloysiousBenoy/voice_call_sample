import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class VoiceCall extends StatelessWidget {
  final String channel;

  const VoiceCall({Key key, this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VoiceEngine(
        channel: channel,
      ),
      appBar: AppBar(
        title: Text("Voice Call"),
      ),
    );
  }
}

class VoiceEngine extends StatefulWidget {
  final String channel;

  const VoiceEngine({Key key, this.channel}) : super(key: key);
  @override
  _VoiceEngineState createState() => _VoiceEngineState();
}

class _VoiceEngineState extends State<VoiceEngine> {
  static final _users = <int>[];

  initAgora() async {
    await AgoraRtcEngine.create("dbc7fb90138f4cf9a6bf61629329bf2d");
    await AgoraRtcEngine.disableVideo();
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);
    agoraEventHandler();
    AgoraRtcEngine.joinChannel(null, widget.channel, null, 0);
  }

  agoraEventHandler() {
    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        print("user joined $uid");
        _users.add(uid);
      });
    };
    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        print("Joined channel $channel");
      });
    };
    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        print("Leaving channel");
      });
    };
    AgoraRtcEngine.onUserOffline = (int uid, int elapsed) {
      setState(() {
        print("user has left call $uid");
        _users.remove(uid);
      });
    };
  }

  disposeAgora() async {
    _users.clear();
    await AgoraRtcEngine.leaveChannel();
    await AgoraRtcEngine.destroy();
  }

  @override
  void dispose() {
    disposeAgora();
    super.dispose();
  }

  @override
  void initState() {
    initAgora();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(10),
              child: Text("Ongoing Call"),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.all(5),
                child: Text(_users.toList().toString())),
            IconButton(
                icon: Icon(Icons.call_end),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
