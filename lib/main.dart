import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_karaoke/first_page.dart';
import 'package:my_karaoke/my_song_data.dart';
import 'package:my_karaoke/provider_data.dart';
import 'package:my_karaoke/second_page.dart';
import 'package:my_karaoke/third_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'utils.dart' as utils;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// ProviderData providerData = ProviderData();

class _MyAppState extends State<MyApp> {
  List<Widget>? _widgetOptions;
  int _selectedIndex = 0;
  SongJanre _janreSelectd = SongJanre.ALL;
  @override
  void initState() {
    super.initState();
    permissionCheck();
    getDocDirectory();
    _widgetOptions = makePage();
  }

  Future<void> getDocDirectory() async {
    Directory doc = await getApplicationDocumentsDirectory();
    utils.docsDir = doc;
  }

  List<Widget> makePage() => [FirstPage(), SecondPage(), ThirdPage()];
  @override
  Widget build(BuildContext context) {
    // Future<Database> database = initDatabase();
    return ChangeNotifierProvider(
      create: (_) => ProviderData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'my karaoke',
        home: Scaffold(
          appBar: AppBar(
            title: Text('나의 애창곡 관리'),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  print("Search..");
                },
                icon: Icon(Icons.search),
                tooltip: "곡명 검색",
              ),
              PopupMenuButton(onSelected: (SongJanre result) {
                setState(() {
                  _janreSelectd = result;
                  print(_janreSelectd);
                });
              }, itemBuilder: (context) {
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
            ],
          ),
          body: Center(
            child: _widgetOptions?.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            // backgroundColor: Colors.grey,
            // selectedItemColor: Colors.white,
            // unselectedItemColor: Colors.white.withOpacity(.60),
            selectedFontSize: 14,
            unselectedFontSize: 14,
            currentIndex: _selectedIndex, //현재 선택된 Index
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.storage),
                  backgroundColor:
                      _selectedIndex == 0 ? Colors.amber : Colors.grey,
                  label: "내부저장소"),
              BottomNavigationBarItem(
                icon: Icon(Icons.web_asset),
                label: "웹 데이터",
                backgroundColor:
                    _selectedIndex == 1 ? Colors.amber : Colors.grey,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_transit_filled_rounded),
                label: "Firebase",
                backgroundColor:
                    _selectedIndex == 2 ? Colors.amber : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void permissionCheck() async {
    List<Permission> permissions = Permission.values; //permission[15] storage
    permissions.forEach((element) async {
      // print(element.isDenied);
      if (element == Permission.storage) {
        element.status.then((value) async {
          if (value == PermissionStatus.denied) {
            // await element.request();
            await element.request();
            // var result=await element.request();
            // if(result.isDenied) print("denied");
            // else print("allow");
          }
        });
      }
    });
  }
}
