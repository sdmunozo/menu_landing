import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:landing_v3/data/landing_user_event_model.dart';
import 'package:landing_v3/provider/promotional_widget_height_provider.dart.dart';
import 'package:landing_v3/provider/user_event_provider_provider.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/down_arrow_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

const maxWidth = 1000.0;

double responsiveFontSize(double baseSize, BoxConstraints constraints) {
  return constraints.maxWidth > maxWidth ? baseSize + 10 : baseSize;
}

TextStyle subtitleStyle(BoxConstraints constraints) => TextStyle(
      fontFamily: 'Helvetica',
      fontSize: responsiveFontSize(20, constraints),
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );

TextStyle titleStyle(BoxConstraints constraints) => TextStyle(
      fontFamily: 'Helvetica',
      fontSize: responsiveFontSize(24, constraints),
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );

class PresentationView extends StatefulWidget {
  final GlobalKey viewKey;

  const PresentationView({super.key, required this.viewKey});

  @override
  State<PresentationView> createState() => _PresentationViewState();

  double getWidgetHeight() {
    final RenderBox renderBox =
        viewKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }
}

class _PresentationViewState extends State<PresentationView> {
  VideoPlayerController? _controller;
  bool isMuted = false;
  SharedPreferences? prefs;
  bool hasError = false;
  bool isLoading = true;
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    double promotionalHeight =
        Provider.of<PromotionalWidgetHeightProvider>(context).height;

    double screenHeight =
        MediaQuery.of(context).size.height - promotionalHeight;

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        key: widget.viewKey,
        children: [
          SizedBox(
            height: screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTitleWidget(
                  text: "Innova, ahorra y vende más!",
                  constraints: constraints,
                  maxWidth: maxWidth,
                ),
                const SizedBox(height: 10),
                Text(
                  "Tu menú digital te espera para cambiar el juego en tu restaurante",
                  style: subtitleStyle(constraints),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildVideoPlayer(constraints),
                const SizedBox(height: 20),
                const DownArrowAnimationWidget(),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildVideoPlayer(BoxConstraints constraints) {
    if (isLoading || _controller == null || !_controller!.value.isInitialized) {
      return SizedBox(
          width: constraints.maxWidth > maxWidth
              ? constraints.maxWidth * 0.6
              : null,
          child: Image.asset('assets/tools/Menu.png', fit: BoxFit.cover));
    }

    return SizedBox(
      width:
          constraints.maxWidth > maxWidth ? constraints.maxWidth * 0.55 : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          VideoProgressIndicator(_controller!, allowScrubbing: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(_controller!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                //onPressed: toggleMute,
                onPressed: () => toggleMute(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(videoListener);
    saveVideoPosition();
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> saveVideoPosition() async {
    if (prefs != null && mounted && _controller != null) {
      await prefs!.setDouble(
          'lastPosition', _controller!.value.position.inSeconds.toDouble());
    }
  }

  Future<void> initializeVideoPlayer() async {
    prefs = await SharedPreferences.getInstance();
    double lastPosition = prefs?.getDouble('lastPosition') ?? 0;

    _controller = VideoPlayerController.network(
        'https://api4urest.blob.core.windows.net/landing/MenuDigital.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            isLoading = false;
            _controller!.seekTo(Duration(seconds: lastPosition.toInt()));
            _controller!.addListener(videoListener);
            toggleMute(context);
            _controller!.play();
          });
        }
      }).catchError((error) {
        if (kDebugMode) {
          //print('Error initializing video player: $error');
        }
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
  }

  void videoListener() {
    if (_controller != null &&
        _controller!.value.position >= _controller!.value.duration) {
      _controller!.seekTo(Duration.zero);
      _controller!.play();
    }
    saveVideoPosition();
  }

  void toggleMute(BuildContext context) {
    setState(() {
      isMuted = !isMuted;
      _controller?.setVolume(isMuted ? 0.0 : 1.0);
      if (isMuted) {
        _timer?.cancel();
      } else {
        _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
          setState(() {
            _seconds += 3;
            _logPlaybackEvent(context, _seconds);
          });
        });
      }
    });
  }

  void _logPlaybackEvent(BuildContext context, int playbackSeconds) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('sessionId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();

    EventDetails details = EventDetails(playbackTime: playbackSeconds);

    LandingUserEventModel event = LandingUserEventModel(
        userId: userId ?? 'defaultUserId',
        sessionId: sessionId ?? 'defaultSessionId',
        eventType: 'PlaybackWithVolume',
        eventTimestamp: DateTime.parse(eventTimestamp),
        details: details);

    if (kDebugMode) {
      //print(event.toJson());
    }

    // Imprimir mensaje después de lanzar la URL
    //print('Enviando eventos pendientes... _logPlaybackEvent');
    Provider.of<UserEventProvider>(context, listen: false).addEvent(event);
  }
}

/*
  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
      _controller?.setVolume(isMuted ? 0.0 : 1.0);
      if (isMuted) {
        _timer?.cancel();
      } else {
        _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
          setState(() {
            _seconds += 3;
            _logPlaybackEvent();
          });
        });
      }
    });
  }

*/

/*
  void _logPlaybackEvent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? sessionId = prefs.getString('sessionId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();

    EventDetails details = EventDetails(
        playbackTime:
            _seconds
        );


    LandingUserEventModel event = LandingUserEventModel(
        userId: userId ?? 'defaultUserId',
        sessionId: sessionId ?? 'undefinedSessionId',
        eventType: 'PlaybackWithVolume',
        eventTimestamp: DateTime.parse(eventTimestamp),
        details: details);

    if (kDebugMode) {
      print(event.toJson());
    }
    */

  

/*
  void _logPlaybackEvent() async {
    String? sessionId = prefs?.getString('sessionId');
    String? userId = prefs?.getString('userId');
    String eventTimestamp = DateTime.now().toUtc().toIso8601String();

    var event = {
      "UserId": userId,
      "SessionId": sessionId ?? 'undefinedSessionId',
      "EventType": "PlaybackWithVolume",
      "EventTimestamp": eventTimestamp,
      "EventDetails": {"PlaybackTime": _seconds}
    };

    if (kDebugMode) {
      print(event);
    }
  }*/

