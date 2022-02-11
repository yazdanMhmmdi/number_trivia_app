import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Dummy data j");

  test("should be a subclass of NumberTrivia entitiy", () {
    //  Arrange

    //  Act

    //  Assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test("should return a valid model when the JSON number is an integer", () {
      //  Arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      //  Act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //  Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test("should return a valid model when the JSON number is an double", () {
      //  Arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      //  Act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //  Assert
      expect(result, equals(tNumberTriviaModel));
    });
  });
  group("toJson", () {
    test("should return a JSON map containing the proper data", () {
      //  Arrange

      //  Act
      final result = tNumberTriviaModel.toJson();
      //  Assert
      final expectedMap = {
        "text": "Dummy data j",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
