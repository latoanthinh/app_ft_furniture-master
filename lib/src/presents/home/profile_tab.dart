import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/demo/bloc.dart';
import '../../business_logic/demo/event.dart';
import '../../business_logic/demo/state.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = DemoBloc();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appbar'),
      ),
      body: BlocBuilder<DemoBloc, DemoState>(
        bloc: logic,
        builder: (context, state) {
          print('builder build: ${state.number}');
          
          return Column(
            children: [
              Text(
                'Number is: ${state.number}',
                style: TextStyle(
                  fontSize: 64,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  logic.add(SetNumberEvent(numberNew: ((state.number ?? 0) + 1)));
                },
                child: Text('Set number'),
              ),
            ],
          );
        },
      ),
    );
  }
}
