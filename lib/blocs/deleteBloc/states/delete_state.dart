enum DeleteProductLoadingState { none, loading, error, success }

class DeleteProductState {
  DeleteProductLoadingState state = DeleteProductLoadingState.none;

  DeleteProductState.initial();

  DeleteProductState(DeleteProductState currentState) {
    this.state = currentState.state;
  }
}
