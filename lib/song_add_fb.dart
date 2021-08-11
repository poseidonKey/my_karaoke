import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_karaoke/my_song_data_fb.dart';

import 'my_song_data.dart';

class SongAddFirebase extends StatefulWidget {
  final DatabaseReference reference;
  final int songNum;
  const SongAddFirebase(this.reference, this.songNum);

  @override
  _SongAddFirebaseState createState() => _SongAddFirebaseState();
}

class _SongAddFirebaseState extends State<SongAddFirebase> {
  TextEditingController? _songNameController;
  TextEditingController? _songGYNumberController;
  TextEditingController? _songTJNumberController;
  TextEditingController? _songJanreController;
  TextEditingController? _songUtubeAddressController;
  TextEditingController? _songETCController;
  String songItem="";
  @override
  void initState() {
    super.initState();
    _songNameController = TextEditingController();
    _songGYNumberController = TextEditingController();
    _songTJNumberController = TextEditingController();
    _songJanreController = TextEditingController();
    _songUtubeAddressController = TextEditingController();
    _songETCController = TextEditingController();
  }
@override
  void dispose() {
    _songNameController!.dispose();
    _songGYNumberController!.dispose();
    _songTJNumberController!.dispose();
    _songJanreController!.dispose();
    _songUtubeAddressController!.dispose();
    _songETCController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('곡 추가'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Song No : ${widget.songNum}",style: TextStyle(color: Colors.red),),
              TextField(
                controller: _songNameController,
                decoration: InputDecoration(
                    labelText: '제목', fillColor: Colors.blueAccent),
              ),
              TextField(
                controller: _songGYNumberController,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                decoration: InputDecoration(labelText: '금영번호'),
              ),
              TextField(
                controller: _songGYNumberController,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                decoration: InputDecoration(labelText: '태진번호'),
              ),
              PopupMenuButton(onSelected: (SongJanre? result) {
                    songItem = result.toString();
                  }, 
                  icon: Row(
                    children: [
                      Icon(Icons.handyman),
                      Text("노래 장르 선택")
                    ],
                  ),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<SongJanre>>[
                      const PopupMenuItem(
                        child: Text("Pop"),
                        value: SongJanre.POPSONG,
                      ),
                      const PopupMenuItem(
                        child: Text("발라드"),
                        value: SongJanre.BALLAD,
                      ),
                      const PopupMenuItem(
                        child: Text("트롯"),
                        value: SongJanre.TROT,
                      ),
                      const PopupMenuItem(
                        child: Text("전곡"),
                        value: SongJanre.ALL,
                      ),
                    ];
                  }),
              TextField(
                controller: _songUtubeAddressController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(labelText: '유튜브 주소'),
              ),    
              TextField(
                controller: _songETCController,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                decoration: InputDecoration(labelText: '특기사항'),
              ),
              TextButton(
                onPressed: () {
                  widget.reference
                      .push()
                      .set(MySongDataFirebase(
                              widget.songNum.toString(),
                              _songNameController!.text,
                              _songGYNumberController!.text,
                              _songTJNumberController!.text,
                              songItem,
                              _songUtubeAddressController!.text,
                              _songETCController!.text,
                              DateTime.now().toIso8601String())
                          .toJson())
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: Text('저장하기'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
