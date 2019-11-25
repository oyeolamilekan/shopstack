import 'package:bloc/bloc.dart';
import 'package:shopstack/blocs/tagsbloc/events/tags_events.dart';
import 'package:shopstack/blocs/tagsbloc/states/tags_state.dart';

class TagsBloc extends Bloc<ShopTagEvent, ShopTagsState> {
  @override
  ShopTagsState get initialState => ShopTagsState.initial();

  @override
  Stream<ShopTagsState> mapEventToState(ShopTagEvent event) async*{
    final newState = ShopTagsState(currentState);
    if (event is FetchTagsLoading) {
      newState.state = TagLoadingState.loading;
      yield newState;
    }
    if (event is FetchTagsFailed){
      newState.state = TagLoadingState.error;
      yield newState;
    }
    if (event is FetchTagsSuccess) {
      newState.state = TagLoadingState.none;
      newState.tags = event.tags;
      yield newState;
    }
  }

}