import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_clean_architecture_tdd/core/util/input_converter.dart';

void main() {
  InputConverter? inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInt", () {
    test(
        "should return an integer when the string represets an unsigned integer",
        () {
      //  Arrange
      final str = '123';
      //  Act
      final result = inputConverter!.stringToUnsignedInteger(str);
      //  Assert
      expect(result, Right(123));
    });
  });

  test("should return a failure when the string is not an integer", () {
    //  Arrange
    final str = 'abc';
    //  Act
    final result = inputConverter!.stringToUnsignedInteger(str);
    //  Assert
    expect(result, Left(InvalideInputFailure()));
  });

  test("should return failure when the tring is a negative integer", () {
    //  Arrange
    final str = '-112';
    //  Act
    final result = inputConverter!.stringToUnsignedInteger(str);
    //  Assert
    expect(result, Left(InvalideInputFailure()));
  });

}
