import 'package:flutter/material.dart';
import 'package:art/service.dart';

class CanvasLarge extends StatelessWidget {
  final String text;

  CanvasLarge({required this.text});

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: getSize('assets/images/${text}.PNG'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data > 1
              ? GestureDetector(
                  onTap: () => {Navigator.of(context).pop()},
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/${text}.PNG'))),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => {Navigator.of(context).pop()},
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/${text}.PNG'))),
                  ),
                );
        } else {
          return new Text('Loading...');
        }
      },
    );
  }
}
