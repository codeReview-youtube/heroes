import 'dart:async';
import 'dart:convert';

import 'package:angular_tour_of_heroes/src/hero.dart';
import 'package:http/http.dart';

class HeroSearchService {
  final Client _client;

  HeroSearchService(this._client);

  Future<List<Hero>> search(String term) async {
    try {
      final response = await _client.get(
        'app/heroes/?name=$term',
      );

      return (_extractData(response) as List)
          .map((json) => Hero.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _extractData(Response response) => jsonDecode(response.body)['data'];

  Exception _handleError(dynamic e) {
    return Exception(
      'Server error; cause: ${e.toString()}',
    );
  }
}
