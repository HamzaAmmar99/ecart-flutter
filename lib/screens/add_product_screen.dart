import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/period.dart';

import '../widgets/image_input.dart';
import '../widgets/colors_picker.dart';
import '../widgets/add_image_viewer.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add-product';

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _form = GlobalKey<FormState>();

  String title;
  double price;
  String description;
  double discount;
  bool discountValidate = false;

  Map<Color, Map<String, int>> colorsAndQuantity = {};
  bool hasSizes = true;

  Period warranty = Period(
    type: TimeType.weeks,
  );
  Period replaceable = Period(
    type: TimeType.weeks,
  );
  Period returnable = Period(
    type: TimeType.weeks,
  );

  Category category;
  Type type;

  List<File> images = [];

  Map<String, String> specs = {};

  var product = Product();

  var _init = true;

  List<Widget> imageSlider = [];

  void setSlider(File image) {
    imageSlider.add(Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Image.file(
          image,
          fit: BoxFit.cover,
        ),
      ),
    ));
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        product = Provider.of<ProductsProvider>(context).findId(id);
        title = product.title;
        price = product.price;
        description = product.description;
        discount = product.discountPercentage;
        colorsAndQuantity = product.colorsAndQuantityAndSizes;
        if (product.colorsAndQuantityAndSizes.entries.first.value.entries.first
                .key ==
            '0') hasSizes = false;
        warranty = product.warranty;
        returnable = product.returning;
        replaceable = product.replacement;
        category = categories
            .firstWhere((element) => element.title == product.category);
        if (category.types != null && product.type != null)
          type = category.types
              .firstWhere((element) => element.title == product.type);
        specs = product.specs;
        imageSlider.addAll(product.imageUrls.map((e) => Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: CachedNetworkImage(
                  imageUrl: e,
                  fit: BoxFit.cover,
                ),
              ),
            )));
      }
      _init = false;
    }
    super.didChangeDependencies();
  }

  void saveForm() {
    if (product.id == null && images.isEmpty) {
      showSnakBarError('At least one image must be added !');
      return;
    }
    if (colorsAndQuantity.isEmpty) {
      showSnakBarError('At least one color must be added !');
      return;
    }
    if (category == null) {
      showSnakBarError('Please select a category !');
      return;
    } else if (category.types.length != 0 && type == null) {
      showSnakBarError('Please select a type !');
      return;
    }

    if (!_form.currentState.validate() && discountValidate) return;
    _form.currentState.save();
    product = Product(
      id: product.id,
      title: title,
      price: price,
      colorsAndQuantityAndSizes: colorsAndQuantity,
      warranty: warranty,
      returning: returnable,
      replacement: replaceable,
      category: category.title,
      type: type == null ? '' : type.title,
      description: description,
      discountPercentage: discount,
      specs: specs,
      imageUrls: product.imageUrls,
      ownerId: product.ownerId,
    );
    Provider.of<ProductsProvider>(context, listen: false).addProduct(
      product,
      images,
    );
    Navigator.of(context).pop();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnakBarError(
      String error) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  void setImage(File image) {
    images.add(image);
    setState(() {
      setSlider(image);
    });
  }

  void addColor(Color color, int quantity) {
    setState(() {
      if (colorsAndQuantity.containsKey(color))
        colorsAndQuantity[color] = {'0': quantity};
      colorsAndQuantity.putIfAbsent(color, () => {'0': quantity});
    });
  }

  void addColorWithSizes(Color color, Map<String, int> sizesAndQuantity) {
    setState(() {
      if (colorsAndQuantity.containsKey(color))
        colorsAndQuantity[color] = sizesAndQuantity;
      colorsAndQuantity.putIfAbsent(color, () => sizesAndQuantity);
    });
  }

  Widget periodAddingBuilder(String title, Period period) {
    return Container(
      height: 50,
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Spacer(),
          DropdownButton(
            value: period.period,
            items: period
                .typeOptions()
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(
                      e.toString(),
                    ),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                period.period = value;
              });
            },
          ),
          SizedBox(
            width: 14,
          ),
          DropdownButton(
            value: period.type,
            items: TimeType.values
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(
                      e.toString().split('.').last,
                    ),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (period.type != value) {
                period.period = 0;
                setState(() {
                  period.type = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Product Details',
          ),
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.save),
              onPressed: saveForm,
            )
          ],
        ),
        body: Form(
          key: _form,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageSlider.length != 0) AddImageViewer(imageSlider),
                ImageInput(setImage),
                TextFormField(
                  initialValue: title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    value.trim();
                    if (value.isEmpty) return "This can't be empty";
                    return null;
                  },
                  onSaved: (value) {
                    value.trim();
                    title = value;
                  },
                ),
                TextFormField(
                  initialValue: price != null ? price.toString() : null,
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    value.trim();
                    if (value.isEmpty) return "This can't be empty";
                    if (double.tryParse(value) == null)
                      return "Invalid input!!";
                    return null;
                  },
                  onSaved: (value) {
                    value.trim();
                    price = double.parse(value);
                  },
                ),
                SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text('Multple Sizes'),
                  activeColor: Theme.of(context).primaryColor,
                  value: hasSizes,
                  onChanged: (value) {
                    if (colorsAndQuantity.isEmpty)
                      setState(() {
                        hasSizes = value;
                      });
                    else
                      showSnakBarError('colors must be empty first !');
                  },
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text('COLORS LISTVIEW HERE '),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => !hasSizes
                            ? ColorsPicker(addColor, hasSizes)
                            : ColorsPicker(addColorWithSizes, hasSizes));
                  },
                  child: const Text('Add Color'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                ),
                TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  maxLines: 8,
                  validator: (value) {
                    value.trim();
                    if (value.isEmpty) return "This can't be empty";
                    return null;
                  },
                  onSaved: (value) {
                    value.trim();
                    description = value;
                  },
                ),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      DropdownButton(
                        value: category,
                        hint: Text('select a category'),
                        items: categories
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(e.title),
                                value: e,
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (category != value) {
                            type = null;
                            setState(() {
                              category = value;
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
                if (category != null && category.types.length != 0)
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Type',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        DropdownButton(
                          value: type,
                          hint: Text('select a type'),
                          items: category.types
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e.title),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              type = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                periodAddingBuilder('Warranty', warranty),
                periodAddingBuilder('Replaceable', replaceable),
                periodAddingBuilder('Returnable', returnable),
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Text(
                        'Discount',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Spacer(),
                      Container(
                        width: 40,
                        height: 20,
                        child: TextFormField(
                          initialValue:
                              discount != null ? discount.toString() : null,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorMaxLines: 1,
                          ),
                          validator: (value) {
                            value.trim();
                            if (value.isEmpty ||
                                value.characters.every(
                                  (element) => element == ' ',
                                )) {
                              discountValidate = true;
                              return null;
                            }
                            if (double.tryParse(value) == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Discount must be a number"),
                                backgroundColor: Theme.of(context).errorColor,
                              ));
                              return null;
                            } else if (double.parse(value) > 100 ||
                                double.parse(value) < 0) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Discount Invalid Input !"),
                                backgroundColor: Theme.of(context).errorColor,
                              ));
                              return null;
                            }
                            discountValidate = true;
                            return null;
                          },
                          onSaved: (value) {
                            value.trim();
                            if (value == '') {
                              discount = 0;
                              return;
                            }
                            if (value != null) discount = double.parse(value);
                          },
                        ),
                      ),
                      Text('%'),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Specifications:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                if (specs.length != 0)
                  ...specs.entries
                      .map((e) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 14),
                            height: 35,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  '${e.key}: ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  e.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                                Spacer(),
                                IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: Icon(Icons.edit_outlined),
                                    onPressed: () {
                                      addSpecDialog(
                                        context,
                                        initName: e.key,
                                        initValue: e.value,
                                      );
                                    })
                              ],
                            ),
                          ))
                      .toList(),
                ElevatedButton(
                  onPressed: () {
                    addSpecDialog(context);
                  },
                  child: const Text('Add Specification'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future addSpecDialog(
    BuildContext context, {
    String initName,
    String initValue,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final _specForm = GlobalKey<FormState>();
          String _specName;
          String _specValue;
          void _save() {
            if (!_specForm.currentState.validate()) return;
            _specForm.currentState.save();
            Navigator.of(context).pop();
            setState(() {
              if (initName != null) specs.remove(initName);
              specs.putIfAbsent(_specName, () => _specValue);
            });
          }

          return Form(
            key: _specForm,
            child: AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      _save();
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: initName,
                    decoration:
                        InputDecoration(labelText: 'Specification Name'),
                    cursorColor: Color(0xFF333333),
                    validator: (value) {
                      value.trim();
                      if (value.isEmpty) return 'This can\'t be empty';
                      return null;
                    },
                    onSaved: (value) {
                      value.trim();
                      _specName = value;
                    },
                  ),
                  TextFormField(
                    initialValue: initValue,
                    decoration: InputDecoration(labelText: 'Value'),
                    cursorColor: Color(0xFF333333),
                    validator: (value) {
                      value.trim();
                      if (value.isEmpty) return 'This can\'t be empty';
                      return null;
                    },
                    onSaved: (value) {
                      value.trim();
                      _specValue = value;
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
