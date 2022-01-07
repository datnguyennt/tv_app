import 'package:hive/hive.dart';

part 'tabbar.g.dart';

@HiveType(typeId: 0, adapterName: 'TabbarWebAdapter')
class TabbarWeb extends HiveObject {
  @HiveField(0)
  String tabUrl;

  TabbarWeb({required this.tabUrl});
}
