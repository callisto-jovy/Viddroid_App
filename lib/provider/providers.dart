import 'package:viddroid_flutter/provider/provider.dart';
import 'package:viddroid_flutter/provider/providers/movies_co.dart';
import 'package:viddroid_flutter/provider/providers/video_vak_com.dart';

enum Providers { moviesCo, moviesTechHub, videovakCom }

extension ProvidersExtension on Providers {
  String get name {
    switch (this) {
      case Providers.moviesCo:
        return 'Movies.Co';
      case Providers.moviesTechHub:
        return 'Moviestech.hub';
      case Providers.videovakCom:
        return 'Videovak.com';
      default:
        return 'null';
    }
  }

  Provider get provider {
    switch (this) {
      case Providers.moviesCo:
        return MoviesCo();

      case Providers.moviesTechHub:
        // TODO: Handle this case.
        break;
      case Providers.videovakCom:
        return VideoVakCom();
    }
    return MoviesCo();
  }
}
