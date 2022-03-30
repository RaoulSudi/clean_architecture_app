import 'dart:convert';

import 'package:clean_architeture_app/core/error/exceptions.dart';
import 'package:clean_architeture_app/features/trivial_navigator/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architeture_app/features/trivial_navigator/data/models/number_trivia_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{

}


void main() {
  late NumberTriviaLocalDataSourceImpl datasource;
  late MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    datasource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
        // arrange
          when(()=> mockSharedPreferences.getString(any())).thenReturn(fixture('trivia_cached.json'));
        // act
          final result = await datasource.getLastNumberTrivia();
        // assert
          verify(()=>mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
          expect(result, equals(tNumberTriviaModel));

        }
    );

    test(
        'should throw Cacheexception when there is not a cached value',
            () async {
          // arrange
          when(()=> mockSharedPreferences.getString(any())).thenReturn(null);
          // act
          final call = datasource.getLastNumberTrivia;
          // assert
          expect(()=> call(), throwsA(const TypeMatcher<CacheException>()));

        }
    );

    group('cachedNumberTrivia',() {
      final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: 1);
      test(
        'should call SharedPreferencesto cache the data',
          () async {
          when(()=> mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => false);
          // act
            datasource.cacheNumberTrivia(tNumberTriviaModel);
          // assert
            final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
            verify(()=>mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
        
          }
      );
    });

  });
}
