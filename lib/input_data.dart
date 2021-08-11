import 'package:flutter/material.dart';
import 'package:my_karaoke/my_song_data.dart';
import 'main.dart';

class InputData extends StatefulWidget {
  const InputData({Key? key, this.songID}) : super(key: key);
  final int? songID;

  @override
  _InputDataState createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  final TextEditingController _songNameEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    MySongData songItem = MySongData();
    return Scaffold(
      appBar: AppBar(
        title: Text("데이터 추가"),
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Row(children: [
            TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  // Hide soft keyboard.
                  FocusScope.of(context).requestFocus(FocusNode());
                }),
            Spacer(),
            TextButton(
                child: Text("Save"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ])),
      body: Column(
        children: [
          Container(
            child: ElevatedButton(
              onPressed: () {
                songItem.songID = widget.songID;
                songItem.songName = "사노라면";
                songItem.songGYNumber = "1111";
                songItem.songTJNumber = "2222";
                songItem.songUtubeAddress =
                    "https://www.youtube.com/watch?v=Y9WifT8aN6o";

                Navigator.of(context).pop(songItem);
              },
              child: Text("Add"),
            ),
          ),
          Form(
            child: Expanded(
              child: ListView(
                children: [
                  PopupMenuButton(onSelected: (SongJanre? result) {
                    songItem.songJanre = result.toString();
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
                  ListTile(
                      leading: Icon(Icons.description),
                      title: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: InputDecoration(hintText: "노래제목"),
                          controller: _songNameEditingController,
                          validator: (String? inValue) {
                            if (inValue?.length == 0) {
                              return "Please enter a description";
                            }
                            return null;
                          })),
                  ListTile(
                      leading: Icon(Icons.description),
                      title: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: InputDecoration(hintText: "금영 번호"),
                          controller: _songNameEditingController,
                          validator: (String? inValue) {
                            if (inValue?.length == 0) {
                              return "Please enter a description";
                            }
                            return null;
                          })),
                  ListTile(
                      leading: Icon(Icons.description),
                      title: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: InputDecoration(hintText: "태진 번호"),
                          controller: _songNameEditingController,
                          validator: (String? inValue) {
                            if (inValue?.length == 0) {
                              return "Please enter a description";
                            }
                            return null;
                          })),
                  ListTile(
                      leading: Icon(Icons.description),
                      title: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: InputDecoration(hintText: "연습사이트"),
                          controller: _songNameEditingController,
                          validator: (String? inValue) {
                            if (inValue?.length == 0) {
                              return "Please enter a description";
                            }
                            return null;
                          })),
                ],
              ),
            ),
            key: _formKey,
          ),
        ],
      ),
    );
  }
}
