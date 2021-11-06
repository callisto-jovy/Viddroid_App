import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viddroid_flutter/cards/watchable_card.dart';
import 'package:viddroid_flutter/tasks/request_metadata_task.dart';
import 'package:viddroid_flutter/watchable/watchable.dart';
import 'package:viddroid_flutter/watchable/watchables.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final StreamController<List<Watchable>> _searchResults = StreamController<List<Watchable>>();
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void search(String value) async {
    List<Watchable> watchables = <Watchable>[];

    await TheMovieDBSearchMovieTask()
        .call(value)
        .then((value) => value.map((e) => Movie(e)).forEach((element) {
              watchables.add(element);
            }));

    await TheMovieDBSearchTVTask()
        .call(value)
        .then((value) => value.map((e) => TVShow(e)).forEach((element) {
              watchables.add(element);
            }));

    _searchResults.add(watchables);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: _textEditingController,
            key: _formFieldKey,
            decoration: InputDecoration(
                hintText: 'Search query',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    onPressed: () => _textEditingController.clear(),
                    icon: const Icon(Icons.cancel)),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'Please enter some search query first.';
              }
            },
            onFieldSubmitted: (value) {
              search(value);
            },
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: _searchResults.stream,
            builder: (context, AsyncSnapshot<List<Watchable>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    Watchable watchable = snapshot.data![i];
                    return WatchableCard(watchable, confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        setState(() {
                          if (!Watchables().contains(watchable)) {
                            Watchables().addWatchable(watchable);
                          }
                        });
                      }
                      return false;
                    }, dismissColor: Colors.green[400]!);
                  },
                );
              } else if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else {
                return const Center(child: Text('Awaiting actions'));
              }
            },
          ),
        ),
      ],
    );
  }
}
