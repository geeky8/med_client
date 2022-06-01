/// [StoreState] for managing states of store.
// ignore_for_file: constant_identifier_names

enum StoreState {
  ///[StoreState.LOADING] to check loading state and show progressIndicator.
  LOADING,

  ///[StoreState.SUCCESS] to show the required data.
  SUCCESS,

  ///[StoreState.ERROR] to check for error in fetching data.
  ERROR,

  ///[StoreState.EMPTY] to check whether data fecthed is empty or not.
  EMPTY,
}
