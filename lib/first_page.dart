import 'package:flutter/material.dart';
import 'package:my_karaoke/input_data.dart';
import 'package:my_karaoke/my_song_data.dart';
import 'package:my_karaoke/provider_data.dart';
import 'package:provider/provider.dart';
// import 'package:sqflite/sqflite.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);
  // const FirstPage({Key? key, this.db}) : super(key: key);
  // final Future<Database>? db;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var providerData;

  @override
  Widget build(BuildContext context) {
    providerData = Provider.of<ProviderData>(context, listen: true);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Row(
        //   children: [
        //     ListTile(
        //       title: Text("팝송"),
        //       leading: Radio(
        //         value: SongJanre.POPSONG,
        //         groupValue: _songJanre,
        //         onChanged: (SongJanre? val) {
        //           setState(() {
        //             _songJanre = val!;
        //           });
        //         },
        //       ),
        //     ),
        //     ListTile(
        //       title: Text("발라드"),
        //       leading: Radio(
        //         value: SongJanre.POPSONG,
        //         groupValue: _songJanre,
        //         onChanged: (SongJanre? val) {
        //           setState(() {
        //             _songJanre = val!;
        //           });
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(
          height: 10,
        ),
        Text("Total 데이터 수 : ${providerData.allDatas.length}"),
        Expanded(
          child: ListView.builder(
            itemCount: providerData.allDatas.length,
            itemBuilder: (BuildContext context, int index) {
              final MySongData item = providerData.allDatas[index];
              return Dismissible(
                key: Key(item.songID!.toString()),
                onDismissed: (DismissDirection direction) async {
                  providerData.allDatas.removeAt(index);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("${item.songID} dismissed"),
                    duration: Duration(seconds: 1),
                  ));
                  print("index : $index");
                  print("datas : ${providerData.allDatas}");
                  if (direction == DismissDirection.endToStart) {
                    // 삭제한 아이템을 스낵바로 출력
                  } else {}
                },
                background: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.yellow,
                      ),
                      Text("Delete",
                          style: TextStyle(color: Colors.amberAccent))
                    ],
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.yellow,
                      ),
                      Text("Delete",
                          style: TextStyle(color: Colors.amberAccent))
                    ],
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.access_alarm),
                  // trailing: Icon(Icons.delete),
                  title: Text("item ${item.songName}"),
                  subtitle: Text("${item.songID} subcribe"),
                  onTap: () {
                    print("$item,$index onTap : View");
                  },
                  onLongPress: () {
                    print("$item,$index onLong Press : Edit");
                  },
                ),
              );
            },
          ),
        ),
        FloatingActionButton.extended(
          onPressed: () async {
            // await Navigator.of(context)
            //     .push(MaterialPageRoute(
            //         builder: (context) => InputData(
            //               songID: providerData.allDatas!.length,
            //             )))
            //     .then((songItem) {
            //   providerData.allDatas?.add(songItem);
            //   setState(() {});
            // });
            MySongData songItem = MySongData();
            // songItem.songID = "Item : ${providerData.allDatas!.length + 1}";
            songItem.songID = providerData.allDatas!.length;
            songItem.songName = "사노라면";
            songItem.songGYNumber = "1111";
            songItem.songTJNumber = "2222";
            songItem.songUtubeAddress =
                "https://www.youtube.com/watch?v=Y9WifT8aN6o";

            providerData.allDatas?.add(songItem);
            // print(providerData);

            setState(() {});
          },
          icon: Icon(Icons.add),
          label: Text("추가"),
        ),
      ],
    );
  }
}
