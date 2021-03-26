import 'package:flutter/material.dart';
import 'package:wwatch/screens/genreScreen.dart';

class GenreTile extends StatelessWidget {
  final int index;
  final BuildContext context;
  final AsyncSnapshot snapshot;
  GenreTile(this.context, this.snapshot, this.index);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GenreScreen(
                    context,
                    snapshot.data["genres"][index]["id"],
                    true,
                    snapshot.data["genres"][index]["name"])));
          },
          child: Container(
            padding: EdgeInsets.all(4),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(snapshot.data["genres"][index]['name']),
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
