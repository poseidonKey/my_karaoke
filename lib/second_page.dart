import 'package:flutter/material.dart';
import 'package:my_karaoke/db_worker.dart';
import 'package:my_karaoke/my_song_data.dart';
import 'package:my_karaoke/provider_data.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatelessWidget {
  var providerData;

  @override
  Widget build(BuildContext context) {
    providerData = Provider.of<ProviderData>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            children: [
              Consumer<ProviderData>(
                builder: (context, providerData, child) {
                  return Text('${providerData.allDatas!.length}');
                },
              ),
              ElevatedButton(
                onPressed: () {
                  MySongData songItem = MySongData();
                  // songItem.songID = "Item : ${providerData.allDatas!.length + 1}";
                  // songItem.songID = providerData.allDatas!.length;
                  songItem.songName = "사노라면";
                  songItem.songGYNumber = "1111";
                  songItem.songTJNumber = "2222";
                  songItem.songJanre = "pop";
                  songItem.songUtubeAddress =
                      "https://www.youtube.com/watch?v=Y9WifT8aN6o";
                  songItem.songETC = "ETC";
                  // print(songItem.songToMap());

                  DBWorker.db.create(songItem);

                  providerData.allDatas?.add(songItem);
                },
                child: Text("add"),
              ),
              ElevatedButton(
                onPressed: () async {
                  List lst = await DBWorker.db.getAll();
                  print(lst);
                },
                child: Text("load"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // MySongData currentItem = await showDialog(
                  //   context: context,
                  //   builder: (context) {
                  //     return AlertDialog(
                  //       title: Text("${item.songID}.${item.songName}"),
                  //       content: Text("${item.songJanre}를 삭제하겠습니까?"),
                  //       actions: [
                  //         ElevatedButton(
                  //           onPressed: () {
                  //             Navigator.of(context).pop(item);
                  //           },
                  //           child: Text("Yes"),
                  //         ),
                  //         ElevatedButton(
                  //           onPressed: () {
                  //             Navigator.of(context).pop();
                  //           },
                  //           child: Text("No"),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                  await DBWorker.db.delete(5);
                  List lst = await DBWorker.db.getAll();
                  print(lst);
                },
                child: Text("del"),
              ),
            ],
          ),
        ),
        FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("SQL"),
          onPressed: () async {
            List<dynamic> lst = await DBWorker.db.getAll();
            print(lst);
          },
        ),
      ],
    );
  }
}
