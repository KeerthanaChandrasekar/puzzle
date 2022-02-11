import 'package:flutter/material.dart';
import 'utils.dart';
import 'model.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Fluzzle',
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            body:
              Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "images/bg.jpg"),
                      fit:BoxFit.fill,
                    ),
                  ),
                  child: BoardWidget()
              )));
  }
}
class MyHomePage extends StatelessWidget {
  final _BoardWidgetState state;
 const MyHomePage({this.state});
  @override
  Widget build(BuildContext context) {
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.tilePadding) /
        state.column;
    List<TileBox> backgroundBox = List<TileBox>();
    for (int r = 0; r < state.row; ++r) {
      for (int c = 0; c < state.column; ++c) {
        TileBox tile = TileBox(
          left: c * width * state.tilePadding * (c + 1),
          top: r * width * state.tilePadding * (r + 1),
          size: width,
        );
        backgroundBox.add(tile);
      }
    }
    return Positioned(
      left: 50,
      top: 50,
      bottom: 50,
      right:50,
      child: Container(
        width: state.boardSize().width,
        height: state.boardSize().width,
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Stack(
          children: backgroundBox,
        ),
      ),
    );
  }
}
 class BoardWidget extends StatefulWidget {
  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}
class _BoardWidgetState extends State<BoardWidget> {
  Board _board;
  int row;
  int column;
  bool _isMoving;
  bool gameOver;
  double tilePadding = 5.0;
  MediaQueryData _queryData;
  @override
  void initState() {
    super.initState();
    row = 4;
    column = 4;
    _isMoving = false;
    gameOver = false;
    _board = Board(row, column);
    newGame();
  }
  void newGame() {
    setState(() {
      _board.initBoard();
      gameOver = false;
    });
  }
  void gameover() {
    setState(() {
      if (_board.gameOver()) {
        AssetsAudioPlayer.newPlayer().seek(Duration(milliseconds: 50));
        AssetsAudioPlayer.newPlayer().open(
          Audio("audios/loss.mp3"),
          autoStart: true,
          //loopMode: LoopMode.single
        );
        gameOver = true;
      }
    });
  }
  Size boardSize() {
    Size size = _queryData.size;
    return Size(size.width, size.width);
  }
  @override
  Widget build(BuildContext context) {
    _queryData = MediaQuery.of(context);
    List<TileWidget> _tileWidgets = List<TileWidget>();
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _tileWidgets.add(TileWidget(tile: _board.getTile(r, c), state: this));
      }
    }
    List<Widget> children = List<Widget>();
    children.add(MyHomePage(state: this));
    children.addAll(_tileWidgets);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: BorderedText(
            strokeWidth: 4.0, strokeColor: Colors.black,
            child:Text(
              'FLUZZLE',
              style: TextStyle(
                fontSize: 70.0,
                letterSpacing: 4,
                fontFamily: 'Bangers-Regular',
                foreground: Paint()..shader = LinearGradient(
                  colors: <Color>[
                    Colors.blue,
                    Colors.pinkAccent,
                    //add more color here.
                  ],
                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
            ),),

          )
        ),
        Container(
            child: BorderedText(
              strokeWidth: 4.0, strokeColor: Colors.black,
              child:Text(
                'FIVE12',
                style: TextStyle(
                    fontSize: 35.0,
                    letterSpacing: 4,
                    fontFamily: 'Bangers-Regular',
                    foreground: Paint()..shader = LinearGradient(
                      colors: <Color>[
                        Colors.indigo,
                        Colors.red,
                        Colors.lightBlueAccent,
                        //add more color here.
                      ],
                    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
                ),),

            )
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 120.0,
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[BorderedText(strokeWidth: 2.0, strokeColor: Colors.white,
                        child:Text("Score",style: TextStyle(fontWeight: FontWeight.bold,
                            fontFamily: 'Bangers-Regular',
                            letterSpacing:3,color: Colors.redAccent,fontSize:25),),),
                    BorderedText(strokeWidth: 3.0, strokeColor: Colors.black87,
                      child: Text("${_board.score}",style: TextStyle(fontWeight: FontWeight.bold,
                          letterSpacing:2,color: Colors.lightBlueAccent.shade200,fontSize:25),))],
                    )),
              ),
              TextButton(
                child: Container(
                  width: 128.0,
                  height: 60.0,
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Center(
                    child:BorderedText(strokeWidth: 2.0, strokeColor: Colors.white,
                      child:Text("New game",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.pink.shade400,
                          fontFamily: 'Bangers-Regular',
                          letterSpacing:4,fontSize:24),),)
                  ),
                ),
                onPressed: () {
                  newGame();
                },
              )
            ],
          ),
        ),
        Container(
            height: 40.0,
            child: Opacity(
              opacity: gameOver ? 1.0 : 0.0,
              child: Center(
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 45,
                    fontFamily: 'Bangers-Regular',
                    color: Colors.pink,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.white,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      FlickerAnimatedText('GAME OVER'),
                      FlickerAnimatedText('GAME OVER'),
                    ],
                    onTap: () {

                    },
                  ),
                ),
              ),
            )),
        Container(
          width: _queryData.size.width,
          height: _queryData.size.width,
          child: GestureDetector(
            onVerticalDragUpdate: (detail) {
              if (detail.delta.distance == 0 || _isMoving) {
                return;
              }
              _isMoving = true;
              if (detail.delta.direction > 0) {
                setState(() {
                  _board.moveDown();
                  gameover();
                });
              } else {
                setState(() {
                  _board.moveUp();
                  gameover();
                });
              }
            },
            onVerticalDragEnd: (d) {
              _isMoving = false;
            },
            onVerticalDragCancel: () {
              _isMoving = false;
            },
            onHorizontalDragUpdate: (d) {
              if (d.delta.distance == 0 || _isMoving) {
                return;
              }
              _isMoving = true;
              if (d.delta.direction > 0) {
                setState(() {
                  _board.moveLeft();
                  gameover();
                });
              }
              else {
                setState(() {
                  _board.moveRight();
                  gameover();
                });
              }
            },
            onHorizontalDragEnd: (d) {
              _isMoving = false;
            },
            onHorizontalDragCancel: () {
              _isMoving = false;
            },
            child: Stack(
              children: children,
            ),
          ),
        )
      ],
    );
  }
}
class TileWidget extends StatefulWidget {
  final Tile tile;
  final _BoardWidgetState state;
  const TileWidget({Key key, this.tile, this.state}) : super(key: key);
  @override
  _TileWidgetState createState() => _TileWidgetState();
}
class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        milliseconds: 200,
      ),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    widget.tile.isNew = false;
  }
  @override
  Widget build(BuildContext context) {
    if (widget.tile.isNew && !widget.tile.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.tile.isNew = false;
    } else {
      controller.animateTo(1.0);
    }
    return AnimatedTileWidget(
      tile: widget.tile,
      state: widget.state,
      animation: animation,
    );
  }
}
class AnimatedTileWidget extends AnimatedWidget {
  final Tile tile;
  final _BoardWidgetState state;
  AnimatedTileWidget({
    Key key,
    this.tile,
    this.state,
    Animation<double> animation,
  }) : super(
    key: key,
    listenable: animation,
  );
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double animationValue = animation.value;
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 23) * state.tilePadding) /
        state.column;
    _showAlert(context) {
      Future.delayed(Duration.zero, () async {
        var alertStyle = AlertStyle(
          animationType: AnimationType.grow,
          isCloseButton:false,
          alertPadding:EdgeInsets.fromLTRB(4, 10, 4, 10),
          isOverlayTapDismiss: true,
          descStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          descTextAlign: TextAlign.start,
          animationDuration: Duration(milliseconds: 400),
          overlayColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(
              color: Colors.transparent,
            ),
          ),
          alertAlignment: Alignment.center,
        );
        Alert(
          padding:EdgeInsets.all(10),
          style: alertStyle,
          context:context,
          image: Image.asset("images/win.jpg"),
          buttons: [
            DialogButton(
              child: Text(
                "NEW GAME",
                style: TextStyle( fontSize: 43,
                  fontFamily: 'Bangers-Regular',
                  color: Colors.pink,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    ),
                  ],),
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyApp()));
              },
              color: Colors.limeAccent,
              radius: BorderRadius.circular(6.0),
              width: 250,
            ),
          ],
        ).show();
      });
    }
    if(tile.value==512){
      AssetsAudioPlayer.newPlayer().seek(Duration(milliseconds: 50));
      AssetsAudioPlayer.newPlayer().open(
        Audio("audios/win.mp3"),
        autoStart: true,
        //loopMode: LoopMode.single
      );
      _showAlert(context);
       return ConfettiView();
    }
