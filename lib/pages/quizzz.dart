import 'package:flutter/material.dart';
import 'package:art/canvas_model.dart';
import 'package:art/artist_model.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:art/service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:art/pages/canvas_large.dart';

class Quizzz extends StatefulWidget {

  final List<C> data;
  final String language;
  final String quizzType;
  final List <A> artistUrl;

  Quizzz({Key? key,
    required this.data,
    required this.language,
    required this.quizzType,
    required this.artistUrl,
  }) : super(key: key);

  int tap = 0;
  int score = 0;

  @override
  _QuizzzState createState() => _QuizzzState();
}

class _QuizzzState extends State<Quizzz> {

  int randomIndex = 0;
  int randomQuestionIndex1= 0;
  int randomQuestionIndex2= 0;
  int randomQuestionIndex3 = 0;
  int randomQuestionIndex4= 0;
  int randomNumber = 0;
  String canvas = '';
  String artist = '';
  var rng = Random();
  List randomList = [];

  @override
  Widget build(BuildContext context) {


    randomIndex = rng.nextInt(widget.data.length);

    randomList = randomFour(widget.data, randomIndex);

    randomQuestionIndex1 = randomList[0];
    randomQuestionIndex2 = randomList[1];
    randomQuestionIndex3 = randomList[2];
    randomQuestionIndex4 = randomList[3];


    randomNumber = rng.nextInt(4);

    setState(() {
      if (randomNumber == 0) randomQuestionIndex1 = randomIndex;
      if (randomNumber == 1) randomQuestionIndex2 = randomIndex;
      if (randomNumber == 2) randomQuestionIndex3 = randomIndex;
      if (randomNumber == 3) randomQuestionIndex4 = randomIndex;
    });

    artist = widget.quizzType == 'easy' ? widget.data[randomIndex].artist : '';
    canvas =  '?';

    String spaceName (data) {
      return ' "'+ data +'"';
    }

    void result(ind) {
      setState(() {
        widget.tap++;
        if (ind != randomIndex) {

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
          widget.score++;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        }
      });
    }

    return Scaffold(
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
                        size: 20,
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
                                    '${artist}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
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
                            Container(
                              child: Center(
                                child: AutoSizeText(
                                    '${copyRightAddition(widget.language, widget.data[randomIndex].artist)}',
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 5,
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
                      height: 10,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
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
                                        text: '${widget.quizzType == 'easy' ? '' : widget.data[randomQuestionIndex1].artist}',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      TextSpan(
                                        text: '${widget.quizzType == 'easy' ? widget.data[randomQuestionIndex1].name : spaceName(widget.data[randomQuestionIndex1].name)}',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ]),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                    maxLines: 2,
                                  ),
                                  onPressed: () {
                                    result(randomQuestionIndex1);
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
                                        text: '${widget.quizzType == 'easy' ? '' : widget.data[randomQuestionIndex2].artist}',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      TextSpan(
                                        text: '${widget.quizzType == 'easy' ? widget.data[randomQuestionIndex2].name : spaceName(widget.data[randomQuestionIndex2].name)}',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ]),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                    maxLines: 2,
                                  ),
                                  onPressed: () {
                                    result(randomQuestionIndex2);
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
                                        text: '${widget.quizzType == 'easy' ? '' : widget.data[randomQuestionIndex3].artist}',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      TextSpan(
                                        text: '${widget.quizzType == 'easy' ? widget.data[randomQuestionIndex3].name : spaceName(widget.data[randomQuestionIndex3].name)}',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ]),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                    maxLines: 2,
                                  ),
                                  onPressed: () {
                                    result(randomQuestionIndex3);
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
                                        text: '${widget.quizzType == 'easy' ? '' : widget.data[randomQuestionIndex4].artist}',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      TextSpan(
                                        text: '${widget.quizzType == 'easy' ? widget.data[randomQuestionIndex4].name : spaceName(widget.data[randomQuestionIndex4].name)}',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ]),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                    maxLines: 2,
                                  ),
                                  onPressed: () {
                                    result(randomQuestionIndex4);
                                  }),
                            ),
                          ),
                        ]
                    )
                  ]))
            ])));
  }
}
