import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

const maxWidth = 1000;

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
  const PresentationView({super.key});

  @override
  State<PresentationView> createState() => _PresentationViewState();
}

class _PresentationViewState extends State<PresentationView> {
  VideoPlayerController? _controller;
  bool isMuted = false;
  SharedPreferences? prefs;
  bool hasError = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Innova, ahorra y vende más!",
            style: titleStyle(constraints),
            textAlign: TextAlign.center,
          ),
          Text(
            "Tu menú digital espera para cambiar el juego",
            style: titleStyle(constraints),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          /*constraints.maxWidth > maxWidth
              ? Row(children: _buildVideoAndText(constraints))
              : Column(children: _buildVideoAndText(constraints)),*/
          constraints.maxWidth > maxWidth
              ? Row(children: _buildVideoAndText(constraints))
              : Column(children: _buildVideoAndText(constraints)),
        ],
      );
    });
  }

  List<Widget> _buildVideoAndText(BoxConstraints constraints) {
    if (isLoading) {
      return [
        Container(
            width: constraints.maxWidth > maxWidth
                ? constraints.maxWidth * 0.6
                : null,
            color: Colors.amber,
            child: Image.asset('assets/tools/Menu.png', fit: BoxFit.cover)),
        PointsWidget(constraints: constraints),
      ];
    }
    return [
      Container(
        width:
            constraints.maxWidth > maxWidth ? constraints.maxWidth * 0.6 : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_controller != null && _controller!.value.isInitialized) ...[
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
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                    onPressed: toggleMute,
                  ),
                ],
              )
            ] else
              Image.asset('assets/tools/Menu.png'),
          ],
        ),
      ),
      PointsWidget(constraints: constraints),
    ];
  }

  @override
  void dispose() {
    _controller?.removeListener(videoListener);
    saveVideoPosition();
    _controller?.dispose();
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
            toggleMute();
            _controller!.play();
          });
        }
      }).catchError((error) {
        print('Error initializing video player: $error');
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

  void toggleMute() {
    setState(() {
      if (isMuted) {
        _controller?.setVolume(1.0);
        isMuted = false;
      } else {
        _controller?.setVolume(0.0);
        isMuted = true;
      }
    });
  }
}

class PointsWidget extends StatelessWidget {
  final BoxConstraints constraints;

  PointsWidget({required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          constraints.maxWidth > maxWidth ? constraints.maxWidth * 0.3 : null,
      child: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('• Vende más mostrando mejor tus platillos',
                style: subtitleStyle(constraints)),
            SizedBox(height: 10),
            Text('• Ahorra dinero en impresiones',
                style: subtitleStyle(constraints)),
            SizedBox(height: 10),
            Text('• Libera carga de trabajo a tus meseros',
                style: subtitleStyle(constraints)),
            SizedBox(height: 10),
            Text('• Marketing y promoción', style: subtitleStyle(constraints)),
          ],
        ),
      ),
    );
  }
}
