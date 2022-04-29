import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:viddroid_flutter/connection/random_user_agent.dart';
import 'package:viddroid_flutter/constants.dart';
import 'package:viddroid_flutter/provider/provider.dart';
import 'package:viddroid_flutter/util/basic_util.dart';
import 'package:viddroid_flutter/util/passable_url.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

class MoviesCoAPI {
  /*
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

  RegExp sourceRegex = RegExp(r'
  (?<=sources:\[\{file:")[^"]+');
  */
  RegExp onClickRegex =
      RegExp(r"""onclick="download_video\('([^']+)','([^']+)','([^']+)'\)""", multiLine: true);

  RegExp directDownloadRegex =
      RegExp(r"""<a href="([^"]+)">Direct Download Link</a>""", multiLine: true);

  String formatTvRequest(final TVShow tvShow, final int season, final int episode) =>
      "${Constants.viddroidApiTV}/moviesco?id=0000&title=${tvShow.title!.dashes()}&season=$season&episode=$episode";

  String formatMovieRequest(final Movie movie) =>
      "${Constants.viddroidApiMovie}/moviesco?id=0000&title=${movie.title!.dashes()}";
}

class MoviesCo extends Provider with MoviesCoAPI {
  @override
  Future<PremadeRequestURL> requestMovieLink(Movie watchable) async {
    var response = await http.get(Uri.parse(formatMovieRequest(watchable)), headers: {
      'User-Agent': getRandomUserAgent(),
    });

    var responseJSON = jsonDecode(response.body);

    if (responseJSON["status_code"] == 200) {
      var payload = responseJSON["payload"];
      return PremadeRequestURL(payload["url"], headers: payload["init"]);
    } else {
      return Future.error('Request Movie link');
    }
  }

  @override
  Future<PremadeRequestURL> requestTVShowLink(TVShow watchable, int season, int episode) async {
    var response = await http.get(Uri.parse(formatTvRequest(watchable, season, episode)),
        headers: {'User-Agent': getRandomUserAgent()});

    var responseJSON = jsonDecode(response.body);

    if (responseJSON["status_code"] == 200) {
      var payload = responseJSON["payload"];
      return PremadeRequestURL(payload["url"], headers: payload["init"]);
    } else {
      return Future.error('Request Movie link');
    }
  }
}
