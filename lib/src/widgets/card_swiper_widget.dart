import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:novafilm/src/models/movie.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          movies[index].uniqueId = '${movies[index].id}-card';
          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detail',
                    arguments: movies[index]),
                child: FadeInImage(
                  image: NetworkImage(movies[index].getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
        itemWidth: _screenSize.width * 0.9,
        itemHeight: _screenSize.height * 0.6,
        layout: SwiperLayout.TINDER,

        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
