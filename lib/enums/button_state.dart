/// [ButtonState] for managing states of Button.
// ignore_for_file: constant_identifier_names

enum ButtonState {
  ///[ButtonState.LOADING] to check loading state and show progressIndicator.
  LOADING,

  ///[ButtonState.SUCCESS] to show the required data.
  SUCCESS,

  ///[ButtonState.ERROR] to show error state
  ERROR,
}
