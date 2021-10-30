import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:viddroid_flutter/connection/random_user_agent.dart';
import 'package:viddroid_flutter/themoviedb/themoviedb.dart' as the_movie_db;
import 'package:viddroid_flutter/watchable/episode.dart';
import 'package:viddroid_flutter/watchable/season.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

class TheMovieDBSearchMovieTask {
  Future<List> call(String query) async {
    if (query.isEmpty) return List.empty();

    var resp = await http.get(
        Uri.parse(the_movie_db.formatEndpointSearchRequest(
            the_movie_db.TheMovieDBAPIEndpoints.searchMovie, query)),
        headers: {"User-Agent": getRandomUserAgent()}).then((value) => jsonDecode(value.body));
    return resp['results'];
  }
}

class TheMovieDBSearchTVTask {
  Future<List> call(String query) async {
    if (query.isEmpty) return List.empty();

    var resp = await http.get(
        Uri.parse(the_movie_db.formatEndpointSearchRequest(
            the_movie_db.TheMovieDBAPIEndpoints.searchTV, query)),
        headers: {"User-Agent": getRandomUserAgent()}).then((value) => jsonDecode(value.body));

    return resp['results'];
  }
}

class TheMovieDBTVDetailsRequestTask {
  void call(TVShow tvShow) async {
    String endpoint = the_movie_db.formatRequest(
        the_movie_db.TheMovieDBAPIEndpoints.tvDetails, tvShow.id.toString());
    var resp = await http.get(Uri.parse(endpoint),
        headers: {"User-Agent": getRandomUserAgent()}).then((value) => jsonDecode(value.body));

    var seasons = resp['seasons'];

    for (int i = 0; i < seasons.length; i++) {
      tvShow.addSeason(-1, Season(i));

      String seasonEndpoint = the_movie_db.formatRequest(
          the_movie_db.TheMovieDBAPIEndpoints.tvDetails, tvShow.id.toString() + "/season/$i");

      var seasonResp = await http.get(Uri.parse(seasonEndpoint),
          headers: {"User-Agent": getRandomUserAgent()}).then((value) => jsonDecode(value.body));

      var seasonEpisodes = seasonResp['episodes'];

      for (int j = 0; j < seasonEpisodes.length; j++) {
        tvShow.getSeasons[i]
            .addEpisode(Episode(seasonEpisodes[j]['name'], j, i, seasonEpisodes[j]['still_path']));
      }
    }
  }
}
