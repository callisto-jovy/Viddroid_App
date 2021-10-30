import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

class Watchables {
  static final Watchables _instance = Watchables.ctor();

  factory Watchables() {
    return _instance;
  }

  Watchables.ctor();

  List<Watchable> watchables = <Watchable>[];

  SharedPreferences? _prefs;

  void init() async {
    _prefs = await SharedPreferences.getInstance();
    loadWatchables();
  }

  void loadWatchables() {
    String? jsonString = _prefs!.getString("watchables");
    if (jsonString != null) {
      var watchableJSONArray = jsonDecode(jsonString);
      for (int i = 0; i < watchableJSONArray.length; i++) {
        var watchableJSON = watchableJSONArray[i];
        watchables.add(newWatchable(watchableJSON));
      }
    }
  }

  Watchable newWatchable(var json) => json['tv'] ? TVShow(json) : Movie(json);

  bool contains(Watchable watchable) =>
      watchables.contains(watchable) || watchables.any((element) => element.id == watchable.id);

  bool containsID(int id) => watchables.any((element) => element.id == id);

  void saveWatchables() {
    _prefs!.setString("watchables", jsonEncode(watchables));
    _prefs!.commit();
  }

  void addWatchable(Watchable movie) {
    watchables.add(movie);
    saveWatchables();
  }

  void remove(Watchable watchable) {
    watchables.removeWhere((element) => element.id == watchable.id);
  }

  void removeID(int id) {
    watchables.removeWhere((element) => element.id == id);
  }
}
