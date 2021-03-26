import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:wwatch/app_localizations.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:wwatch/tiles/videoTile.dart';
import 'package:wwatch/main.dart';

double aspect;

class MovieScreen extends StatefulWidget {
  final BuildContext context;
  final AsyncSnapshot snapshot2;
  final int index;
  MovieScreen(this.context, this.snapshot2, this.index);
  @override
  _MovieScreenState createState() =>
      _MovieScreenState(context, snapshot2, index);
}

class _MovieScreenState extends State<MovieScreen> {
  BuildContext context;
  AsyncSnapshot snapshot2;
  int index;

  @override
  void initState() {
    super.initState();
  }

  _MovieScreenState(this.context, this.snapshot2, this.index);
  @override
  Widget build(BuildContext context) {
    int id = snapshot2.data['results'][index]['id'];

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () {
                    launchInBrowser("https://www.themoviedb.org/");
                  },
                  child: Image(
                    width: 40,
                    fit: BoxFit.fitWidth,
                    image: AssetImage(
                      "assets/images/MovieDB.png",
                    ),
                  ),
                ))
          ],
          elevation: 0,
          title: Image(
            image: AssetImage(
              "assets/images/WWatch2-png.png",
            ),
            fit: BoxFit.fitHeight,
            height: 70,
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  snapshot2.data["results"][index]["poster_path"] != null ||
                          snapshot2.data["results"][index]["backdrop_path"] !=
                              null
                      ? Stack(children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(snapshot2.data["results"]
                                              [index]["backdrop_path"] !=
                                          null
                                      ? "https://image.tmdb.org/t/p/w500/${snapshot2.data["results"][index]["backdrop_path"]}"
                                      : "https://image.tmdb.org/t/p/w500/${snapshot2.data["results"][index]["poster_path"]}")),
                            ),
                            height: 250.0,
                          ),
                          Container(
                            height: 252.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [
                                      Colors.grey[850].withOpacity(0.2),
                                      Theme.of(context).backgroundColor,
                                    ],
                                    stops: [
                                      0.0,
                                      1.0
                                    ])),
                          )
                        ])
                      : Container(),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot2.data["results"][index]["title"],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        snapshot2.data["results"][index]["poster_path"] != null
                            ? DropCapText(
                                snapshot2.data["results"][index]["overview"] !=
                                        null
                                    ? snapshot2.data["results"][index]
                                        ["overview"]
                                    : "",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.start,
                                dropCap: DropCap(
                                    width: 120,
                                    height: 150,
                                    child: Image.network(
                                      "https://image.tmdb.org/t/p/w500/${snapshot2.data["results"][index]["poster_path"]}",
                                      fit: BoxFit.fitHeight,
                                      height: 250,
                                    )),
                              )
                            : Text(
                                snapshot2.data["results"][index]["overview"]),
                        SizedBox(height: 11),
                        Divider(),
                        SizedBox(height: 11),
                        FutureBuilder(
                          future: getData('images', context, movieid: id),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 5,
                                  ),
                                );
                              default:
                                if (snapshot.hasError)
                                  return Container();
                                else {
                                  if (getCount(snapshot.data["posters"]) > 0) {
                                    return Column(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate('posters'),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 22,
                                        ),
                                        _createTable(context, snapshot)
                                      ],
                                    );
                                  } else {
                                    return Container(
                                      height: 0,
                                      width: 0,
                                    );
                                  }
                                }
                            }
                          },
                        ),
                        SizedBox(height: 11),
                        Divider(),
                        SizedBox(height: 11),
                        FutureBuilder(
                          future: getData('videos', context, movieid: id),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 5,
                                  ),
                                );
                              default:
                                if (snapshot.hasError)
                                  return Container();
                                else {
                                  if (getCount(snapshot.data["results"]) > 0) {
                                    return Column(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate('videos'),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 22,
                                        ),
                                        displayVideos(context, snapshot),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate('drag'),
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container(
                                      height: 0,
                                      width: 0,
                                    );
                                  }
                                }
                            }
                          },
                        ),
                        SizedBox(height: 11),
                        Divider(),
                        SizedBox(height: 11),
                        Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context).translate('releaseDate')}: ",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            snapshot2.data["results"][index]["release_date"] !=
                                    null
                                ? Text(snapshot2.data["results"][index]
                                    ["release_date"])
                                : Text("To be announced")
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${AppLocalizations.of(context).translate('originalTitle')}: ${snapshot2.data["results"][index]["original_title"]}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context).translate('originalLanguage')}: ",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(snapshot2.data["results"][index]
                                ["original_language"])
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context).translate('userRating')}: ",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(snapshot2.data["results"][index]
                                    ["vote_average"]
                                .toString()),
                            Text("/10")
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

Widget _createTable(
  BuildContext context,
  AsyncSnapshot snapshot,
) {
  return AspectRatio(
    aspectRatio: 0.7,
    child: Carousel(
      images: images(snapshot),
      dotSize: 0,
      dotSpacing: 4,
      dotBgColor: Colors.transparent,
      autoplay: true,
      dotColor: Colors.amber,
      dotIncreasedColor: Colors.amber,
      animationDuration: Duration(milliseconds: 300),
      autoplayDuration: Duration(seconds: 10),
    ),
  );
}

List images(AsyncSnapshot snapshot) {
  List<Widget> a = [];

  for (var i = 0; i < getCount(snapshot.data["posters"]); i++) {
    if (snapshot.data["posters"][i]['file_path'] != null &&
        snapshot.data["posters"][i]['file_path'] != "" &&
        i < 30) {
      a.add(Image.network(
          "https://image.tmdb.org/t/p/w500/${snapshot.data['posters'][i]['file_path']}"));
    }
  }
  return a;
}

Widget displayVideos(
  BuildContext context,
  AsyncSnapshot snapshot,
) {
  int count = getCount(snapshot.data['results']);
  return AspectRatio(
      aspectRatio: count > 1 ? 1 : 1.6,
      child: ListView.builder(
          itemCount: count,
          itemBuilder: (context, index) {
            return VideoTile(context, snapshot, index);
          }));
}
