import 'package:http/http.dart' as http;
import 'package:viddroid_flutter/connection/random_user_agent.dart';
import 'package:viddroid_flutter/provider/provider.dart';
import 'package:viddroid_flutter/util/basic_util.dart';
import 'package:viddroid_flutter/util/passable_url.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';

class VideoVakComAPI {
  String baseURL = 'https://videovak.com/en';

  String streamAPIResolverEndpoint =
      "https://stream.videovak.com/testapp/realtimeencoderstream_id.jsp";

  String streamAPIStreamFormatEndpoint =
      "https://stream.videovak.com/testapp/torrentrealtimeencoderstream_v1.23.jsp?id=";

  String formatTVRequest(final String title, final int season, final int episode) =>
      '$baseURL/series/$title/S${season}E$episode';

  String formatStreamTemp(final String title, final int season, final int episode) =>
      StringUtil.underscores(
          '${title.toLowerCase()} s${season.toString().padLeft(2, '0')}e${episode.toString().padLeft(2, '0')}');
}

class VideoVakCom extends Provider with VideoVakComAPI {
  @override
  Future<PassableURL> requestMovieLink(Movie watchable) =>
      Future.error('Videovak only hosts tv shows');

  @override
  Future<PassableURL> requestTVShowLink(TVShow watchable, int season, int episode) async {
    var response = await http.post(Uri.parse(streamAPIResolverEndpoint), body: {
      'temp_request': formatStreamTemp(watchable.title!, season, episode),
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'User-Agent': getRandomUserAgent(),
    });

    if (response.statusCode == 200) {
      String body = response.body;
      if (body.isEmpty) {
        return Future.error('Response body from resolver API is empty');
      }
      List<String> bodySplit = body.split("-");

      if (bodySplit.isEmpty) {
        return Future.error('Body split length 0');
      }

      String embed =
          streamAPIStreamFormatEndpoint + (bodySplit.length == 1 ? bodySplit[0] : bodySplit[1]);

      return PassableURL(embed, headers: {
        'User-Agent': getRandomUserAgent(),
        'Referrer': baseURL,
        'Range': 'bytes=0-',
      });
    } else {
      return Future.error('$streamAPIResolverEndpoint gave SC that\'s not 200');
    }
  }
}
