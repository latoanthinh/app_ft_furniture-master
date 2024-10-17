class IChingCoinTossState {
  // Mặt có chữ là mặt dương, ngửa, true,
  // Mặt không có chữ là mặt âm, sấp, false
  List<bool>? coinAToss;
  List<bool>? coinBToss;
  List<bool>? coinCToss;

  String codeFirst() {
    String line = '';
    for (int i = 0; i < (coinAToss?.length ?? 0); i++) {
      line += _lineFirst(i) ? '1' : '0';
    }
    return line;
  }

  String codeSecond() {
    String line = '';
    for (int i = 0; i < (coinAToss?.length ?? 0); i++) {
      line += _lineSecond(i) ? '1' : '0';
    }
    return line;
  }

  bool _lineFirst(int index) {
    final [a, b, c] = [coinAToss![index], coinBToss![index], coinCToss![index]];
    final yin = [a, b, c].where((element) => element == true).length;
    switch (yin) {
      case 0:
        // ---o
        return true;
      case 1:
        // - -
        return false;
      case 2:
        // ---
        return true;
      case 3:
        // - -x
        return false;
      default:
        // error
        return true;
    }
  }

  bool _lineSecond(int index) {
    final [a, b, c] = [coinAToss![index], coinBToss![index], coinCToss![index]];
    final yin = [a, b, c].where((element) => element == true).length;
    switch (yin) {
      case 0:
        // ---o
        // return true;
        return false;
      case 1:
        // - -
        return false;
      case 2:
        // ---
        return true;
      case 3:
        // - -x
        // return false;
        return true;
      default:
        // error
        return true;
    }
  }

  IChingCoinTossState({
    this.coinAToss,
    this.coinBToss,
    this.coinCToss,
  });
}
