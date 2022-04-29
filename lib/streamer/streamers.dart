import 'package:viddroid_flutter/streamer/streamer.dart';
import 'package:viddroid_flutter/streamer/streamers/stream_sb.dart';
import 'package:viddroid_flutter/streamer/streamers/vid_cloud.dart';

enum Streamers { vidCloud, streamSB }

extension StreamersExtension on Streamers {
  String get name {
    switch (this) {
      case Streamers.vidCloud:
        return 'vidcloud';
      case Streamers.streamSB:
        return 'streamSB';
      default:
        return 'null';
    }
  }

  Streamer? get streamer {
    switch (this) {
      case Streamers.vidCloud:
        return VidCloud();
      case Streamers.streamSB:
        return StreamSB();
    }
  }
}
