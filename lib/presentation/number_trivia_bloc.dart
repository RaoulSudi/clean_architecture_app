import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architeture_app/core/error/failures.dart';
import 'package:clean_architeture_app/core/use_cases/usecase.dart';
import 'package:clean_architeture_app/core/util/input_converter.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/entities/number_trivia.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/use_cases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'SERVER FAILURE';
const String CACHE_FAILURE_MESSAGE = 'CACHE FAILURE';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - Thr number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(NumberTriviaInitial()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  Future<void> _onGetTriviaForConcreteNumber(
      GetTriviaForConcreteNumber event, Emitter emit) async{
    // emit(MyState()); vorher: yield*(MyState());

    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);
    await inputEither.fold(
        (failure)async => emit(Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)),
        (integer) async {
          emit(Loading());
          final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
          failureOrTrivia.fold((failure) => emit(Error(errorMessage: _mapFailureToMessage(failure))),
                 (trivia) =>  emit(Loaded(trivia: trivia)));

        });
  }

  Future<void> _onGetTriviaForRandomNumber(
      GetTriviaForRandomNumber event, Emitter emit) async {
    // emit(MyState()); vorher: yield*(MyState());


          emit(Loading());
          final failureOrTrivia = await getRandomNumberTrivia(NoParams());
          failureOrTrivia.fold((failure) => emit(Error(errorMessage: _mapFailureToMessage(failure))),
                  (trivia) =>  emit(Loaded(trivia: trivia)));


  }

  String _mapFailureToMessage(Failure failure){
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
        default:
        return 'Unexpected error';
    
    }
  }
}
