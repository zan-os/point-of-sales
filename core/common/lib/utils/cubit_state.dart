enum CubitState {
  initial,
  loading,
  error,
  success,
  hasData,
  noData,
  finishLoading
}

extension CubitStateExtension on CubitState {
  bool get isLoading => this == CubitState.loading;

  bool get isInitial => this == CubitState.initial;

  bool get isError => this == CubitState.error;

  bool get isHasData => this == CubitState.hasData;

  bool get isNoData => this == CubitState.noData;
}
