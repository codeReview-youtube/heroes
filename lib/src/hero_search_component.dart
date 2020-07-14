import 'dart:async';
import 'dart:math';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_tour_of_heroes/src/hero.dart';
import 'package:angular_tour_of_heroes/src/hero_search_service.dart';
import 'package:angular_tour_of_heroes/src/routes.dart';
import 'package:stream_transform/stream_transform.dart';

@Component(
  selector: 'hero-search',
  templateUrl: 'hero_search_component.html',
  styleUrls: ['hero_search_style.css'],
  directives: [coreDirectives],
  providers: [ClassProvider(HeroSearchService)],
  pipes: [commonPipes],
)
class HeroSearchComponent implements OnInit {
  HeroSearchService _heroSearchService;
  Router _router;

  Stream<List<Hero>> heroes;
  StreamController<String> _searchTerm = StreamController<String>.broadcast();

  void search(String term) => _searchTerm.add(term);

  HeroSearchComponent(
    this._heroSearchService,
    this._router,
  );
  void ngOnInit() async {
    heroes = _searchTerm.stream
        .transform(debounce(Duration(milliseconds: 300)))
        .distinct()
        .transform(switchMap((term) => term.isEmpty
            ? Stream<List<Hero>>.fromIterable([<Hero>[]])
            : _heroSearchService.search(term).asStream()))
        .handleError((e) {
      print(e); // for demo purposes only
    });
  }

  String _heroUrl(int id) => RoutePaths.hero.toUrl(
        parameters: {idParam: '$id'},
      );

  Future<NavigationResult> goToDetail(Hero hero) => _router.navigate(
        _heroUrl(hero.id),
      );
}
