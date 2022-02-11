import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/datasources/remote/number_trivia_remote_data_source.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() {
  NumberTriviaRemoteDataSourceImpl? dataSource;

  MockClient? mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(
      client: mockClient!,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on URL with 
        number beign the endpointand with application/json header''', () {
      //  Arrange
      when(mockClient!.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      //  Act
      dataSource!.getConcreteNumberTrivia(tNumber);
      //  Assert
      verify(mockClient!.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test("should return NumberTrivia when the response code is 200 (success)",
        () async {
      //  Arrange
      when(mockClient!.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      //  Act
      final result = await dataSource!.getConcreteNumberTrivia(tNumber);

      //  Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        "should throw a ServerException when the response code is 505 or other",
        () {
      //  Arrange
      when(mockClient!.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('somthing goes wrong', 404));

      //  Act
      final call = dataSource!.getConcreteNumberTrivia;
      //  Assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on URL with 
        number beign the endpointand with application/json header''', () {
      //  Arrange
      when(mockClient!.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      //  Act
      dataSource!.getRandomNumberTrivia();
      //  Assert
      verify(mockClient!.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test("should return NumberTrivia when the response code is 200 (success)",
        () async {
      //  Arrange
      when(mockClient!.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      //  Act
      final result = await dataSource!.getRandomNumberTrivia();

      //  Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        "should throw a ServerException when the response code is 505 or other",
        () {
      //  Arrange
      when(mockClient!.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('somthing goes wrong', 404));

      //  Act
      final call = dataSource!.getRandomNumberTrivia;
      //  Assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
