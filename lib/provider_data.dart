import 'package:flutter/material.dart';
import 'package:my_karaoke/my_song_data.dart';

class ProviderData extends ChangeNotifier {
  List<MySongData>? allDatas = [];
  void add(MySongData value) {
    allDatas?.add(value);
    notifyListeners();
  }
}