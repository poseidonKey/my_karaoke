import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_karaoke/my_song_data_fb.dart';

class SongViewEditFirebase extends StatefulWidget {
  const SongViewEditFirebase(this.reference, this.song);
  final DatabaseReference reference;
  final MySongDataFirebase song;
  @override
  _SongViewEditFirebaseState createState() => _SongViewEditFirebaseState();
}

class _SongViewEditFirebaseState extends State<SongViewEditFirebase> {
  TextEditingController? titleController;
  TextEditingController? contentController;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.song.songName);
    contentController = TextEditingController(text: widget.song.songJanre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("노래번호 : ${widget.song.songID}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: '제목', fillColor: Colors.blueAccent),
              ),
              Expanded(
                  child: TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: 100,
                decoration: InputDecoration(labelText: '내용'),
              )),
              TextButton(
                onPressed: () {
                  MySongDataFirebase song = MySongDataFirebase(
                      "2",
                      "고맙소",
                      "11111",
                      "22222",
                      "트롯트",
                      "https://www.youtube.com/watch?v=Y9WifT8aN6o",
                      "",
                      // titleController!.value.text,
                      // contentController!.value.text,
                      widget.song.createTime);
                  widget.reference
                      .child(widget.song.key!)
                      .set(song.toJson())
                      .then((_) {
                    Navigator.of(context).pop(song);
                  });
                },
                child: Text('수정하기'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
