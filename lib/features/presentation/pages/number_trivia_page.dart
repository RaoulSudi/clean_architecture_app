import 'package:clean_architeture_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../number_trivia_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                //top half
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is NumberTriviaInitial) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: const MessageDisplay(
                          message: 'start searching',
                        ),
                      );
                    } else if (state is Loading) {
                      return const LoadingWidget();
                    } else if (state is Loaded) {
                      return TriviaDisplay(numberTrivia: state.trivia);
                    } else if (state is Error) {
                      return MessageDisplay(message: state.errorMessage);
                    } else {
                      return Container();
                    }
                  },
                ),

                const SizedBox(height: 20),
                // bottom half
                const TriviaControlls()
              ],
            ),
          ),
        ));
  }
}

class TriviaControlls extends StatefulWidget {
  const TriviaControlls({Key? key}) : super(key: key);

  @override
  State<TriviaControlls> createState() => _TriviaControllsState();
}

class _TriviaControllsState extends State<TriviaControlls> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: const OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcret();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: ElevatedButton(onPressed: () {dispatchConcret();}, child: Text('Search'))),
            Expanded(
                child: ElevatedButton(
                    onPressed: () {dispatchRandom();}, child: Text('Get random trivia'))),
          ],
        )
      ],
    );
  }

  void dispatchConcret() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
