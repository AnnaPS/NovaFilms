import 'package:flutter/material.dart';
import 'package:novafilm/src/models/movie.dart';

class HorizontalCards extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  HorizontalCards({@required this.movies, @required this.nextPage});

  final _pageController = PageController(initialPage: 1, viewportFraction: 0.3);
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    // Salta cada vez que se hace scroll
    _pageController.addListener(() {
      // comprueba si es el ultimo item de la pagina para cargar más y además deja un margen de 200
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (context, i) => _createCard(context, movies[i]),
      ),
    );
  }

  Widget _createCard(BuildContext context, Movie movie) {
    movie.uniqueId = '${movie.id}-poster';

    final movieCard = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: movieCard,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }

  List<Widget> _cards(BuildContext context) {
    return movies.map((movie) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}
