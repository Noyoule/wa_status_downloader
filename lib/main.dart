import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wa_status_downloader/views/status/status_main_screen.dart';

void main() {
  runApp(const MyApp());
}

Future<bool> requestPermissions() async {
  if (!await Permission.storage.status.isGranted) {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  if(!await Permission.manageExternalStorage.status.isGranted){
    var status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          primaryColor: Colors.deepPurple,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<bool>(
          future: requestPermissions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(child: Text('Une erreur est survenue',
                    textAlign: TextAlign.center,))),
              );
            } else {
              if (snapshot.data == true) {
                return const MyHomePage();
              } else {
                return const Scaffold(
                  body: Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Text("L'accès au stockage est requis pour utiliser cette application.",
                        textAlign: TextAlign.center,)),
                  ),
                );
              }
            }
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Liste des widgets qui vont représenter les différentes vues
  static const List<Widget> _widgetOptions = <Widget>[
    StatusMainScreen(),
    Text('Telechargement'),
    Text('Paramettre'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.download_rounded),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_done),
            label: 'Téléchargement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramettre',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
