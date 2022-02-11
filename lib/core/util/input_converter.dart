import 'package:dartz/dartz.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalideInputFailure());
    }
  }
}

class InvalideInputFailure extends Failure {}
