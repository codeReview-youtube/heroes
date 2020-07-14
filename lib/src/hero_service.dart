import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'hero.dart';
import 'mock_heroes.dart';

class HeroService {
  static const _heroUrl = 'api/heroes';
  final Client _client;
  static final _headers = {'Content-Type': "application/json"};

  HeroService(this._client);

  // Future<Hero> get(int id) async =>
  //     (await getAll()).firstWhere((hero) => hero.id == id);
  // Future<List<Hero>> getAll() async => mockHeroes;
  Future<List<Hero>> getAll() async {
    try {
      final res = await _client.get(_heroUrl);
      final heroes = (_extractData(res) as List)
          .map((json) => Hero.fromJson(json))
          .toList();
      return heroes;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Hero> get(int id) async {
    try {
      final res = await _client.get('$_heroUrl/$id');
      return Hero.fromJson(_extractData(res));
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _extractData(Response resp) => json.decode(resp.body)['data'];
  Exception _handleError(dynamic e) {
    print(e);
    return Exception('Serves error; cause ${e.toString()}');
  }

  Future<Hero> update(Hero hero) async {
    try {
      final url = '$_heroUrl/${hero.id}';
      final resp = await _client.put(
        url,
        headers: _headers,
        body: jsonEncode(hero),
      );
      return Hero.fromJson(_extractData(resp));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Hero> create(String name) async {
    try {
      final resp = await _client.post(
        _heroUrl,
        headers: _headers,
        body: jsonEncode({'name': name}),
      );
      return Hero.fromJson(_extractData(resp));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(int id) async {
    try {
      final url = '$_heroUrl/$id';
      await _client.delete(url, headers: _headers);
    } catch (e) {
      throw _handleError(e);
    }
  }
}
