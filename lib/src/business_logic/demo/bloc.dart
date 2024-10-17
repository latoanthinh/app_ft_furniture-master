import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';

class DemoBloc extends Bloc<DemoEvent, DemoState> {
  DemoBloc() : super(DemoState()) {
    on<InitEvent>(_init);
    on<SetNumberEvent>(_setNumber);
  }

  void _init(InitEvent event, Emitter<DemoState> emit) async {
    print('_init running');
  }

  void _setNumber(SetNumberEvent event, Emitter<DemoState> emit) async {
    print('_setNumber running');
    emit(DemoState(number: event.numberNew));
    await Future.delayed(Duration(seconds: 1));
    emit(DemoState(number: event.numberNew * 2));
    await Future.delayed(Duration(seconds: 1));
    emit(DemoState(number: event.numberNew * 3));
  }
}
