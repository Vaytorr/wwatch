import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wwatch/app_localizations.dart';
import 'package:wwatch/screens/movieScreen.dart';

class MovieTile extends StatefulWidget {
  final int index;
  final String type;
  final BuildContext context;
  final AsyncSnapshot snapshot;
  final bool searching;
  MovieTile(this.index, this.type, this.context, this.snapshot, this.searching);
  @override
  _MovieTileState createState() =>
      _MovieTileState(index, type, context, snapshot, searching);
}

class _MovieTileState extends State<MovieTile> {
  String type;
  int index;
  BuildContext context;
  AsyncSnapshot snapshot;
  bool searching;
  _MovieTileState(
      this.index, this.type, this.context, this.snapshot, this.searching);
  @override
  Widget build(BuildContext context) {
    double rate = (snapshot.data["results"][index]["vote_average"] + 0.0) / 2;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MovieScreen(context, snapshot, index)));
      },
      child: Container(
        padding: EdgeInsets.zero,
        child: Card(
            elevation: 1,
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CachedNetworkImage(
                            fit: BoxFit.fill,
                            height: 250,
                            imageUrl:
                                "https://image.tmdb.org/t/p/w500/${snapshot.data["results"][index]["poster_path"]}",
                            placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.orange,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black54),
                                  ),
                                ),
                            errorWidget: (context, url, error) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(AppLocalizations.of(context)
                                        .translate('noImage'))
                                  ],
                                )),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: snapshot.data["results"][index]["title"],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            rate > 0 && rate <= 1
                                ? Icon(
                                    Icons.star_half,
                                    color: Colors.yellow,
                                  )
                                : rate == 0
                                    ? Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.grey,
                                      )
                                    : Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                            rate > 1 && rate <= 1.5
                                ? Icon(
                                    Icons.star_half,
                                    color: Colors.yellow,
                                  )
                                : rate <= 1
                                    ? Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.grey,
                                      )
                                    : Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                            rate > 2 && rate <= 2.5
                                ? Icon(
                                    Icons.star_half,
                                    color: Colors.yellow,
                                  )
                                : rate <= 2
                                    ? Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.grey,
                                      )
                                    : Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                            rate > 3 && rate <= 3.5
                                ? Icon(
                                    Icons.star_half,
                                    color: Colors.yellow,
                                  )
                                : rate <= 3
                                    ? Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.grey,
                                      )
                                    : Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                            rate > 4 && rate <= 4.9
                                ? Icon(
                                    Icons.star_half,
                                    color: Colors.yellow,
                                  )
                                : rate <= 4
                                    ? Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.grey,
                                      )
                                    : Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                          ],
                        ),
                      ]),
                )
              ],
            ))),
      ),
    );
  }
}
