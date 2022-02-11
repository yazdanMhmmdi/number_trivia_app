import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_clean_architecture_tdd/core/constants/value.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/datasources/local/number_trivia_local_data_souce.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../fixtures/fixture_reader.dart';
import 'number_trivia_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  NumberTriviaLocalDataSource? dataSource;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences!);
  });

  group('get last number tiriva', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));
    test(
        "should return NumberTrivia from SharedPreferences when there is one in the cache",
        () async {
      //  Arrange
      when(mockSharedPreferences!.getString(any))
          .thenReturn(fixture('trivia_cache.json'));
      //  Act
      final result = await dataSource!.getLastNumberTrivia();
      //  Assert
      verify(mockSharedPreferences!.getString(kCachedNumberTrivia));

      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw cache exception when there is not a cached value",
        () async {
      //  Arrange
      when(mockSharedPreferences!.getString(any)).thenReturn(null);
      //  Act
      final call = dataSource!.getLastNumberTrivia;
      //  Assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cache number trivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: 1);
    test("should call shared prefes to cache the data", () {
      //  Arrange
      when(mockSharedPreferences!.setString(
              kCachedNumberTrivia, json.encode(tNumberTriviaModel.toJson())))
          .thenAnswer((_) {
        return Future.value(true);
      });
      //  Act
      dataSource!.cacheNumberTrivia(tNumberTriviaModel);
      //  Assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences!
          .setString(kCachedNumberTrivia, expectedJsonString));
    });
  });
}
