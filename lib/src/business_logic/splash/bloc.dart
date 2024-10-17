import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../constants/config/remote_keys.dart';
import 'event.dart';
import 'state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState()) {
    on<InitEvent>(_init);
  }

  void _init(InitEvent event, Emitter<SplashState> emit) async {
    loadRemoteConfig();
    emit(SplashState(
      isSuccess: true,
    ));
  }

  Future<void> loadRemoteConfig() async {
    await FirebaseRemoteConfig.instance.setDefaults(RemoteConfigKeys.defaultValue);
    FirebaseRemoteConfig.instance.fetchAndActivate();
    FirebaseAnalytics.instance.logAppOpen();
  }
}
