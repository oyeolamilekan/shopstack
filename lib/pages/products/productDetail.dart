import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopstack/blocs/deleteBloc/bloc/delete_bloc.dart';
import 'package:shopstack/blocs/deleteBloc/events/delete_events.dart';
import 'package:shopstack/blocs/deleteBloc/states/delete_state.dart';
import 'package:shopstack/blocs/productBloc/models/product_models.dart';
import 'package:shopstack/pages/products/editProduct.dart';
import 'package:shopstack/widgets/modal.dart';

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  ProductData productData;
  Modal modal = Modal();
  @override
  Widget build(BuildContext context) {
    print(productData);
    ProductData args = productData == null
        ? ModalRoute.of(context).settings.arguments
        : productData;
    Widget button = Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.0),
        child: Container(
          height: 40.0,
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            child: Text(
              'Edit Product',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              try {
                final result = await Navigator.pushNamed(
                    context, '/editProduct',
                    arguments: EditProductData(product: args.product));
                if (result != null && result != false) {
                  productData = ProductData(
                      product:
                          Results.fromJson(json.decode(result)['product']));
                  setState(() {});
                } else if (!result) {
                  modal.mainBottomSheet(context,
                      "Kindly check your internet connection.", Icons.cancel);
                }
              } catch (e) {
                print(e);
              }
            },
            color: Colors.green,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('${args.product.name}'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(4.0),
              width: double.infinity,
              child: Card(
                elevation: 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    ProductImage(args: args),
                    Divider(),
                    ProductPrice(args: args),
                    Divider(),
                    ProductTag(args: args),
                    Divider(),
                    ProductStatus(),
                    Divider(),
                    ProductLabel(),
                    ProductDescription(args: args),
                    DeleteButton(args: args),
                    button
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class EditButton extends StatefulWidget {
  const EditButton({Key key, @required this.args}) : super(key: key);

  final Results args;

  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class DeleteButton extends StatefulWidget {
  const DeleteButton({
    Key key,
    @required this.args,
  }) : super(key: key);

  final ProductData args;

  @override
  _DeleteButtonState createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  DeleteBloc deleteBloc = DeleteBloc();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.0),
        child: Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              child: Text(
                'Delete Product',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlocBuilder(
                          bloc: deleteBloc,
                          builder:
                              (BuildContext context, DeleteProductState state) {
                            if (state.state == DeleteProductLoadingState.none) {
                              return AlertDialog(
                                content: Text(
                                    'Are you sure you want to delete: ${widget.args.product.name}?'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      DeleteProduct(
                                          deleteBloc, widget.args.product.id);
                                    },
                                  )
                                ],
                              );
                            } else if (state.state ==
                                DeleteProductLoadingState.error) {
                              return AlertDialog(
                                content: Text(
                                    'Sorry was not able to delete: ${widget.args.product.name}?',
                                    style: TextStyle(color: Colors.red)),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Try again'),
                                    onPressed: () {
                                      DeleteProduct(
                                          deleteBloc, widget.args.product.id);
                                    },
                                  )
                                ],
                              );
                            } else if (state.state ==
                                DeleteProductLoadingState.loading) {
                              return AlertDialog(
                                title: Center(
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                        width: 30,
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text('Deleteting')
                                    ],
                                  ),
                                ),
                              );
                            } else if (state.state ==
                                DeleteProductLoadingState.success) {
                              Navigator.of(context).pop();
                              Navigator.pop(context, true);
                            }
                            return SizedBox();
                          });
                    });
              },
              color: Colors.red,
            )),
      ),
    );
  }
}

class ProductLabel extends StatelessWidget {
  const ProductLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Description'),
    );
  }
}

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key key,
    @required this.args,
  }) : super(key: key);

  final ProductData args;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text('${args.product.description.trim()}', textAlign: TextAlign.right)
        ],
      ),
    );
  }
}

class ProductTag extends StatelessWidget {
  const ProductTag({
    Key key,
    @required this.args,
  }) : super(key: key);

  final ProductData args;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[Text('Tag'), Text('${args.product.genre.name}')],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class ProductStatus extends StatelessWidget {
  const ProductStatus({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[Text('Status'), Text('Available')],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    Key key,
    @required this.args,
  }) : super(key: key);

  final ProductData args;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[Text('Price'), Text('N${args.product.price}')],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
    Key key,
    @required this.args,
  }) : super(key: key);

  final ProductData args;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Hero(
            tag: '${args.product.image}',
            child: Image.network('${args.product.image}')),
        width: 210,
        height: 210,
      ),
    );
  }
}

class ProductData {
  final Results product;
  ProductData({this.product});
}
