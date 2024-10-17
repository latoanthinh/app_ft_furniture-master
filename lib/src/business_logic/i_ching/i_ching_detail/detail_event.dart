abstract class IChingDetailEvent {
  IChingDetailEvent();

  factory IChingDetailEvent.getWithCode({required String code}) = GetWithCodeEvent;
}

class GetWithCodeEvent extends IChingDetailEvent {
  String code;

  GetWithCodeEvent({required this.code});
}
