import 'package:dartz/dartz.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/failure.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
