mixin BuilderHelpers {
  bool disposed = false;
  bool _initialised = false;
  bool get initialised => _initialised;

  bool _onModelReadyCalled = false;
  bool get onModelReadyCalled => _onModelReadyCalled;

  void setInitialised(bool value) {
    _initialised = value;
  }

  void setOnModelReadyCalled(bool value) {
    _onModelReadyCalled = value;
  }
}