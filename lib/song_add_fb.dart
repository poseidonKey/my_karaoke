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
  final _fKey = GlobalKey<FormState>();
  FocusNode? focusNode; 
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController? _songNameController;
  TextEditingController? _songGYNumberController;
  TextEditingController? _songTJNumberController;
  TextEditingController? _songJanreController;
  TextEditingController? _songUtubeAddressController;
  TextEditingController? _songETCController;
  String songItem = "";

  void _submit() async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    if (_fKey.currentState!.validate())  {
      var result = await showDialog<bool?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Are you sure you want to Karaoke data."),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text("Save"),
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
                    Navigator.of(context).pop(true);
                  });
                },
              ),
            ],
          );
        },
      );
      print("result : $result}");
    }
    _fKey.currentState!.save();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(); 
    _songNameController = TextEditingController();
    _songGYNumberController = TextEditingController();
    _songTJNumberController = TextEditingController();
    _songJanreController = TextEditingController();
    _songUtubeAddressController = TextEditingController();
    _songETCController = TextEditingController();
  }

  @override
  void dispose() {
    focusNode!.dispose(); 
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
      body: Form(
        key: _fKey,
        autovalidateMode: autovalidateMode,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    "Song No : ${widget.songNum}",
                    style: TextStyle(color: Colors.red),
                  ),
                  TextFormField(
                    controller: _songNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: '제목',
                      prefixIcon: Icon(Icons.email),
                    ),
                    // onSaved: (val) => _email = val,
                    validator: (String? val) {
                      if (val!.length == 0) {
                        return '필수 사항 입니다.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _songGYNumberController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    decoration: InputDecoration(labelText: '금영노래방 번호'),
                  ),
                  TextField(
                    controller: _songGYNumberController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    decoration: InputDecoration(labelText: '태진노래방 번호'),
                  ),
                  PopupMenuButton(
                      onSelected: (SongJanre? result) {
                        songItem = result.toString();
                        FocusScope.of(context).requestFocus(focusNode); 
                      },
                      
                      child: Row(
                        children: [
                          Icon(Icons.handyman),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "노래 장르 선택(탭 후 Popup 창에서 선택)",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
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
                    onPressed: _submit,
                    child: Text('저장하기'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
