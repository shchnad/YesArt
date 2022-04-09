import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:art/artist_model.dart';
import 'package:art/service.dart';
import 'package:art/pages/canvas_large.dart';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true);
  } else {
    throw 'Could not launch $url';
  }
}

class CanvasCard extends StatefulWidget {
  CanvasCard({Key? key}) : super(key: key);

  @override
  _CanvasCardState createState() => _CanvasCardState();
}

class _CanvasCardState extends State<CanvasCard> {
  var _data;
  String urlWikiCanvas = '';
  String urlWikiArtist = '';

  List dataList = [];
  int dataIndex = 0;
  String language = '';
  List<A> artistUrl = [];

  @override
  Widget build(BuildContext context) {
    _data = ModalRoute.of(context)!.settings.arguments;
    dataIndex = _data['index'];
    dataList = _data['canvasList'];
    language = _data['language'];
    artistUrl = _data['artistUrl'];

    urlWikiCanvas = dataList[dataIndex].canvasUrl;
    urlWikiArtist = urlOfArtist(artistUrl, dataList[dataIndex].artist);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).accentColor,
          title: Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 15,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText('${dataList[dataIndex].style}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
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
                        GestureDetector(
                          onTap: () {launchURL(urlWikiArtist);},
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  AutoSizeText('${(dataList[dataIndex].artist)}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                      )),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CanvasLarge(
                                      text: '${dataList[dataIndex].id}',
                                  ),
                          ))
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.5,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/${dataList[dataIndex].id}.PNG'))),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {launchURL(urlWikiCanvas);},
                          child: Container(
                            child: Center(
                              child: AutoSizeText('${dataList[dataIndex].name}',
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
                                '${copyRightAddition(language, dataList[dataIndex].artist)}',
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 5,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ])
            ]),
            Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/canvasCard',
                            arguments: {
                              'language': language,
                              'index': dataIndex > 1 ? dataIndex - 1 : 0,
                              'canvasList': dataList,
                              'artistUrl': artistUrl,
                            });
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width) / 5,
                        child: LayoutBuilder(builder: (context, constraint) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.navigate_before,
                              size: 30,
                            ),
                          );
                        }),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, {});
                      },
                      child: Container(
                        child: LayoutBuilder(builder: (context, constraint) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              width: 20,
                              child: Icon(
                                Icons.clear,
                                size: 25,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/canvasCard',
                            arguments: {
                              'language': language,
                              'index': dataIndex < (dataList.length - 2)
                                  ? dataIndex + 1
                                  : dataList.length - 1,
                              'canvasList': dataList,
                              'artistUrl': artistUrl,
                            });
                      },
                      child: Container(
                        width: (MediaQuery.of(context).size.width) / 5,
                        child: LayoutBuilder(builder: (context, constraint) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Icon(
                              Icons.navigate_next,
                              size: 30,
                            ),
                          );
                        }),
                      ),
                    ),
                  ]),
            ),
          ]),
        ));
  }
}
