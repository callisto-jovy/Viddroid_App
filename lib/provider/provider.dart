import 'package:viddroid_flutter/util/passable_url.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

abstract class Provider {
  Future<PassableURL> requestMovieLink(final Movie watchable);

  Future<PassableURL> requestTVShowLink(
      final TVShow watchable, final int season, final int episode);
}
