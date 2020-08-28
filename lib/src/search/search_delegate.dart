import 'package:flutter/material.dart';
import 'package:novafilm/src/models/movie.dart';
import 'package:novafilm/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  final movies = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Iroman',
    'Capitan America'
  ];
  final recentMovies = ['Spiderman', 'Capitan America'];

  final moviesProvider = MoviesProvider();
  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones del appbar (al empezar a escribir, sería el icono de cancelar o limpiar)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono de la izquierda
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que se muestran
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen cuando el usuario escribe.

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: moviesProvider.searchMoview(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;
          return ListView(
            children: movies.map((movie) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(movie.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(movie.title),
                subtitle: Text(movie.originalTitle),
                onTap: () {
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.pushNamed(context, 'detail', arguments: movie);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    // ---------------Ejemplo---------------

    //   final suggestList = (query.isEmpty)
    //       ? recentMovies
    //       : movies
    //           .where((movie) => movie.toLowerCase().contains(query.toLowerCase()))
    //           .toList();

    //   return ListView.builder(
    //     itemCount: suggestList.length,
    //     itemBuilder: (context, i) {
    //       return ListTile(
    //         leading: Icon(Icons.movie),
    //         title: Text(suggestList[i]),
    //         onTap: () {},
    //       );
    //     },
    //   );
    // }
  }
}
