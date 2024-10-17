abstract class SplashEvent {
  SplashEvent();

  factory SplashEvent.init() = InitEvent;
}

class InitEvent extends SplashEvent {}
