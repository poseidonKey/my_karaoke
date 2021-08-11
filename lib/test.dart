import 'package:flutter/material.dart';
import 'package:my_karaoke/first_page.dart';
import 'package:my_karaoke/provider_data.dart';
import 'package:my_karaoke/second_page.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:path/path.dart';
import 'package:provider/provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// ProviderData providerData = ProviderData();

class _MyAppState extends State<MyApp> {
  List<Widget>? _widgetOptions;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    permissionCheck();
    _widgetOptions = makePage();
  }

  List<Widget> makePage() => [FirstPage(), SecondPage()];
  @override
  Widget build(BuildContext context) {
    // Future<Database> database = initDatabase();
    return ChangeNotifierProvider(
      create: (_) => ProviderData(),
      child: MaterialApp(
        title: 'my karaoke',
        home: Scaffold(
          appBar: AppBar(
            title: Text('나의 애창곡 관리'),
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
                  icon: Icon(Icons.ac_unit),
                  backgroundColor:
                      _selectedIndex == 0 ? Colors.amber : Colors.grey,
                  label: "내부저장소"),
              BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit_sharp),
                label: "웹 데이터",
                backgroundColor:
                    _selectedIndex == 1 ? Colors.amber : Colors.grey,
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
