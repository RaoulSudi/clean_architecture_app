import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architeture_app/core/util/input_converter.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/entities/number_trivia.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/use_cases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({required this.getConcreteNumberTrivia, required this.getRandomNumberTrivia, required this.inputConverter}) :
        super(NumberTriviaInitial()) {
    on<NumberTriviaEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetTriviaForConcreteNumber>((event, emit) {
      // emit(MyState()); vorher: yield*(MyState());
      inputConverter.stringToUnsignedInteger(event.numberString);
      emit(Error(errorMessage: 'Invalid Input'));
    });
  }
}
