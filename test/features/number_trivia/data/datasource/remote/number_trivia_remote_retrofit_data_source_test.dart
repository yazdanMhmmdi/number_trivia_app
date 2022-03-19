import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/datasources/remote/number_tivia_remote_retrofit_data_source.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/datasources/remote/number_trivia_remote_data_source.dart';
import 'package:dio/dio.dart' as client;
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia_client.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../fixtures/fixture_reader.dart';

import '../../repositories/number_trivia_repository_impl_test.mocks.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';
import 'number_trivia_remote_retrofit_data_source_test.mocks.dart';

@GenerateMocks([NumberTriviaClient])
void main() {
  NumberTriviaModel numberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
  NumberTriviaRemoteRetrofitDataSourceImpl? dataSource;
  MockNumberTriviaClient? mockClient;

  group("RemoteRetrofitDataSource", () {
    setUp(() {
      mockClient = MockNumberTriviaClient();
      dataSource = NumberTriviaRemoteRetrofitDataSourceImpl(mockClient);
    });
    test("should get ConcreteNumberTrivia from server (200) successfully",
        () async {
      //  Arrange
      when(mockClient!.getConcreteNumberTrivia(any)).thenAnswer((_) async =>
          HttpResponse<NumberTriviaModel>(
              numberTriviaModel,
              client.Response<String>(
                  data: fixture('trivia.json'),
                  statusCode: 200,
                  requestOptions: client.RequestOptions(
                      data: fixture('trivia.json'), path: ""))));
      //  Act
      final result = await dataSource!.getConcreteNumberTrivia(1);

      //  Assert
      expect(result, numberTriviaModel);
    });

    test("should get ConcreteNumberTrivia from server with (404) Exception",
        () async {
      //  Arrange
      when(mockClient!.getConcreteNumberTrivia(any)).thenAnswer((_) async =>
          HttpResponse<NumberTriviaModel>(
              numberTriviaModel,
              client.Response<String>(
                  data: "somthing goes wrong",
                  statusCode: 404,
                  requestOptions: client.RequestOptions(
                      data: 'somthing goes wrong', path: ""))));
      //  Act
      final result = dataSource!.getConcreteNumberTrivia;

      //  Assert
      expect(() => result(1), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
