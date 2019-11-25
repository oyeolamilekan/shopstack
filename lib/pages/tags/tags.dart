import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopstack/blocs/tagsbloc/bloc/tags_bloc.dart';
import 'package:shopstack/blocs/tagsbloc/events/tags_events.dart';
import 'package:shopstack/blocs/tagsbloc/states/tags_state.dart';

class Tags extends StatefulWidget {
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final tagsBloc = TagsBloc();

  @override
  void initState() {
    FetchTags(tagsBloc);
    super.initState();
  }

  Future _call() async {
    FetchTags(tagsBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _call,
        child: BlocBuilder<TagsBloc, ShopTagsState>(
          bloc: tagsBloc,
          builder: (BuildContext context, ShopTagsState state) {
            if (state.state == TagLoadingState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.state == TagLoadingState.none) {
              if (state.tags.length > 0) {
                return ListView.builder(
                  itemCount: state.tags.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    var tags = state.tags[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(tags.name.substring(0,1)),),
                      title: Text('${tags.name}'),
                      subtitle: Text('Product: ${tags.productCount}'),
                      trailing: Icon(Icons.arrow_forward),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('No Data'),
                );
              }
            }
            
            return Center(child:Text('Error loading data.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/createTags');
          try {
            if (result) {
              FetchTags(tagsBloc);
            }
          } catch (e) {}
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
