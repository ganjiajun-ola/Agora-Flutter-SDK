import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_engine_example/config/agora.config.dart' as config;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// MediaChannelRelay Example
class MediaChannelRelay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MediaChannelRelay> {
  late final RtcEngine _engine;
  bool isJoined = false;
  int? remoteUid;
  bool isRelaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }

  _initEngine() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    _engine = await RtcEngine.createWithContext(RtcEngineContext(config.appId));
    this._addListener();

    // enable video module and set up video encoding configs
    await _engine.enableVideo();

    // make this room live broadcasting room
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);

    // start joining channel
    // 1. Users can only see each other after they join the
    // same channel successfully using the same app id.
    // 2. If app certificate is turned on at dashboard, token is needed
    // when joining channel. The channel name and uid used to calculate
    // the token has to match the ones used for channel join
    await _engine.joinChannel(config.token, config.channelId, null, 0, null);
  }

  _addListener() {
    _engine.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        print('warning ${warningCode}');
      },
      error: (errorCode) {
        print('error ${errorCode}');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print('joinChannelSuccess ${channel} ${uid} ${elapsed}');
        setState(() {
          isJoined = true;
        });
      },
      userJoined: (uid, elapsed) {
        print('userJoined $uid $elapsed');
        this.setState(() {
          remoteUid = uid;
        });
      },
      userOffline: (uid, reason) {
        print('userOffline $uid $reason');
        this.setState(() {
          remoteUid = null;
        });
      },
      channelMediaRelayStateChanged:
          (ChannelMediaRelayState state, ChannelMediaRelayError code) {
        switch (state) {
          case ChannelMediaRelayState.Idle:
            print('ChannelMediaRelayState.Idle $code');
            this.setState(() {
              isRelaying = false;
            });
            break;
          case ChannelMediaRelayState.Connecting:
            print('ChannelMediaRelayState.Connecting $code)');
            break;
          case ChannelMediaRelayState.Running:
            print('ChannelMediaRelayState.Running $code)');
            this.setState(() {
              isRelaying = true;
            });
            break;
          case ChannelMediaRelayState.Failure:
            print('ChannelMediaRelayState.Failure $code)');
            this.setState(() {
              isRelaying = false;
            });
            break;
          default:
            print('default $code)');
            break;
        }
      },
    ));
  }

  _onPressRelayOrStop() async {
    if (isRelaying) {
      await _engine.stopChannelMediaRelay();
      return;
    }
    if (_controller.text.length == 0) {
      return;
    }

    await _engine.startChannelMediaRelay(ChannelMediaRelayConfiguration(
        ChannelMediaInfo(config.channelId, 0, token: config.token),
        [ChannelMediaInfo('', 0, token: '')]));

    _controller.clear();
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            !isJoined
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: _initEngine,
                          child: Text('Join channel'),
                        ),
                      )
                    ],
                  )
                : _renderVideo(),
            if (isJoined)
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Enter target relay channel name',
                          ))),
                  ElevatedButton(
                    onPressed: _onPressRelayOrStop,
                    child: Text(!isRelaying ? 'Relay' : 'Stop'),
                  ),
                ],
              )
          ],
        ),
      ],
    );
  }

  _renderVideo() {
    return Row(children: [
      Expanded(
        child: AspectRatio(
          aspectRatio: 1,
          child:
              kIsWeb ? RtcLocalView.SurfaceView() : RtcLocalView.TextureView(),
        ),
      ),
      Expanded(
        child: AspectRatio(
          aspectRatio: 1,
          child: remoteUid != null
              ? (kIsWeb
                  ? RtcRemoteView.SurfaceView(
                      uid: remoteUid!,
                      channelId: config.channelId,
                    )
                  : RtcRemoteView.TextureView(
                      uid: remoteUid!,
                      channelId: config.channelId,
                    ))
              : Container(
                  color: Colors.grey[200],
                ),
        ),
      )
    ]);
  }
}
