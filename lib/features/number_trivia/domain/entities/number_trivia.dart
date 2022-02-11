import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  String? text;
  int? number;
  NumberTrivia({required this.number, required this.text});
  @override
  List<Object?> get props => [
        text,
        number,
      ];
}
