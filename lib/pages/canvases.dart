import 'package:flutter/material.dart';
import 'package:art/canvas_model.dart';
import 'package:art/canvas_line.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:art/artist_model.dart';
import 'package:art/service.dart';

class Canvases extends StatefulWidget {
  final List <C> data;
  final String language;
  final String allStylesName;
  final String allArtistsName;
  final String total;
  final List <String> stylesList;
  final List <String> artistsList;
  final List <A> artistUrl;
  Canvases({
    required this.data,
    required this.language,
    required this.allStylesName,
    required this.allArtistsName,
    required this.total,
    required this.stylesList,
    required this.artistsList,
    required this.artistUrl,
  });

  @override
  _CanvasesState createState() => _CanvasesState();
}

class _CanvasesState extends State<Canvases> {
  List data = [];
  int totalCanvases = 0;
  var style;
  var artist;
  String parametrOfFilter = 'string';


  @override
  Widget build(BuildContext context) {

     if (style == null && artist == null) {
       style = widget.allStylesName;
       artist = widget.allArtistsName;
       data = widget.data;
     } else {
       data = filterData(widget.data, style, artist, widget.allStylesName, widget.allArtistsName, parametrOfFilter);
       }

     print('total styles: ${widget.stylesList.length}');
     print('total styles: ${widget.stylesList}');
     print('total artists: ${widget.artistsList.length}');
     print('total artists: ${widget.artistsList}');

      data.sort((a, b) => a.artist.compareTo(b.artist));

       return Scaffold(
         // backgroundColor: Colors.black,
           appBar: AppBar(
             backgroundColor: Theme.of(context).accentColor,
             automaticallyImplyLeading: false,
             title: Container(
               height: MediaQuery.of(context).size.height / 15,
               width: MediaQuery.of(context).size.width,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   GestureDetector(
                     onDoubleTap: () {
                       setState(() {
                         artist = null;
                         style = null;
                       });
                     },
                     child: DropdownButtonHideUnderline(
                       child: DropdownButton(
                         value: artist,
                         hint: Text(artist),
                         items: widget.artistsList.map((String val) {
                           return DropdownMenuItem<String>(
                             value: val,
                             child: Text(val),
                           );
                         }).toList(),
                         onChanged: (newValue) {
                           setState(() {
                             if (newValue == widget.allArtistsName) {artist = null; style = null;}
                             else {
                             artist = newValue;
                             style = widget.allStylesName;
                             parametrOfFilter = 'byArtist';
                             };
                           });
                         },
                         dropdownColor: Theme.of(context).accentColor,
                         style: TextStyle(color: Colors.black, fontSize: 20),
                       ),
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
                           size: 25,
                           color: Colors.black,
                         );
                       }),
                     ),
                   ),
                 ],
               ),
             ),
           ),
           bottomNavigationBar: BottomAppBar(
             color: Colors.white,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 GestureDetector(
                   onDoubleTap: () {
                     setState(() {
                       artist = null;
                       style = null;
                     });
                   },
                   child: DropdownButtonHideUnderline(
                     child: Container(
                       padding: EdgeInsets.only(left: 20.0),
                       child: DropdownButton(
                         value: style,
                         hint: Text(style),
                         items: widget.stylesList.map((String val) {
                           return DropdownMenuItem<String>(
                             value: val,
                             child: Text(val),
                           );
                         }).toList(),
                         onChanged: (newValue) {
                           setState(() {
                             if (newValue == widget.allStylesName) {artist = null; style = null;}
                             else {
                               style = newValue;
                               parametrOfFilter = 'byStyle';
                               artist = widget.allArtistsName;
                             };
                           });
                         },
                         // dropdownColor: Theme.of(context).accentColor,
                         dropdownColor: Theme.of(context).accentColor,
                         style: TextStyle(color: Colors.black, fontSize: 20),
                       ),
                     ),
                   ),
                 ),
                 Container(
                   padding: EdgeInsets.only(right: 10.0),
                   child: AutoSizeText(
                     '${widget.total} ${data.length}',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       color: Theme.of(context).primaryColor,
                       fontSize: 20,
                     ),
                   ),
                 ),
               ],
             ),

           ),
           body: SafeArea(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Container(
                 child: ListView.builder(
                     itemCount: data.length,
                     itemBuilder: (context, index) {
                       return CanvasLine(
                           data[index],
                               () {Navigator.pushNamed(context, '/canvasCard', arguments: {
                             'index': index,
                             'canvasList': data,
                             'language': widget.language,
                             'artistUrl': widget.artistUrl,
                           });
                           });
                     }),
               ),
             ),
           ));
     }
  }


