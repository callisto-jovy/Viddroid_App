import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralPurposeCard extends StatelessWidget {
  final String? title;
  final String? upperCaption;
  final String? lowerCaption;
  final String? description;

  final String? imageURL;
  final double imageWidth;
  final double imageHeight;

  final Function onTap;

  const GeneralPurposeCard(
      {Key? key,
      required this.title,
      this.upperCaption,
      this.lowerCaption,
      this.description,
      this.imageURL,
      required this.imageWidth,
      required this.imageHeight,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: () => onTap.call(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: imageHeight,
              width: imageWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage(imageURL ??
                      'https://www.themoviedb.org/assets/2/apple-touch-icon-cfba7699efe7a742de25c28e08c38525f19381d31087c69e89d6bcb8e3c0ddfa.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(left: 13.0, bottom: 14.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (upperCaption != null)
                        Text(upperCaption!, style: Theme.of(context).textTheme.caption),
                      Text(
                        title ?? 'No title ',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Flexible(
                        child: Text(
                          description ?? 'No description available',
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      if (lowerCaption != null)
                        Text(lowerCaption!, style: Theme.of(context).textTheme.caption),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
