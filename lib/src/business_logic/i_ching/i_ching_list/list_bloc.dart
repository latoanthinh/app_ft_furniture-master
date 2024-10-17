import 'package:bloc/bloc.dart';
import '../../../data/repositories/i_ching/local_data_repo.dart';
import 'list_event.dart';
import 'list_state.dart';

class IChingListBloc extends Bloc<IChingListEvent, IChingListState> {
  final IChingLocalDataRepo localDataRepo;

  IChingListBloc({
    required this.localDataRepo,
  }) : super(IChingListState()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<IChingListState> emit) async {
    final hexagramData = await localDataRepo.getHexagrams();
    emit(IChingListState(hexagrams: hexagramData));
  }
}
