import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WatchableDetails extends StatelessWidget {
  final String? title;
  final String? description;

  const WatchableDetails({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            title ?? 'No title available',
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            description ?? 'No description available',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
