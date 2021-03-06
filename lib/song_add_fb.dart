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
  String _viewPopData = "노래 장르 선택(탭 후 Popup 창에서 선택)";

  void _submit() async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    if (_fKey.currentState!.validate()) {
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
      _fKey.currentState!.save();
      Navigator.of(context).pop();
      // print("result : $result}");
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("곡 제목은 반드시 입력해야 합니다."),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  focusNode!.requestFocus();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
                      prefixIcon: Icon(Icons.title),
                    ),
                    // onSaved: (val) => _email = val,
                    autofocus: true,
                    focusNode: focusNode,
                    validator: (String? val) {
                      if (val!.isEmpty) {
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
                        switch (result) {
                          case SongJanre.BALLAD:
                            _viewPopData = "곡 유형 : 발라드";
                            break;
                          case SongJanre.POPSONG:
                            _viewPopData = "곡 유형 : 팝송";
                            break;
                          case SongJanre.DANCE:
                            _viewPopData = "곡 유형 : 댄스";
                            break;
                          case SongJanre.SONG:
                            _viewPopData = "곡 유형 : 가요";
                            break;
                          case SongJanre.TROT:
                            _viewPopData = "곡 유형 : 트롯트";
                            break;
                          default:_viewPopData = "곡 유형 구분 없음";
                        }
                        FocusScope.of(context).requestFocus(focusNode);
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Icon(Icons.handyman),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "$_viewPopData",
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
                            child: Text("가요"),
                            value: SongJanre.SONG,
                          ),
                          const PopupMenuItem(
                            child: Text("댄스"),
                            value: SongJanre.DANCE,
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
