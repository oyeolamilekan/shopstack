import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopstack/blocs/productBloc/bloc/product_blocs.dart';
import 'package:shopstack/blocs/productBloc/events/product_events.dart';
import 'package:shopstack/blocs/productBloc/models/product_models.dart';
import 'package:shopstack/blocs/productBloc/states/product_state.dart';
import 'package:shopstack/pages/products/productDetail.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final productBloc = ProductBloc();
  final _scrollController = ScrollController();
  var isNext;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    FetchProducts(productBloc);
    super.initState();
  }

  Future _call() async {
    FetchProducts(productBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _call,
        child: BlocBuilder<ProductBloc, ProductState>(
          bloc: productBloc,
          builder: (BuildContext context, ProductState state) {
            if (state.state == ProductLoadingState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.state == ProductLoadingState.none) {
              final products = state.products.results;
              isNext = state.products.next;
              if (products.length > 0) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= products.length
                        ? Center(child: CircularProgressIndicator())
                        : BuildProducts(
                            product: products[index],
                            productBloc: productBloc,
                          );
                  },
                  itemCount:
                      isNext == null ? products.length : products.length + 1,
                  controller: _scrollController,
                );
              } else {
                return Center(
                  child: Text('No products.'),
                );
              }
            }
            return Center(
              child: Text('Error loading data'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var result = await Navigator.pushNamed(context, "/createProduct");
          if (result == true) {
            FetchProducts(productBloc);
          } else {
            FetchProducts(productBloc);
          }
        },
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter == 0) {
      if (isNext != null) {
        FetchProductsNext(productBloc);
      }
    }
  }
}

class BuildProducts extends StatelessWidget {
  const BuildProducts(
      {Key key, @required this.product, @required this.productBloc})
      : super(key: key);

  final Results product;
  final ProductBloc productBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        ListTile(
          title: Text(
              '${product.name.length >= 20 ? product.name.substring(0, 10) + '....' : product.name}'),
          leading: Padding(
              padding: const EdgeInsets.only(bottom: 19),
              child: Hero(
                  tag: '${product.image}',
                  child: Image.network(product.image))),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(product.price),
              Transform(
                transform: new Matrix4.identity()..scale(0.79),
                child: Chip(
                  label: Text(
                    'Available',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.greenAccent,
                ),
              )
            ],
          ),
          onTap: () async {
            final result = await Navigator.pushNamed(context, '/productDetail',
                arguments: ProductData(product: product));
            if (result == true) {
              FetchProducts(productBloc);
            } else {
              FetchProducts(productBloc);
            }
          },
        ),
        // Center(child: CircularProgressIndicator(),)
      ],
    );
  }
}
