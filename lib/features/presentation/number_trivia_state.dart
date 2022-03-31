part of 'number_trivia_bloc.dart';


abstract class NumberTriviaState extends Equatable {

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {

}

class Empty extends NumberTriviaState{}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;
  Loaded({required this.trivia});

  @override
  // TODO: implement props
  List<Object?> get props => [trivia];

}

class Error extends NumberTriviaState {
  final String errorMessage;
  Error({required this.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [errorMessage];

}


