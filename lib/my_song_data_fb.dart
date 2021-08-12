import 'package:firebase_database/firebase_database.dart';

class MySongDataFirebase {
  String? key;
  String songID;
  String songName;
  String songGYNumber;
  String songTJNumber;
  String songJanre;
  String songUtubeAddress;
  String songETC;
  String createTime;
  MySongDataFirebase(
      this.songID,
      this.songName,
      this.songGYNumber,
      this.songTJNumber,
      this.songJanre,
      this.songUtubeAddress,
      this.songETC,
      this.createTime);
  MySongDataFirebase.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        songID = snapshot.value["songID"],
        songName = snapshot.value["songName"],
        songGYNumber = snapshot.value["songGYNumber"],
        songTJNumber = snapshot.value["songTJNumber"],
        songJanre = snapshot.value["songJanre"],
        songUtubeAddress = snapshot.value["songUtubeAddress"],
        songETC = snapshot.value["songETC"],
        createTime = snapshot.value["createTime"];
  Map<String, dynamic> toJson() {
    return {
      "songID": songID,
      "songName": songName, 
      "songGYNumber": songGYNumber,
      "songTJNumber": songTJNumber,
      "songJanre": songJanre,
      "songUtubeAddress": songUtubeAddress,
      "songETC": songETC,
      "createTime": createTime
    };
  }
}
