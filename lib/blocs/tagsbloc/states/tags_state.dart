
import 'package:shopstack/blocs/tagsbloc/models/tags_models.dart';

enum TagLoadingState { none, loading, error }

class ShopTagsState {
  List<ShopTags> tags = [];


  TagLoadingState state = TagLoadingState.loading;
  
  ShopTagsState.initial();

  ShopTagsState(ShopTagsState currentState){
    this.tags = currentState.tags;
    this.state = currentState.state;
  }
}
