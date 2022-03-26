import 'package:flutter/material.dart';
import 'package:art/canvas_model.dart';
import 'package:art/artist_model.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:art/service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:art/pages/canvas_large.dart';

class Quizz extends StatefulWidget {

  final List<C> data;
  final String language;
  final String quizzType;
  final List <A> artistUrl;

  Quizz({Key? key,
    required this.data,
    required this.language,
    required this.quizzType,
    required this.artistUrl,
  }) : super(key: key);

  int tap = 0;
  int score = 0;

  @override
  _QuizzState createState() => _QuizzState();
}

class _QuizzState extends State<Quizz> {

  int randomIndex = 0;
  String randomQuestion1 = '';
  String randomQuestion2 = '';
  String randomQuestion3 = '';
  String randomQuestion4 = '';
  int randomNumber = 0;
  String canvas = '';
  String artist = '';
  var rng = Random();
  List randomList = [];
  List artistList = [];
  List styleList = [];
  List data = [];
  String randomItem = '';

  @override
  Widget build(BuildContext context) {

    artistList = getList(widget.data, 'artist');
    styleList = getList(widget.data, 'style');
    data = widget.quizzType == 'easy' ? styleList : artistList;

    randomIndex = rng.nextInt(widget.data.length);
    randomItem = widget.quizzType == 'easy' ? widget.data[randomIndex].style : widget.data[randomIndex].artist;

    randomList = getRandomItem(data, randomItem);
    randomQuestion1 = randomList[0];
    randomQuestion2 = randomList[1];
    randomQuestion3 = randomList[2];
    randomQuestion4 = randomList[3];

    randomNumber = rng.nextInt(4);

    setState(() {
      if (widget.quizzType == 'easy') {
        if (randomNumber == 0) randomQuestion1 = widget.data[randomIndex].style;
        if (randomNumber == 1) randomQuestion2 = widget.data[randomIndex].style;
        if (randomNumber == 2) randomQuestion3 = widget.data[randomIndex].style;
        if (randomNumber == 3) randomQuestion4 = widget.data[randomIndex].style;
      } else {
        if (randomNumber == 0) randomQuestion1 = widget.data[randomIndex].artist;
        if (randomNumber == 1) randomQuestion2 = widget.data[randomIndex].artist;
        if (randomNumber == 2) randomQuestion3 = widget.data[randomIndex].artist;
        if (randomNumber == 3) randomQuestion4 = widget.data[randomIndex].artist;
      }
    });

    void result(dataItem) {
      setState(() {
        widget.tap++;
        if (widget.quizzType == 'easy' && dataItem != widget.data[randomIndex].style ||
            widget.quizzType != 'easy' && dataItem != widget.data[randomIndex].artist)
        {
          AudioCache player = AudioCache();
          const alarmAudioPath = "sound/no.mp3";
          player.play(alarmAudioPath);

          Navigator.pushNamed(context, '/canvasCard', arguments: {
            'index': randomIndex,
            'canvasList': widget.data,
            'language': widget.language,
            'artistUrl': widget.artistUrl,
          });
        } else {
          // AudioCache player = new AudioCache();
          // const alarmAudioPath = "yes.mp3";
          // player.play(alarmAudioPath);
          widget.score++;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        }
      });
    }

    return Scaffold(
      // backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).accentColor,
          title: Container(
            height: MediaQuery.of(context).size.height / 15,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText('${widget.score} / ${widget.tap}',
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, {});
                  },
                  child: Container(
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Icon(
                        Icons.clear,
                        // size: constraint.biggest.height,
                        size: 30,
                        color: Colors.black,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Center(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                    widget.quizzType == 'easy' ? '${widget.data[randomIndex].artist}' : '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      // fontWeight: FontWeight.w700,
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CanvasLarge(
                                        text: '${widget.data[randomIndex].id}',
                                      ),
                                    ))
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 3,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/${widget.data[randomIndex].id}.PNG'))),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                child: Center(
                                  child: AutoSizeText('${widget.data[randomIndex].name}',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Center(
                                child: AutoSizeText(
                                    '${copyRightAddition(widget.language, widget.data[randomIndex].artist)}',
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 5,
                                      // fontWeight: FontWeight.w700,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 15,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                  child: AutoSizeText.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                        text: '${randomQuestion1}',
                                        style: TextStyle(color: widget.quizzType == 'easy' ? Theme.of(context).primaryColor : Colors.blue),
                                      ),
                                    ]),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                    maxLines: 2,
                                  ),
                                onPressed: () {
                                  result(randomQuestion1);
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 15,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                child: AutoSizeText.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: '${randomQuestion2}',
                                      style: TextStyle(color: widget.quizzType == 'easy' ? Theme.of(context).primaryColor : Colors.blue),
                                    ),
                                  ]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                  maxLines: 2,
                                ),
                                onPressed: () {
                                  result(randomQuestion2);
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 15,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                child: AutoSizeText.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: '${randomQuestion3}',
                                      style: TextStyle(color: widget.quizzType == 'easy' ? Theme.of(context).primaryColor : Colors.blue),
                                    ),
                                  ]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                  maxLines: 2,
                                ),
                                onPressed: () {
                                  result(randomQuestion3);
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 15,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: RaisedButton(
                                color: Theme.of(context).accentColor,
                                child: AutoSizeText.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                      text: '${randomQuestion4}',
                                      style: TextStyle(color: widget.quizzType == 'easy' ? Theme.of(context).primaryColor : Colors.blue),
                                    ),
                                  ]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                  maxLines: 2,
                                ),
                                onPressed: () {
                                  result(randomQuestion4);
                                }),
                          ),
                        ),
                      ]
                    )
                  ]))
            ])));
  }
}
