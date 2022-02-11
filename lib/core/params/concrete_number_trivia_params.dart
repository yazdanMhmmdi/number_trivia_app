import 'package:equatable/equatable.dart';

class ConcreteNumberTriviaParams extends Equatable {
  int? number;

  ConcreteNumberTriviaParams({required this.number});

  @override
  List<Object?> get props => [number];
}
