import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:viddroid_flutter/cards/general_purpose_card.dart';
import 'package:viddroid_flutter/provider/providers.dart';
import 'package:viddroid_flutter/tasks/request_metadata_task.dart';
import 'package:viddroid_flutter/watchable/episode.dart';
import 'package:viddroid_flutter/watchable/season.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';
import 'package:viddroid_flutter/widgets/widgets_viddroid.dart';

import 'chewie_video_player_page.dart';

class TVShowDetailPage extends StatefulWidget {
  final TVShow _tv;

  const TVShowDetailPage(this._tv, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TVShowDetailPageState();
}

class TVShowDetailPageState extends State<TVShowDetailPage> {
  int _selectedSeason = 0;
  int _selectedProvider = 0;
  List _providers = [];

  final StreamController<List<Episode>> _episodes = StreamController<List<Episode>>();

  @override
  void initState() {
    super.initState();
  }

  Widget get episodes {
    return StreamBuilder(
      stream: _episodes.stream,
      builder: (context, AsyncSnapshot<List<Episode>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Episode data = snapshot.data![index];
                return GeneralPurposeCard(
                  title: data.name,
                  upperCaption: 'Episode ${data.index + 1}',
                  onTap: () => _providers.isEmpty
                      ? null
                      : Providers.requestTVShowLink(_providers[_selectedProvider], widget._tv,
                              data.season, data.index + 1)
                          .then((value) =>
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return VideoPlayer(
                                  passableURL: value,
                                );
                              })))
                          .catchError((e) {
                          print(e);
                          Fluttertoast.showToast(
                              msg: 'Provider not available: $e', toastLength: Toast.LENGTH_LONG);
                          return -1;
                        }),
                  imageHeight: 169 / 1.5,
                  imageWidth: 300 / 1.5,
                  imageURL: data.getSeasonPosterPath(),
                );
              });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget get seasonSelector {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: FutureBuilder(
        future: TheMovieDBTVDetailsRequestTask().call(widget._tv),
        builder: (context, AsyncSnapshot<List<Season>> snapshot) {
          if (snapshot.hasData) {
            List<Season> seasons = snapshot.data!;
            return DropdownButton(
              hint: const Text('Seasons'),
              value: _selectedSeason,
              items: [
                for (int i = 0; i < seasons.length; i++)
                  DropdownMenuItem(
                    child: Text('Season $i'),
                    value: i,
                  )
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSeason = value as int;
                });
                _episodes.add(seasons[value as int].episodes);
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget get providerSelector {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: FutureBuilder(
        future: ViddroidAPIProvidersTask().call(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            _providers = snapshot.data!;
            return DropdownButton(
              hint: const Text('Providers'),
              value: _selectedProvider,
              items: [
                for (int i = 0; i < _providers.length; i++)
                  DropdownMenuItem(
                    child: Text(_providers[i]),
                    value: i,
                  )
              ],
              onChanged: (value) {
                setState(() {
                  _selectedProvider = value as int;
                });
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FavoriteBottomSheetDialog(watchable: widget._tv);
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)))),
              icon: const Icon(Icons.favorite)),
        ],
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HalfPageImage(tag: widget._tv.toString(), imageURL: widget._tv.getCardImage()),
              WatchableDetails(title: widget._tv.title, description: widget._tv.description),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  seasonSelector,
                  providerSelector,
                ],
              ),
              episodes,
            ],
          )),
    );
  }
}
