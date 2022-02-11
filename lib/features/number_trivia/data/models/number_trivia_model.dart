import 'package:json_annotation/json_annotation.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
part 'number_trivia_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NumberTriviaModel extends NumberTrivia {
  String? text;
  @JsonKey(fromJson: numberFromJson)
  int? number;

  NumberTriviaModel({
    required this.text,
    required this.number,
  }) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) =>
      _$NumberTriviaModelFromJson(json);

  Map<String, dynamic> toJson() => _$NumberTriviaModelToJson(this);

  static int numberFromJson(dynamic number) {
    return (number as num).toInt();
  }
}
