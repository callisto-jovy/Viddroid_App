import 'dart:io';

import 'package:flutter/material.dart';
import 'package:viddroid_flutter/pages/search_page.dart';
import 'package:viddroid_flutter/util/basic_util.dart';
import 'package:viddroid_flutter/watchable/watchables.dart';
import 'package:viddroid_flutter/widgets/watchable_list.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Watchables().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Viddroid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Watchables'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.favorite)),
            Tab(icon: Icon(Icons.bookmark)),
            Tab(icon: Icon(Icons.search)),
          ]),
        ),
        body: const TabBarView(
          children: [
            WatchableList(),
            Center(child: Text('Bookmark page')),
            SearchPage(),
          ],
        ),
      ),
    );
  }
}
