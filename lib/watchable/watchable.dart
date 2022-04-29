import 'package:flutter/cupertino.dart';
import 'package:viddroid_flutter/themoviedb/themoviedb.dart' as the_movie_db;
import 'package:viddroid_flutter/watchable/season.dart';

abstract class Watchable {
  final String? _title, _description, _backdropPath, _cardImagePath;
  final int _id;

  Watchable(this._id, this._title, this._description, this._backdropPath, this._cardImagePath);

  @protected
  String? get backdropPath => _backdropPath;

  @protected
  get cardImagePath => _cardImagePath;

  String? get title => _title;

  get description => _description;

  int get id => _id;

  @override
  String toString() => 'Watchable "$title" with id: $id';

  String? getBackdropImage() => _backdropPath == null
      ? null
      : the_movie_db.formatPosterPath(
          the_movie_db.TheMovieDBAPIImageWidth.originalSize, _backdropPath!);

  String? getCardImage() => _cardImagePath == null
      ? null
      : the_movie_db.formatPosterPath(
          the_movie_db.TheMovieDBAPIImageWidth.width500, _cardImagePath!);

  Map toJson();
}

class TVShow extends Watchable {
  final List<Season> _seasons = [];

  TVShow(dynamic json)
      : super(
            json['id'], json['name'], json['overview'], json['backdrop_path'], json['poster_path']);

  void addSeason(int index, Season season) =>
      index == -1 ? _seasons.add(season) : _seasons[index] = season;

  List<Season> get getSeasons => _seasons;

  @override
  Map toJson() => {
        'tv': true,
        'id': id,
        'name': title,
        'overview': description,
        'backdrop_path': backdropPath,
        'poster_path': cardImagePath,
      };
}

class Movie extends Watchable {
  Movie(dynamic json)
      : super(json['id'], json['title'], json['overview'], json['backdrop_path'],
            json['poster_path']);

  @override
  Map toJson() => {
        'tv': false,
        'id': id,
        'title': title,
        'overview': description,
        'backdrop_path': backdropPath,
        'poster_path': cardImagePath
      };
}
