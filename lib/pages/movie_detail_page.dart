import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:viddroid_flutter/cards/general_purpose_card.dart';
import 'package:viddroid_flutter/provider/providers.dart';
import 'package:viddroid_flutter/tasks/request_metadata_task.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';
import 'package:viddroid_flutter/widgets/widgets_viddroid.dart';

import 'chewie_video_player_page.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie _movie;

  const MovieDetailPage(this._movie, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  int _selectedProvider = 0;
  List _providers = [];

  Widget get episode {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        children: [
          GeneralPurposeCard(
              title: widget._movie.title,
              imageURL: widget._movie.getBackdropImage(),
              description: widget._movie.description,
              imageHeight: 169 / 1.5,
              imageWidth: 300 / 1.5,
              onTap: () => _providers.isEmpty
                  ? null
                  : Providers.requestMovieLink(_providers[_selectedProvider], widget._movie)
                      .then((value) =>
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return VideoPlayer(
                              passableURL: value,
                            );
                          })))
                      .catchError((e) {
                      Fluttertoast.showToast(
                          msg: 'Provider not available: $e', toastLength: Toast.LENGTH_LONG);
                      return -1;
                    }))
        ],
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
                for (int i = 0; i < snapshot.data!.length; i++)
                  DropdownMenuItem(
                    child: Text(snapshot.data![i]),
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
        actions: <Widget>[
          IconButton(
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FavoriteBottomSheetDialog(watchable: widget._movie);
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)))),
              icon: const Icon(Icons.favorite)),
        ],
      ),
      body: Column(
        children: [
          HalfPageImage(tag: widget._movie.toString(), imageURL: widget._movie.getCardImage()),
          WatchableDetails(title: widget._movie.title, description: widget._movie.description),
          providerSelector,
          episode
        ],
      ),
    );
  }
}
