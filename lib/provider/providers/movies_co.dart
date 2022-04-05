import 'dart:async';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:viddroid_flutter/connection/random_user_agent.dart';
import 'package:viddroid_flutter/provider/provider.dart';
import 'package:viddroid_flutter/streamer/streamers.dart';
import 'package:viddroid_flutter/util/basic_util.dart';
import 'package:viddroid_flutter/util/passable_url.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

class MoviesCoAPI {
  String baseURL = "https://www1.123movies.co";
  String movieEndpoint = "/movie/";
  String tvEndpoint = "/episode/";

  String decodingAPI = "https://gomo.to/decoding_v3.php";

  RegExp tcExpr = RegExp(r"var tc = '(.*)'");

  RegExp tokenRegex = RegExp(r'"_token": "(.*)"');
  RegExp functionRegex = RegExp(r"""function (.*? { (.*)+})""", multiLine: true);

  RegExp sliceRegex = RegExp(r'slice\((\d),(\d+)\)');
  RegExp rndNumRegex = RegExp(r'\+ "(\d+)"\+"(\d+)');

  //Pattern UNPACKER_PATTERN = Pattern.compile("eval\\(function\\(p,a,c,k,e,d\\)(.*)+\\)");

  RegExp sourceRegex = RegExp(r'(?<=sources:\[\{file:")[^"]+');

  RegExp onClickRegex =
      RegExp(r"""onclick="download_video\('([^']+)','([^']+)','([^']+)'\)""", multiLine: true);

  RegExp directDownloadRegex =
      RegExp(r"""<a href="([^"]+)">Direct Download Link</a>""", multiLine: true);

  String formatTvRequest(final TVShow tvShow, final int season, final int episode) =>
      "$baseURL$tvEndpoint${StringUtil.dashes(tvShow.title!)}-${season}x$episode/watching.html";

  String formatMovieRequest(final Movie movie) =>
      "$baseURL$movieEndpoint${StringUtil.dashes(movie.title!)}/watching.html";
}

class MoviesCo extends Provider with MoviesCoAPI {
  @override
  Future<PassableURL> requestMovieLink(Movie watchable) async {
    var response = await http.get(Uri.parse(formatMovieRequest(watchable)), headers: {
      'User-Agent': getRandomUserAgent(),
    });

    if (response.statusCode == 200) {
      var document = parse(response.body);
      Element iFrame = document.getElementsByTagName('iframe').first;

      return Streamers.gomo.streamer!.resolveStreamURL(iFrame.attributes['src']);
    } else {
      return Future.error('Request Movie link');
    }
  }

  @override
  Future<PassableURL> requestTVShowLink(TVShow watchable, int season, int episode) async {
    print("formatTvRequest(watchable, season, episode)");

    var response = await http.get(Uri.parse(formatTvRequest(watchable, season, episode)),
        headers: {'User-Agent': getRandomUserAgent()});

    if (response.statusCode == 200) {
      var document = parse(response.body);
      Element? iFrame = document.querySelector('.playerLock > iframe');
      if (iFrame == null) {
        return Future.error('iframe not found');
      } else {
        return Streamers.gomo.streamer!.resolveStreamURL(iFrame.attributes['src']);
      }
    } else {
      return Future.error('Request Tv Link');
    }
  }
}
