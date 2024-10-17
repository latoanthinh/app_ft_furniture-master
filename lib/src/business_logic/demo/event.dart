abstract class DemoEvent {}

class InitEvent extends DemoEvent {}

class SetNumberEvent extends DemoEvent {
  int numberNew;

  SetNumberEvent({
    this.numberNew = 0,
  });
}
