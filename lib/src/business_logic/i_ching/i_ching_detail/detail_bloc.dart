import 'package:bloc/bloc.dart';
import '../../../data/repositories/i_ching/local_data_repo.dart';
import '../../../data/repositories/i_ching/models/hexagram.dart';
import 'detail_event.dart';
import 'detail_state.dart';

class IChingDetailBloc extends Bloc<IChingDetailEvent, IChingDetailState> {
  final IChingLocalDataRepo localDataRepo;

  IChingDetailBloc({required this.localDataRepo}) : super(IChingDetailState()) {
    on<GetWithCodeEvent>(_getWithCode);
  }

  void _getWithCode(GetWithCodeEvent event, Emitter<IChingDetailState> emit) async {
    String mdData = await localDataRepo.getHexagramMd(hexagramCode: event.code);
    emit(IChingDetailState(
      hexagram: Hexagram(
        code: event.code,
      ),
      mdData: mdData,
    ));
  }
}
