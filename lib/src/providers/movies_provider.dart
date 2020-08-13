import 'package:novafilm/src/models/actors_model.dart';
import 'package:novafilm/src/models/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MoviesProvider {
  String _apikey = '60113ab20260ad4abed7c2cc45935ef3';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';
  String _endPoint = 'results';

  int _popularsPage = 0;
  bool _loading = false;

  List<Movie> _popularsMovies = List();

  // Usamos broadcast para que otros puedan escuchar mi stream
  final _popularsStreamController = StreamController<List<Movie>>.broadcast();

  // Insertar info
  Function(List<Movie>) get popularsSink => _popularsStreamController.sink.add;

  // Recibir info
  Stream<List<Movie>> get popularStream => _popularsStreamController.stream;

  void disposeStreams() {
    _popularsStreamController?.close();
  }

  Future<List<Movie>> _processResponse(Uri uri, String endPoint) async {
    var response = await http.get(uri);
    // convierte la respuesta en un mapa
    var decodedData = json.decode(response.body);
    // lo añade en la lista de peliculas posicionandose en el objeto results
    final movies = new Movies.fromJsonList(decodedData[endPoint]);
    return movies.movieItems;
  }

  Future<List<Movie>> getMoviesInCinema() async {
    // Genera la url de la petición al servicio
    final uri = Uri.https(_baseUrl, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});
    return await _processResponse(uri, _endPoint);
  }

  Future<List<Movie>> getPopularMovies() async {
    // Comprobamos si está cargando los items y si ya terminó la llamada incrementamos la pagina

    if (_loading) return [];
    _loading = true;
    _popularsPage++;
    final uri = Uri.https(_baseUrl, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularsPage.toString()
    });

    final resp = await _processResponse(uri, _endPoint);
    _popularsMovies.addAll(resp);
    popularsSink(_popularsMovies);

    _loading = false;

    return resp;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_baseUrl, '3/movie/$movieId/credits',
        {'api_key': _apikey, 'language': _language});

    final response = await http.get(url);
    // Recoge la respuesta del servicio y la convierte en un mapa
    final decodedData = json.decode(response.body);
    // Construye el objeto cast desde la raiz 'cast'
    final cast = Cast.fromJsonList(decodedData['cast']);
    return cast.actors;
  }
}
