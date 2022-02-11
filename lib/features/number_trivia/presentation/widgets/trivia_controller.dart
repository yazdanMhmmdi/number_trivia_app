import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControllers extends StatefulWidget {
  const TriviaControllers({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControllers> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControllers> {
  final controller = TextEditingController();
  String? inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (val) {
            inputStr = val;
          },
          onSubmitted: (_) {
            callEventConcrete();
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: callEventConcrete,
              child: const Text("Search"),
            )),
            SizedBox(width: 10),
            Expanded(
                child: ElevatedButton(
              onPressed: callEventRandom,
              child: const Text("Get random tirvia"),
            )),
          ],
        )
      ],
    );
  }

  void callEventConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaConcreteNumber(inputStr!));
  }

  void callEventRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaRandomNumber());
  }
}
