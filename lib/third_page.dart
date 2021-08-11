import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_karaoke/my_song_data_fb.dart';
import 'package:my_karaoke/song_add_fb.dart';
import 'package:my_karaoke/song_view_edit_fb.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://karaoke-b35b0-default-rtdb.firebaseio.com/';
  List<MySongDataFirebase> songs = [];
  @override
  void initState() {
    super.initState();
    // FirebaseAdMob.instance.initialize(appId: '### 애드몹 앱 ID ###');
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database?.reference().child('songs');

    reference?.onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        songs.add(MySongDataFirebase.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: songs.length == 0
              ? CircularProgressIndicator()
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Card(
                      child: GridTile(
                        child: Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: SizedBox(
                            child: GestureDetector(
                              onTap: () async {
                                MySongDataFirebase? song =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute<MySongDataFirebase>(
                                    builder: (BuildContext context) =>
                                        SongViewEditFirebase(
                                            reference!, songs[index]),
                                  ),
                                );
                                if (song != null) {
                                  setState(() {
                                    songs[index].songName = song.songName;
                                    songs[index].songJanre = song.songJanre;
                                  });
                                }
                              },
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(songs[index].songName),
                                        content: Text('삭제하시겠습니까?'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                reference!
                                                    .child(songs[index].key!)
                                                    .remove()
                                                    .then((_) {
                                                  setState(() {
                                                    songs.removeAt(index);
                                                    Navigator.of(context).pop();
                                                  });
                                                });
                                              },
                                              child: Text('예')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('아니요')),
                                        ],
                                      );
                                    });
                              },
                              child: Text(songs[index].songName),
                            ),
                          ),
                        ),
                        header: Text(songs[index].songJanre),
                        footer: Text(songs[index].createTime.substring(0, 10)),
                      ),
                    );
                  },
                  itemCount: songs.length,
                ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SongAddFirebase(reference!,songs.length+1)));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
