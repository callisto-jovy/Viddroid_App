import '../constants.dart';

class TheMovieDBAPIEndpoints {
  final String endpoint;

  const TheMovieDBAPIEndpoints._internal(this.endpoint);

  @override
  String toString() => "TheMovieDBApi-Endpoint $endpoint";

  String getEndpoint() => endpoint;

  static const searchMovie = TheMovieDBAPIEndpoints._internal("/search/movie");
  static const searchTV = TheMovieDBAPIEndpoints._internal("/search/tv");
  static const tvDetails = TheMovieDBAPIEndpoints._internal("/tv");
}

class TheMovieDBAPIImageWidth {
  final String dimensions;

  const TheMovieDBAPIImageWidth._internal(this.dimensions);

  @override
  String toString() => "Image Dimension $dimensions";

  String getDimension() => dimensions;

  static const width300 = TheMovieDBAPIImageWidth._internal("w300");
  static const originalSize = TheMovieDBAPIImageWidth._internal("original");
  static const width500 = TheMovieDBAPIImageWidth._internal("w500");
}

const String apiv3Endpoint = "https://api.themoviedb.org/3";

const String apiKey = Constants.apiKey;

String formatEndpointSearchRequest(TheMovieDBAPIEndpoints dbapiEndpoint, String query) =>
    "$apiv3Endpoint${dbapiEndpoint.getEndpoint()}?api_key=$apiKey&page=1&query=${Uri.encodeFull(query)}";

String formatRequest(TheMovieDBAPIEndpoints dbapiEndpoint, String query,
        {String appendToResponse = '', List<String> appends = const <String>[]}) =>
    "$apiv3Endpoint${dbapiEndpoint.getEndpoint()}/$query?api_key=$apiKey" +
    ('&append_to_response=' + appendToResponse + appends.join(','));

String formatPosterPath(TheMovieDBAPIImageWidth imageWidth, final String posterPath) =>
    "https://image.tmdb.org/t/p/${imageWidth.getDimension()}$posterPath";
