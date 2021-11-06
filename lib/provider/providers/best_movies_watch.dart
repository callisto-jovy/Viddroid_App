import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:viddroid_flutter/connection/random_user_agent.dart';
import 'package:viddroid_flutter/provider/provider.dart';
import 'package:viddroid_flutter/streamer/streamers.dart';
import 'package:viddroid_flutter/util/basic_util.dart';
import 'package:viddroid_flutter/util/passable_url.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

class BestMoviesWatchAPI {
  String baseURL = 'https://best-movies.watch';

  String formatMovieRequest(final String title, final int id) =>
      '$baseURL/movie/$id-${StringUtil.dashes(title)}';
}

class BestMoviesWatch extends Provider with BestMoviesWatchAPI {
  @override
  Future<PassableURL> requestMovieLink(Movie watchable) async {
    if (watchable.title != null) {
      var resp = await http.get(Uri.parse(formatMovieRequest(watchable.title!, watchable.id)),
          headers: {'user-agent': getRandomUserAgent()});

      if (resp.statusCode == 200) {
        var document = parse(resp.body);

        Element? iFrame = document.getElementById('frame');
        if (iFrame == null) {
          return Future.error('iFrame is null');
        }
        return Streamers.vidCloud.streamer!.resolveStreamURL('https:${iFrame.attributes['src']}');
      } else {
        return Future.error('Bestmovies.watch responded with SC ${resp.statusCode}');
      }
    } else {
      return Future.error("Movie's title empty");
    }
  }

  @override
  Future<PassableURL> requestTVShowLink(TVShow watchable, int season, int episode) {
    return Future.error('bestmovies.watch only supplied movies');
  }
}
