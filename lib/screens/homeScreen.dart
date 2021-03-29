import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wwatch/app_localizations.dart';
import 'package:wwatch/tiles/genreTile.dart';
import 'package:wwatch/tiles/movieTile.dart';
import 'package:wwatch/main.dart';

int pagePop = 1;
int pageRel = 1;
TextEditingController _textController = TextEditingController();
String _search;
double aspect;
String type;
int index;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Future<void> _launchInBrowser(String url) async {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    _textController.addListener(() {
      if (_textController.text == "" || _textController.text == null) {
        setState(() {
          pagePop = 1;
          _search = _textController.text;
        });
      }
    });
    //!Change aspect ratio based on device width---------------
    aspect = MediaQuery.of(context).size.width / 662;
    //!---------------------------------------------------------

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () {
                      _launchInBrowser("https://www.themoviedb.org/");
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
            bottom: TabBar(
              indicatorWeight: 0.1,
              labelColor: Colors.white,
              indicatorColor: Colors.transparent,
              tabs: [
                Tab(
                  text: AppLocalizations.of(context).translate('popularity'),
                ),
                Tab(
                  text: AppLocalizations.of(context).translate('genre'),
                ),
              ],
            ),
            title: Image(
              image: AssetImage(
                "assets/images/WWatch2-png.png",
              ),
              fit: BoxFit.fitHeight,
              height: 70,
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                children: [
                  Container(
                      color: Colors.orange,
                      height: 55,
                      padding: EdgeInsets.all(4),
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (text) {
                          setState(() {
                            pagePop = 1;
                            _search = text;
                          });
                        },
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                            labelText: AppLocalizations.of(context)
                                .translate('search'),
                            labelStyle: TextStyle(color: Colors.white),
                            suffix: IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  pagePop = 1;
                                  _search = _textController.text;
                                });
                              },
                            )),
                      )),
                  Expanded(
                      child: FutureBuilder(
                    future: getData('popularity', context,
                        page: pagePop, search: _search),
                    builder: (context, snapshot) {
                      type = 'popularity';
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Container(
                            width: 200,
                            height: 200,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 5,
                            ),
                          );
                        default:
                          if (snapshot.hasError)
                            return Container();
                          else {
                            if (getCount(snapshot.data["results"]) > 0) {
                              return _createTable(
                                  context, snapshot, 'popularity');
                            } else {
                              return Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('nothing'),
                                ),
                              );
                            }
                          }
                      }
                    },
                  )),
                  Container(
                    height: 40,
                    color: Colors.orange,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: pagePop > 1
                                ? () {
                                    setState(() {
                                      pagePop -= 1;
                                    });
                                  }
                                : null,
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            pagePop.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                pagePop += 1;
                              });
                            },
                            icon: Icon(Icons.arrow_forward_ios),
                          )
                        ]),
                  )
                ],
              ),
              FutureBuilder(
                future: getData(
                  'genres',
                  context,
                ),
                builder: (context, snapshot) {
                  type = 'genre';
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else {
                        if (getCount(snapshot.data["genres"]) > 0) {
                          return _createTable(context, snapshot, 'genres');
                        } else {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context).translate('nothing'),
                            ),
                          );
                        }
                      }
                  }
                },
              ),
            ],
          )),
    );
  }
}

Widget _createTable(
  BuildContext context,
  AsyncSnapshot snapshot,
  String type,
) {
  if (type == "genres") {
    return ListView.builder(
        key: PageStorageKey<String>('GenreList'),
        itemCount: getCount(snapshot.data["genres"]),
        itemBuilder: (context, index) {
          return GenreTile(context, snapshot, index);
        });
  } else {
    return GridView.builder(
        key: PageStorageKey<String>('PopularityGrid'),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: aspect),
        itemCount: getCount(snapshot.data["results"]),
        itemBuilder: (context, index) {
          if (_search == null || _search == "") {
            return MovieTile(index, "popularity", context, snapshot, false);
          } else {
            return MovieTile(index, "popularity", context, snapshot, true);
          }
        });
  }
}
