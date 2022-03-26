import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:art/canvas_model.dart';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true);
  } else {
    throw 'Could not launch $url';
  }
}

String urlOfArtist(artistList, artist) {
  String url = '';
  artistList.forEach((element) {
    if (element.artistName == artist)
      url = element.artistUrl;
    else
      print('url = null');
  });
  return url;
}

String copyRightAddition(language, artist) {
  String text = '';
  List copyRightArtistEn = [
    'This artwork may be protected by copyright. It is posted here in accordance with fair use principles.',
    'Salvador Dali',
    'René Magritte',
    'Joan Miró',
    'Marcel Duchamp',
    'Edvard Munch',
    'Frida Kahlo',
    'Jackson Pollock',
    'Max Ernst',
    'Marc Chagall',
    'Georges Braque'
  ];
  List copyRightArtistRu = [
    'Это произведение может быть защищено авторским правом. Оно представлено здесь в соответствии с принципами добросовестного использования.',
    'Сальвадор Дали',
    'Рене Магритт',
    'Жоан Миро',
    'Марсель Дюшан',
    'Фрида Кало',
    'Джексон Поллок',
    'Макс Эрнст',
    'Марк Шагал',
    'Жорж Брак'
  ];
  List copyRightArtist =
      (language == 'en') ? copyRightArtistEn : copyRightArtistRu;
  if (copyRightArtist.contains(artist)) text = copyRightArtist[0];
  return text;
}

getSize (imagePath) async {
  var img = await rootBundle.load(imagePath);
  var decodedImage = await decodeImageFromList(img.buffer.asUint8List());
  int imgWidth = decodedImage.width;
  int imgHeight = decodedImage.height;
  print('size: ${imgWidth} / ${imgHeight}, condition: ${imgWidth / imgHeight}');
  print('image: ${imagePath}');
  return imgWidth / imgHeight;
}

randomFour <List> (data, randomIndex){
  int randomQuestionIndex1 = 0;
  int randomQuestionIndex2 = 0;
  int randomQuestionIndex3 = 0;
  int randomQuestionIndex4 = 0;
  var rng = Random();

  do {
    randomQuestionIndex1 = rng.nextInt(data.length);
  } while (randomQuestionIndex1 == randomIndex);


  do {
    do {
      randomQuestionIndex2 = rng.nextInt(data.length);
    } while (randomQuestionIndex2 == randomQuestionIndex1);
  } while (randomQuestionIndex2 == randomIndex);


  do {
    do {
      do {
        randomQuestionIndex3 = rng.nextInt(data.length);
      } while (randomQuestionIndex3 == randomQuestionIndex2);
    } while (randomQuestionIndex3 == randomQuestionIndex1);
  } while (randomQuestionIndex3 == randomIndex);

  do {
    do {
      do {
        do {
          randomQuestionIndex4 = rng.nextInt(data.length);
        } while (randomQuestionIndex4 == randomQuestionIndex3);
      } while (randomQuestionIndex4 == randomQuestionIndex2);
    } while (randomQuestionIndex4 == randomQuestionIndex1);
  } while (randomQuestionIndex4 == randomIndex);

  print('random numbers: ${randomQuestionIndex1} , ${randomQuestionIndex2} , ${randomQuestionIndex3} , ${randomQuestionIndex4}');
  return [randomQuestionIndex1, randomQuestionIndex2, randomQuestionIndex3, randomQuestionIndex4];
}

getList(data, text) {
  List artistList = [];
  List styleList = [];
  data.forEach((element) {
    artistList.add(element.artist);
    styleList.add(element.style);

  });
  if (text == 'artist') return artistList.toSet().toList();
  else return styleList.toSet().toList();;
}

getRandomItem <List> (dataList, text){
  String randomQuestion1 = '';
  String randomQuestion2 = '';
  String randomQuestion3 = '';
  String randomQuestion4 = '';
  var rng = Random();

  do {
    randomQuestion1 = dataList[rng.nextInt(dataList.length)];
  } while (randomQuestion1 == text);


  do {
    do {
      randomQuestion2 = dataList[rng.nextInt(dataList.length)];
    } while (randomQuestion2 == randomQuestion1);
  } while (randomQuestion2 == text);


  do {
    do {
      do {
        randomQuestion3 = dataList[rng.nextInt(dataList.length)];
      } while (randomQuestion3 == randomQuestion2);
    } while (randomQuestion3 == randomQuestion1);
  } while (randomQuestion3 == text);

  do {
    do {
      do {
        do {
          randomQuestion4 = dataList[rng.nextInt(dataList.length)];
        } while (randomQuestion4 == randomQuestion3);
      } while (randomQuestion4 == randomQuestion2);
    } while (randomQuestion4 == randomQuestion1);
  } while (randomQuestion4 == text);

  print('random numbers: ${randomQuestion1} , ${randomQuestion2} , ${randomQuestion3} , ${randomQuestion4}');
  return [randomQuestion1, randomQuestion2, randomQuestion3, randomQuestion4];
}

List<String> createStylesList(data, allStylesName){
  List <String> list = [];
  data.forEach((element) {
    if (!list.contains(element.style)) {
      list.add(element.style);
    }
  });
  list = (list..sort());
  list.add(allStylesName);
  return list;
}

List<String> createArtistsList(data, allArtistsName){
  List <String> list = [];
  data.forEach((element) {
    if (!list.contains(element.artist)) {
      list.add(element.artist);
    }
  });
  list = (list..sort());
  list.add(allArtistsName);
  return list;
}

filterData(data, style, artist, styleword, artistword, parametrOfFilter) {
  List filteredData = [];
  data.forEach((element) {
    if (parametrOfFilter == 'byStyle') {
      if (element.style == style || element.style == styleword) {
        filteredData.add(element);
      }
    } else {
      if (element.artist == artist || element.artist == artistword) {
        filteredData.add(element);
      }
    }
  });
  return filteredData;
}