enum SongJanre { ALL, SONG, POPSONG, BALLAD, TROT, DANCE }
class MySongData {
  int? songID;
  String? songName;
  String? songGYNumber;
  String? songTJNumber;
  String? songJanre;
  String? songUtubeAddress;
  String? songETC;
  MySongData(
      {this.songID,
      this.songName,
      this.songGYNumber,
      this.songTJNumber,
      this.songJanre,
      this.songUtubeAddress,
      this.songETC});
  Map<String,dynamic> songToMap( ){
    return {
      "songID":songID,
      "songName":songName,
      "songGYNumber":songGYNumber,
      "songTJNumber":songTJNumber,
      "songJanre":songJanre,
      "songUtubeAddress":songUtubeAddress,
      "songETC":songETC
    };
  }
}
