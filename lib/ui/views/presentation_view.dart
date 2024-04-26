import 'package:flutter/material.dart';
import 'package:landing_v3/provider/promotional_widget_height_provider.dart.dart';
import 'package:landing_v3/ui/shared/custom_title_widget.dart';
import 'package:landing_v3/ui/shared/down_arrow_animation_widget.dart';
import 'package:landing_v3/ui/shared/point_row_widget.dart';
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
    double promotionalHeight =
        Provider.of<PromotionalWidgetHeightProvider>(context).height;

    double screenHeight =
        MediaQuery.of(context).size.height - promotionalHeight - 20;

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            height: screenHeight,
            color: Color.fromRGBO(246, 246, 246, 1),
            child: Container(
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
                  DownArrowAnimationWidget(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: screenHeight,
            color: Color.fromRGBO(246, 246, 246, 1),
            child: PointsWidget(constraints: constraints),
          ),
        ],
      );
    });
  }

  Widget _buildVideoPlayer(BoxConstraints constraints) {
    if (isLoading || _controller == null || !_controller!.value.isInitialized) {
      return Container(
          width: constraints.maxWidth > maxWidth
              ? constraints.maxWidth * 0.6
              : null,
          child: Image.asset('assets/tools/Menu.png', fit: BoxFit.cover));
    }

    return Container(
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
                onPressed: toggleMute,
              ),
            ],
          ),
        ],
      ),
    );
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
          constraints.maxWidth > maxWidth ? constraints.maxWidth * 0.4 : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          CustomTitleWidget(
            text: "Impulsa tu Restaurante",
            constraints: constraints,
            maxWidth: maxWidth,
          ),
          const SizedBox(height: 10),
          PointRowWidget(
            text: 'Vende más mostrando mejor tus platillos',
            icon: Icons.trending_up,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "left",
          ),
          const SizedBox(height: 10),
          PointRowWidget(
            text: 'Ahorra dinero en impresiones',
            icon: Icons.attach_money,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "left",
          ),
          const SizedBox(height: 10),
          PointRowWidget(
            text: 'Libera carga de trabajo a tus meseros',
            icon: Icons.group,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "left",
          ),
          const SizedBox(height: 10),
          PointRowWidget(
            text: 'Marketing y promoción para tu restaurante',
            icon: Icons.campaign,
            maxWidth: maxWidth,
            constraints: constraints,
            iconPosition: "left",
          ),
          const SizedBox(height: 20),
          DownArrowAnimationWidget(),
        ],
      ),
    );
  }
}
