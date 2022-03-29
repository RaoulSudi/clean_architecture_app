import 'package:clean_architeture_app/features/trivial_navigator/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  // Gets the cached [NumberTriviaModel] which was gotten the last time
  // the user Had an internet connection.
  //
  //throws [CacheException] if no cached data is present.

  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}