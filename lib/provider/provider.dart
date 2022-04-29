import 'package:viddroid_flutter/util/passable_url.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

abstract class Provider {
  Future<PremadeRequestURL> requestMovieLink(final Movie watchable);

  Future<PremadeRequestURL> requestTVShowLink(
      final TVShow watchable, final int season, final int episode);
}
