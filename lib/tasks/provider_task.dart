import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:viddroid_flutter/constants.dart';
import 'package:viddroid_flutter/util/passable_url.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';
import 'package:viddroid_flutter/util/basic_util.dart';

class ProvideWatchableTask {
  Future<PremadeRequestURL> providerMovie(final String passedProvider, final Movie movie) async {
    var providers = await http
        .get(Uri.parse("${Constants.viddroidApi}/providers"))
        .then((value) => jsonDecode(value.body));

    for (dynamic provider in providers) {
      final String providerName = provider["name"];
      final String providerIdSystem = provider["id_system"];

      if (providerName == passedProvider) {
        var translatedIDs = await http
            .get(Uri.parse(
                "${Constants.viddroidApi}/external?id=${movie.id}&api_key=${Constants.apiKey}&tv=false"))
            .then((value) => jsonDecode(value.body))
            .then((value) => {
                  if (providerIdSystem == "imdb") {value["imdb_id"]} else {value["id"]}
                });

        var respAPI = await http
            .get(Uri.parse(
                "${Constants.viddroidApiMovie}/$passedProvider?title=${movie.title!.dashes()}&id=$translatedIDs"))
            .then((value) => jsonDecode(value.body));

        if (respAPI["status_code"] != 200) {
          return Future.error(respAPI["error"]);
        } else {
          var payload = respAPI["payload"];
          var headers = payload["init"]; //TODO: Does this work like this???
          final String url = payload["url"];
          final bool needsExtraction = payload["needsFurtherExtraction"];

          if (needsExtraction) {
            return providerStreamer(url, headers);
          } else {
            return PremadeRequestURL(url, headers: headers);
          }
        }
      }
    }
    return Future.error("Dead end.");
  }

  Future<PremadeRequestURL> providerTV(
      String passedProvider, TVShow tvShow, int season, int episode) async {
    var providers = await http
        .get(Uri.parse("${Constants.viddroidApi}/providers"))
        .then((value) => jsonDecode(value.body));

    for (dynamic provider in providers) {
      final String providerName = provider["name"];
      final String providerIdSystem = provider["id_system"];

      if (providerName == passedProvider) {
        var translatedIDs = await http
            .get(Uri.parse(
                "${Constants.viddroidApi}/external?id=${tvShow.id}&api_key=${Constants.apiKey}&tv=true"))
            .then((value) => jsonDecode(value.body))
            .then((value) => {
                  if (providerIdSystem == "imdb") {value["imdb_id"]} else {value["id"]}
                });

        var respAPI = await http
            .get(Uri.parse(
                "${Constants.viddroidApiTV}/$provider?title=${tvShow.title!.dashes()}&id=$translatedIDs&season=$season&episode=$episode"))
            .then((value) => jsonDecode(value.body));

        if (respAPI["status_code"] != 200) {
          return Future.error(respAPI["error"]);
        } else {
          var payload = respAPI["payload"];
          var headers = payload["init"]; //TODO: Does this work like this???
          final String url = payload["url"];
          final bool needsExtraction = payload["needsFurtherExtraction"];

          print(respAPI);

          if (needsExtraction) {
            return providerStreamer(url, headers);
          } else {
            return PremadeRequestURL(url, headers: headers);
          }
        }
      }
    }
    return Future.error("dead end.");
  }

  Future<PremadeRequestURL> providerStreamer(String referral, Map<String, dynamic> headers) async {
    print(Uri.parse(referral).authority);

    var respAPI = await http
        .post(
            Uri.parse(
                "${Constants.viddroidApiStreamer}/${Uri.parse(referral).authority}&url=$referral"),
            body: jsonEncode(headers))
        .then((value) => jsonDecode(value.body));

    if (respAPI["status_code"] != 200) {
      return Future.error(respAPI["error"]);
    } else {
      var payload = respAPI["payload"];
      var headers = payload["init"]; //TODO: Does this work like this???
      String url = payload["url"];
      bool needsExtraction = payload["needsFurtherExtraction"];

      if (needsExtraction) {
        return providerStreamer(url, headers);
      } else {
        return PremadeRequestURL(url, headers: headers);
      }
    }
  }
}
