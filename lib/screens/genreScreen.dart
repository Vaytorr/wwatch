import 'package:flutter/material.dart';
import 'package:wwatch/app_localizations.dart';
import 'package:wwatch/tiles/movieTile.dart';
import 'package:wwatch/main.dart';

class GenreScreen extends StatefulWidget {
  final String name;
  final int id;
  final bool reset;
  final BuildContext context;
  GenreScreen(this.context, this.id, this.reset, this.name);
  @override
  _GenreScreenState createState() =>
      _GenreScreenState(context, id, reset, name);
}

double aspect;
int page = 1;

class _GenreScreenState extends State<GenreScreen> {
  String name;
  bool reset;
  int id;
  BuildContext context;
  _GenreScreenState(this.context, this.id, this.reset, this.name);

  @override
  Widget build(BuildContext context) {
    if (reset) {
      reset = false;
      page = 1;
    }
    aspect = MediaQuery.of(context).size.width / 662;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            transform: Matrix4.translationValues(0, -1, 0),
            padding: EdgeInsets.all(8),
            color: Colors.orange,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getData('genre', context, movieid: id, page: page),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else {
                      if (getCount(snapshot.data["results"]) > 0) {
                        return _createTable(context, snapshot, 'popularity');
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
          ),
          Container(
            height: 40,
            color: Colors.orange,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                onPressed: page > 1
                    ? () {
                        setState(() {
                          page -= 1;
                        });
                      }
                    : null,
                icon: Icon(Icons.arrow_back_ios),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                page.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    page += 1;
                  });
                },
                icon: Icon(Icons.arrow_forward_ios),
              )
            ]),
          )
        ],
      ),
    );
  }
}

Widget _createTable(
  BuildContext context,
  AsyncSnapshot snapshot,
  String type,
) {
  return GridView.builder(
      key: PageStorageKey<String>('GenreGrid'),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: aspect),
      itemCount: getCount(snapshot.data["results"]),
      itemBuilder: (context, index) {
        return MovieTile(index, "popularity", context, snapshot, false);
      });
}