if (tile.value == 0) {
      return Container();
    } else {
      return TileBox(
        left: (tile.column * width + state.tilePadding * (tile.column + 12)) +
            width / 2 * (1 - animationValue),
        top: tile.row * width +
            state.tilePadding * (tile.row + 12) +
            width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: tileColors.containsKey(tile.value)
            ? tileColors[tile.value]
            : Colors.purple[50],
        text: Text('${tile.value}', style: TextStyle(
          fontWeight:FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.blue.shade200,
              offset: Offset(5.0, 5.0),
            ),
            Shadow(
              color: Colors.red.shade200,
              blurRadius: 10.0,
              offset: Offset(-5.0, 5.0),
            ),
          ],
        ),),
      );
    }
  }
}
class TileBox extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  final Text text;
  const TileBox({
    Key key,
    this.left,
    this.top,
    this.size,
    this.color,
    this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: color,
        ),
        child: Center(
          child:text,
        ),
      ),
    );
  }
}

class ConfettiView extends StatefulWidget {
  @override
  _ConfettiViewState createState() => _ConfettiViewState();
}

class _ConfettiViewState extends State<ConfettiView> {
  ConfettiController _controller;

  @override
  void initState() {
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    _controller.play(); // <-- This causes the confetti to get stuck in one location and flash (when in a showModalBottomSheet)
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        decoration:BoxDecoration(
            color: Colors.transparent
        ),
        child:
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop:
              true, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
    );
  }
}
