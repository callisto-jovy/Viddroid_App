import 'package:viddroid_flutter/streamer/streamer.dart';
import 'package:viddroid_flutter/streamer/streamers/gomo.dart';

enum Streamers { GOMO }

extension StreamersExtension on Streamers {
  String get name {
    switch (this) {
      case Streamers.GOMO:
        return 'gomo';
      default:
        return 'null';
    }
  }

  Streamer? get streamer {
    switch (this) {
      case Streamers.GOMO:
        return Gomo();
    }
  }
}
