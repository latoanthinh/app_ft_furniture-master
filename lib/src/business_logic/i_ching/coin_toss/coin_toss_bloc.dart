import 'package:bloc/bloc.dart';
import 'coin_toss_event.dart';
import 'coin_toss_state.dart';

class IChingCoinTossBloc extends Bloc<IChingCoinTossEvent, IChingCoinTossState> {
  IChingCoinTossBloc() : super(IChingCoinTossState()) {
    on<InitEvent>(_init);
    on<TossEvent>(_toss);
  }

  void _init(InitEvent event, Emitter<IChingCoinTossState> emit) async {}

  void _toss(TossEvent event, Emitter<IChingCoinTossState> emit) async {}
}
