import 'package:viddroid_flutter/tasks/provider_task.dart';
import 'package:viddroid_flutter/util/passable_url.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

class Providers {
  static Future<PremadeRequestURL> requestMovieLink(String provider, Movie movie) {
    return ProvideWatchableTask().providerMovie(provider, movie);
  }

  static Future<PremadeRequestURL> requestTVShowLink(
      String provider, final TVShow watchable, final int season, final int episode) {
    return ProvideWatchableTask().providerTV(provider, watchable, season, episode);
  }
}
