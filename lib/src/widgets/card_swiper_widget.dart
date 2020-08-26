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
      height: 450,
      padding: EdgeInsets.only(top: 10.0),
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
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
        itemWidth: _screenSize.width * 0.6,
        itemHeight: _screenSize.height * 0.4,
        layout: SwiperLayout.CUSTOM,
        customLayoutOption: CustomLayoutOption(
          startIndex: 0,
          stateCount: 3,
        ).addRotate(
          [-55.0 / 180, 0.0, 55.0 / 180],
        ).addTranslate([
          Offset(-230.0, -40.0),
          Offset(0.0, 0.0),
          Offset(230.0, -40.0)
        ]).addOpacity([0.6, 1, 1]),
      ),
    );
  }
}
