import 'package:flutter/material.dart';
import 'package:novafilm/src/providers/movies_provider.dart';
import 'package:novafilm/src/widgets/card_swiper_widget.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = MoviesProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[_swiperCards()],
        ),
      ),
    );
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: moviesProvider.getMoviesInCinema(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            movies: snapshot.data,
          );
        } else {
          return Container(
            height: 700,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
