class SplashState {
  bool isSuccess;

  SplashState({
    this.isSuccess = false,
  });

  SplashState clone() {
    return SplashState(
      isSuccess: isSuccess,
    );
  }
}
