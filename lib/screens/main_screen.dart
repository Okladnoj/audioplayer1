import 'package:audioplayer1/res/const.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MyPlaer extends StatefulWidget {
  final String _urlRadio;

  const MyPlaer({@required String urlRadio}) : _urlRadio = urlRadio;
  @override
  _MyPlaerState createState() => _MyPlaerState(urlRadio: _urlRadio);
}

class _MyPlaerState extends State<MyPlaer> {
  final String _urlRadio;
  AudioPlayer audioPlayer;
  PlayerState _playerState = PlayerState.stopped;
  Stopwatch _stopwatch;
  List<Text> _listTimerText;

  _MyPlaerState({@required String urlRadio}) : _urlRadio = urlRadio;
  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _isStopped => _playerState == PlayerState.stopped;
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playerState = PlayerState.stopped;
    _stopwatch = Stopwatch();
    _listTimerText = [Text('Пусто')];
    audioPlayer.icyMetadataStream.listen((event) {
      setState(() {
        _listTimerText.clear();
        _listTimerText.add(Text('${event.info.title}'));
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    audioPlayer.dispose();
    _stopwatch.stop();
  }

  play() async {
    print('Is press play');
    if (_isPaused || _isStopped) {
      setState(() {
        _stopwatch.start();
        _listTimerText.clear();
        _listTimerText.add(Text('Воспроизведение...'));
      });

      try {
        await audioPlayer.setUrl(_urlRadio);
        setState(() {
          audioPlayer.play();
          _stopwatch.start();
          _listTimerText.clear();
          _listTimerText.add(Text('Воспроизведенo'));
          _playerState = PlayerState.playing;
        });
      } catch (e) {
        setState(() {
          _listTimerText.clear();
          _listTimerText
              .add(Text('Воспроизведение не удалось\n ${e.toString()}.'));
        });
      }
    }
  }

  pause() async {
    print('Is press pause');
    setState(() {
      _listTimerText.clear();
      _listTimerText.add(Text('Нажата кнопка "Паузы"'));
    });
    if (_isPlaying) {
      try {
        await audioPlayer.pause();
        setState(() {
          _listTimerText.clear();
          _listTimerText
              .add(Text('Пауза через ${_stopwatch.elapsedMilliseconds}. mls.'));
          _stopwatch.stop();
          _playerState = PlayerState.paused;
        });
      } catch (e) {
        setState(() {
          _listTimerText.clear();
          _listTimerText.add(Text('Пауза не удалась\n ${e.toString()}.'));
        });
      }
    }
  }

  stop() async {
    print('Is press stop');
    setState(() {
      _listTimerText.clear();
      _listTimerText.add(Text('Нажата кнопка "Стоп"'));
    });
    if (_isPlaying || _isPaused) {
      try {
        await audioPlayer.stop();
        setState(() {
          _listTimerText.clear();
          _listTimerText
              .add(Text('Стоп через ${_stopwatch.elapsedMilliseconds}. mls.'));
          _stopwatch.reset();
          _playerState = PlayerState.stopped;
        });
      } catch (e) {
        setState(() {
          _listTimerText.clear();
          _listTimerText.add(Text('Стоп не удался\n ${e.toString()}.'));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.lightBlueAccent,
        child: Container(
          height: 120,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(2),
                  color: Colors.black12,
                  child: SingleChildScrollView(
                      child: Text('Адрес воспроизведения:\n$_urlRadio')),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black26,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _listTimerText,
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          play();
                        },
                        child: Icon(
                          Icons.play_circle_outline,
                          size: sizeIcon,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          pause();
                        },
                        child: Icon(
                          Icons.pause,
                          size: sizeIcon,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          stop();
                        },
                        child: Icon(
                          Icons.stop,
                          size: sizeIcon,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          audioPlayer.setVolume(0.1);
                        },
                        child: Icon(
                          Icons.volume_down,
                          size: sizeIcon,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          audioPlayer.setVolume(1);
                        },
                        child: Icon(
                          Icons.volume_up,
                          size: sizeIcon,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
