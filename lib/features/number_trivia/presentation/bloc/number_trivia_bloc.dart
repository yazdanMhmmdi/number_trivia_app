import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia_clean_architecture_tdd/core/constants/value.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/failure.dart';
import 'package:number_trivia_clean_architecture_tdd/core/params/concrete_number_trivia_params.dart';
import 'package:number_trivia_clean_architecture_tdd/core/params/no_params.dart';
import 'package:number_trivia_clean_architecture_tdd/core/util/input_converter.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase getConcreteNumberTrivia;
  final GetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTriviaUseCase,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaConcreteNumber>((event, emit) async {
      emit(Empty());
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      emit(await inputEither.fold((left) async {
        return Error(message: kInvalidInputFailureMessage);
      }, (integer) async {
        emit(Loading());
        final failureOrTrivia = await getConcreteNumberTrivia(
            ConcreteNumberTriviaParams(number: integer));
        emit(await failureOrTrivia.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (trivia) {
            return Loaded(trivia: trivia);
          },
        ));
        return state;
        // return Loaded(trivia: NumberTriviaModel(text: 's', number: 1));
      }));
    });

    on<GetTriviaRandomNumber>((event, emit) async {
      emit(Empty());
      emit(Loading());
      final failureOrTrivia = await getRandomNumberTriviaUseCase(NoParams());
      emit(await failureOrTrivia.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia),
      ));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return kServerFailureMessage;
      case CacheFaliure:
        return kCacheFailureMessage;
      default:
        return 'Unexpected errror';
    }
  }
}
