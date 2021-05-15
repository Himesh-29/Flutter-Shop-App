import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_blueprint.dart';
import '../providers/product_provider_blueprint.dart';

class EditProductByUserScreen extends StatefulWidget {
  static const routeName = '/edit-product-by-user-screen';

  @override
  _EditProductByUserScreenState createState() =>
      _EditProductByUserScreenState();
}

class _EditProductByUserScreenState extends State<EditProductByUserScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  var _isInit = true;
  var _pageLoading = false;

  var _initialisedValues = {
    'productName': '',
    'productDescription': '',
    'productPrice': '',
    'productImageURL': '',
  };

  var _editedProduct = ProductBlueprint(
    productId: null,
    productName: '',
    productPrice: 0,
    productDescription: '',
    productImageURL: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductProviderBlueprint>(context, listen: false)
                .findProductById(productId);
        _initialisedValues = {
          'productName': _editedProduct.productName,
          'productDescription': _editedProduct.productDescription,
          'productPrice': _editedProduct.productPrice.toString(),
          'productImageURL': '',
        };
        _imageUrlController.text = _editedProduct.productImageURL;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveFormAndMakeNewProduct() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _pageLoading = true;
    });
    if (_editedProduct.productId != null) {
      await Provider.of<ProductProviderBlueprint>(context, listen: false)
          .updateExistingProduct(_editedProduct.productId, _editedProduct);
    } else {
      try {
        await Provider.of<ProductProviderBlueprint>(context, listen: false)
            .addProductItem(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('An Error occured!'),
                content: Text('Something went wrong!'),
                actions: [
                  TextButton(
                      child: Text('Back to Manage screen'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      })
                ],
              );
            });
      }
    }
    setState(() {
      _pageLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_rounded),
            onPressed: saveFormAndMakeNewProduct,
          )
        ],
      ),
      body: _pageLoading
          ? Container(
              alignment: Alignment.center, child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                  key: _formKey,
                  child: ListView(children: <Widget>[
                    Divider(height: 10),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: TextFormField(
                        initialValue: _initialisedValues['productName'],
                        decoration: InputDecoration(
                          labelText: 'Name of Product',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (valueEnteredInTextFormField) {
                          if (valueEnteredInTextFormField.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please enter valid name of product';
                          }
                        },
                        onSaved: (valueEnteredInTextFormField) {
                          _editedProduct = ProductBlueprint(
                              productId: _editedProduct.productId,
                              productName: valueEnteredInTextFormField,
                              productPrice: _editedProduct.productPrice,
                              productDescription:
                                  _editedProduct.productDescription,
                              isFavourite: _editedProduct.isFavourite,
                              productImageURL: _editedProduct.productImageURL);
                        },
                      ),
                    ),
                    Divider(height: 10),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: TextFormField(
                          initialValue: _initialisedValues['productPrice'],
                          decoration:
                              InputDecoration(labelText: 'Price of Product'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (valueEnteredInTextFormField) {
                            if (double.tryParse(valueEnteredInTextFormField) ==
                                null) {
                              return 'Please enter valid price of product';
                            } else {
                              if (double.parse(valueEnteredInTextFormField) > 0)
                                return null;
                              else
                                return 'Please enter the positive price for the product';
                            }
                          },
                          onSaved: (valueEnteredInTextFormField) {
                            _editedProduct = ProductBlueprint(
                              productId: _editedProduct.productId,
                              productName: _editedProduct.productName,
                              productPrice:
                                  double.parse(valueEnteredInTextFormField),
                              productDescription:
                                  _editedProduct.productDescription,
                              productImageURL: _editedProduct.productImageURL,
                              isFavourite: _editedProduct.isFavourite,
                            );
                          }),
                    ),
                    Divider(height: 10),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: TextFormField(
                        initialValue: _initialisedValues['productDescription'],
                        decoration: InputDecoration(
                            labelText: 'Description of Product'),
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        validator: (valueEnteredInTextFormField) {
                          if (valueEnteredInTextFormField.isEmpty) {
                            return 'Please provide valid description of the product';
                          } else if (valueEnteredInTextFormField.length < 10) {
                            return 'Please provide description at least 10 characters long';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (valueEnteredInTextFormField) {
                          _editedProduct = ProductBlueprint(
                            productId: _editedProduct.productId,
                            productName: _editedProduct.productName,
                            productPrice: _editedProduct.productPrice,
                            productDescription: valueEnteredInTextFormField,
                            productImageURL: _editedProduct.productImageURL,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                    ),
                    Divider(height: 10),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 10, right: 8),
                                child: _imageUrlController.text.isEmpty
                                    ? Text('Enter a URL',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20))
                                    : Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          width: 1,
                                          color: Colors.green,
                                        )),
                                        child: Image.network(
                                            _imageUrlController.text,
                                            fit: BoxFit.cover, errorBuilder:
                                                (BuildContext context,
                                                    Object exception,
                                                    StackTrace stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.red)),
                                            child: Text(
                                              'Couldn\'t render your image, try another URL',
                                            ),
                                          );
                                        }),
                                      )),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                // onFieldSubmitted: (_) {
                                //   saveFormAndMakeNewProduct();
                                // },
                                validator: (valueEnteredInTextFormField) {
                                  if (valueEnteredInTextFormField.isNotEmpty &&
                                      (valueEnteredInTextFormField
                                              .startsWith('http') ||
                                          valueEnteredInTextFormField
                                              .startsWith('https')) &&
                                      (valueEnteredInTextFormField
                                              .endsWith('jpg') ||
                                          valueEnteredInTextFormField
                                              .endsWith('jpeg') ||
                                          valueEnteredInTextFormField
                                              .endsWith('png'))) {
                                    return null;
                                  } else {
                                    return 'Please enter valid image URL of product';
                                  }
                                },
                                onSaved: (valueEnteredInTextFormField) {
                                  _editedProduct = ProductBlueprint(
                                    productId: _editedProduct.productId,
                                    productName: _editedProduct.productName,
                                    productPrice: _editedProduct.productPrice,
                                    productDescription:
                                        _editedProduct.productDescription,
                                    productImageURL:
                                        valueEnteredInTextFormField,
                                    isFavourite: _editedProduct.isFavourite,
                                  );
                                },
                              ),
                            ),
                          ]),
                    ),
                  ])),
            ),
    );
  }
}
