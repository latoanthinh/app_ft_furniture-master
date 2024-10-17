abstract class IChingListEvent {
  IChingListEvent();

  factory IChingListEvent.init() = InitEvent;
}

class InitEvent extends IChingListEvent {}
