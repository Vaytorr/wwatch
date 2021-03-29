import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wwatch/app_localizations.dart';
import 'package:wwatch/screens/homeScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [Locale('en', ''), Locale('pt', '')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      title: 'WWatch',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          primaryColor: Colors.orange,
          buttonColor: Colors.blue,
          accentColor: Colors.orange,
          backgroundColor: Colors.grey[850]),
      home: HomeScreen(),
    );
  }
}

Future<void> launchInBrowser(String url) async {
  await launch(
    url,
    forceSafariVC: false,
    forceWebView: false,
  );
}

int getCount(data) {
  return data.length;
}

Future<Map> getData(String type, BuildContext context,
    {int movieid, int page, String search}) async {
  //TODO get your own api key at https://developers.themoviedb.org
  String apiKey = '';
  //--------------------------------------------------------------------
  String lang = 'en';
  Locale myLocale = Localizations.localeOf(context);
  List locales = ['en', 'pt'];
  if (locales.contains(myLocale.toString())) {
    lang = myLocale.toString();
  }
  http.Response response;
  var url;
  switch (type) {
    case 'genre':
      {
        url = Uri.parse(
            "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=$lang-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&with_genres=$movieid");
      }
      break;
    case 'popularity':
      {
        if (search == null || search == "") {
          url = Uri.parse(
              "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=$lang&sort_by=popularity.desc&include_adult=true&include_video=false&page=$page&include_video=true");
        } else {
          url = Uri.parse(
              "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=$lang&query=$search&page=$page&include_adult=true");
        }
      }
      break;
    case 'genres':
      {
        url = Uri.parse(
            "https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey&language=$lang");
      }
      break;
    case 'images':
      {
        url = Uri.parse(
            "https://api.themoviedb.org/3/movie/$movieid/images?api_key=$apiKey&language=en");
      }
      break;
    case 'videos':
      {
        url = Uri.parse(
            "https://api.themoviedb.org/3/movie/$movieid/videos?api_key=$apiKey&language=en");
      }
      break;
  }
  response = await http.get(url);
  print(url);
  print(response.body);
  return json.decode(response.body);
}
