abstract class IChingCoinTossEvent {
  IChingCoinTossEvent();

  factory IChingCoinTossEvent.init() = InitEvent;

  factory IChingCoinTossEvent.toss({bool? coinAToss, bool? coinBToss, bool? coinCToss}) = TossEvent;
}

class InitEvent extends IChingCoinTossEvent {}

class TossEvent extends IChingCoinTossEvent {
  final bool? coinAToss;
  final bool? coinBToss;
  final bool? coinCToss;

  TossEvent({this.coinAToss, this.coinBToss, this.coinCToss});
}
