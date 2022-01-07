import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:tv_app/models/tabbar.dart';
import 'webview/webview.dart';
import 'webview/webview_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(TabbarWebAdapter());
  //Hive.registerAdapter<TabbarWeb>(TabbarWebAdapter());

  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: WebviewBinding(),
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => WebviewPage(),
            binding: WebviewBinding(),
          ),
        ],
        home: WebviewPage(),
      ),
    );
  }
}
