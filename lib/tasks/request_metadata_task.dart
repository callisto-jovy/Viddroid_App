import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:viddroid_flutter/connection/random_user_agent.dart';
import 'package:viddroid_flutter/constants.dart';
import 'package:viddroid_flutter/themoviedb/themoviedb.dart' as the_movie_db;
import 'package:viddroid_flutter/watchable/episode.dart';
import 'package:viddroid_flutter/watchable/season.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

class ViddroidAPIProvidersTask {
  Future<List> call() async {
    var resp = await http
        .get(Uri.parse("${Constants.viddroidApi}/providers"))
        .then((value) => jsonDecode(value.body));

    if (resp["status_code"] == 200) {
      return (resp["payload"] as List).map((e) => e["name"]).toList();
    } else {
      return ["null"];
    }
  }
}

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
  Future<List<Season>> call(TVShow tvShow) async {
    if (tvShow.getSeasons.isNotEmpty) {
      return tvShow.getSeasons;
    }

    String endpoint = the_movie_db.formatRequest(
        the_movie_db.TheMovieDBAPIEndpoints.tvDetails, tvShow.id.toString());
    var resp = await http.get(Uri.parse(endpoint),
        headers: {"User-Agent": getRandomUserAgent()}).then((value) => jsonDecode(value.body));

    var seasons = resp['seasons'];

    if (seasons.length == 1) {
      tvShow.addSeason(-1, Season(0));
      String seasonEndpoint = the_movie_db.formatRequest(
          the_movie_db.TheMovieDBAPIEndpoints.tvDetails, tvShow.id.toString() + "/season/1");

      var seasonResp = await http.get(Uri.parse(seasonEndpoint),
          headers: {"User-Agent": getRandomUserAgent()}).then((value) => jsonDecode(value.body));
      var seasonEpisodes = seasonResp['episodes'];

      for (int j = 0; j < seasonEpisodes.length; j++) {
        tvShow.getSeasons[0]
            .addEpisode(Episode(seasonEpisodes[j]['name'], j, 1, seasonEpisodes[j]['still_path']));
      }
    } else {
      for (int i = 0; i < seasons.length; i++) {
        tvShow.addSeason(-1, Season(i));

        String seasonEndpoint = the_movie_db.formatRequest(
            the_movie_db.TheMovieDBAPIEndpoints.tvDetails, tvShow.id.toString() + "/season/$i");

        var seasonResp = await http.get(Uri.parse(seasonEndpoint),
            headers: {"User-Agent": getRandomUserAgent()}).then((value) => jsonDecode(value.body));

        var seasonEpisodes = seasonResp['episodes'];

        for (int j = 0; j < seasonEpisodes.length; j++) {
          tvShow.getSeasons[i].addEpisode(
              Episode(seasonEpisodes[j]['name'], j, i, seasonEpisodes[j]['still_path']));
        }
      }
    }
    return tvShow.getSeasons;
  }
}
