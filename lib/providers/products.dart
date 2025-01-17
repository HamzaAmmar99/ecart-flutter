import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:ecart/models/period.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/seller.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [
    // Product(
    //   discountPercentage: 10,
    //   id: 'p2',
    //   ownerId: 'o1',
    //   title: 'Galaxy s21 ultra',
    //   price: 2713750,
    //   imageUrls: [
    //     'https://www.sbsmobile.com/che/183326-thickbox_default/vanity-stars-cover-for-samsung-galaxy-s21-ultra.jpg',
    //     'https://www.slickwraps.com/media/catalog/product/cache/1/image/580x580/9df78eab33525d08d6e5fb8d27136e95/g/a/galaxys21_ultra_color_mattewhite_1.jpg',
    //     'https://eu.etoren.com/upload/images/0.54708900_1610874973_samsung-galaxy-s21-ultra-leather-phone-cover-black.jpg',
    //   ],
    //   description:
    //       "The highest resolution photos and video on a smartphone Galaxy's fastest processor yet A battery that goes all-day—and then some First ever S Pen compatibility A striking new design It's an Ultra that easily lives up to its name",
    //   category: 'Electronics',
    //   type: 'Phones',
    //   warranty: Period(type: TimeType.years, period: 1),
    //   replacement: Period(type: TimeType.months, period: 1),
    //   returning: Period(type: TimeType.days, period: 0),
    //   colorsAndQuantityAndSizes: {
    //     Color(0xFF352333): {
    //       '0': 15,
    //     },
    //     Color(0xFF828282): {
    //       '0': 50,
    //     },
    //     Color(0xFF333333): {
    //       '0': 52,
    //     },
    //     Color(0xFF999999): {
    //       '0': 11,
    //     },
    //     Color(0xFF000000): {
    //       '0': 19,
    //     },
    //   },
    //   specs: {
    //     'NETWORK':
    //         'GSM 850 / 900 / 1800 / 1900 - SIM 1 & SIM 2 (Dual SIM model only)',
    //     'LAUNCH': '2021, January 14',
    //     'BODY': '165.1 x 75.6 x 8.9 mm (6.5 x 2.98 x 0.35 in)',
    //     'DISPLAY': 'Dynamic AMOLED 2X, 120Hz, HDR10+, 1500 nits (peak)',
    //     'PLATFORM': 'Android 11, One UI 3.1',
    //     'MEMORY':
    //         '128GB 12GB RAM, 256GB 12GB RAM, 512GB 12GB RAM, 512GB 16GB RAM',
    //     'COMMS': 'Wi-Fi 802.11 a/b/g/n/ac/6e, dual-band, Wi-Fi Direct, hotspot',
    //     'BATTERY': 'Li-Ion 5000 mAh, non-removable',
    //   },
    // ),
    // Product(
    //   id: 'p1',
    //   ownerId: 'o1',
    //   title: 'Adidas',
    //   price: 30,
    //   imageUrls: [
    //     'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //     'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //     'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ],
    //   description:
    //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    //   category: 'Other',
    //   warranty: Period(type: TimeType.days, period: 3),
    //   replacement: Period(type: TimeType.days, period: 3),
    //   returning: Period(type: TimeType.days, period: 3),
    //   colorsAndQuantityAndSizes: {
    //     Color(0xFF323143): {
    //       '10': 2,
    //       '20': 3,
    //     },
    //     Color(0xFF111349): {
    //       '5': 4,
    //       '7': 5,
    //     },
    //     Color(0xFF113433): {
    //       '19': 6,
    //       '2': 7,
    //     },
    //     Color(0xFF442365): {
    //       '18': 8,
    //       '2': 9,
    //     },
    //   },
    //   specs: {
    //     'color': 'blue',
    //     'size': '42 + 43',
    //     'other': 'running shoes',
    //   },
    // ),
    // Product(
    //   id: 'p15',
    //   ownerId: 'o1',
    //   title: 'Adidas',
    //   price: 30,
    //   imageUrls: [
    //     'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //     'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //     'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ],
    //   description:
    //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    //   category: 'Other',
    //   warranty: Period(type: TimeType.days, period: 3),
    //   replacement: Period(type: TimeType.days, period: 3),
    //   returning: Period(type: TimeType.days, period: 3),
    //   colorsAndQuantityAndSizes: {
    //     Color(0xFF323143): {
    //       '10': 2,
    //       '20': 3,
    //     },
    //     Color(0xFF111349): {
    //       '5': 4,
    //       '7': 5,
    //     },
    //     Color(0xFF113433): {
    //       '19': 6,
    //       '2': 7,
    //     },
    //     Color(0xFF442365): {
    //       '18': 8,
    //       '2': 9,
    //     },
    //   },
    //   specs: {
    //     'color': 'blue',
    //     'size': '42 + 43',
    //     'other': 'running shoes',
    //   },
    // ),
  ];
  String _token;
  String _userId;

  void setToken(String token) {
    _token = token;
  }

  void setUserId(String id) {
    _userId = id;
  }

  List<Product> get products => [..._products];

  void addProductToList(Product product) {
    if(_products.indexWhere((element) => element.id == product.id) == -1)
    _products.add(product);
  }

  Future<Product> findId(String id) async {
    // fetch by id
    final url = Uri.parse('https://hamdi1234.herokuapp.com/product/$id');
    final response = await http.get(url, headers: {
      'usertype': 'vendor',
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': _token,
    });
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      final responseColorsAndQuantityAndSizes =
          responseData['colorsAndQuantityAndSizes'] as List;
      Map<Color, Map<String, int>> colorsAndQuantityAndSizes = {};
      responseColorsAndQuantityAndSizes.forEach((element) {
        colorsAndQuantityAndSizes.putIfAbsent(Color(element['color']), () {
          final responseSizesAndQuantity = element['sizesAndQuantity'] as List;
          Map<String, int> sizesAndQuantity = {};
          responseSizesAndQuantity.forEach((secondElement) {
            sizesAndQuantity.putIfAbsent(
                secondElement['size'], () => secondElement['quantity']);
          });
          return sizesAndQuantity;
        });
      });
      final responseSpecs = responseData['specs'] as Map;
      Map<String, String> specs = {};
      responseSpecs.forEach((key, value) {
        specs.putIfAbsent(key, () => value);
      });
      final responseImages = responseData['images'] as List;
      List<String> images = [];
      responseImages.forEach((element) {
        images.add(element);
      });
      final product = Product(
        id: responseData['_id'],
        title: responseData['name'],
        price: double.parse(responseData['price'].toString()),
        colorsAndQuantityAndSizes: colorsAndQuantityAndSizes,
        warranty: Period(type: TimeType.years, period: 2),
        returning: Period(type: TimeType.weeks, period: 2),
        replacement: Period(type: TimeType.weeks, period: 3),
        category: responseData['category'],
        type: responseData['type'],
        description: responseData['discription'],
        discountPercentage: double.parse(responseData['discount'].toString()),
        specs: specs,
        imageUrls: images,
        ownerId: responseData['owner'],
      );
      return product;
    } else {
      throw HttpException(response.body);
    }
  }

  Future<List<Product>> fetchByCategory(String category) async {
    final url =
        Uri.parse("https://hamdi1234.herokuapp.com/product?category=$category");
    final response = await http.get(url, headers: {
      'usertype': 'vendor',
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': _token,
    });
    final responseData = json.decode(response.body) as List;
    List<Product> typeProducts = [];
    if (response.statusCode == 200) {
      responseData.forEach((element) {
        final responseColorsAndQuantityAndSizes =
            element['colorsAndQuantityAndSizes'] as List;
        Map<Color, Map<String, int>> colorsAndQuantityAndSizes = {};
        responseColorsAndQuantityAndSizes.forEach((secondElement) {
          colorsAndQuantityAndSizes.putIfAbsent(Color(secondElement['color']),
              () {
            final responseSizesAndQuantity =
                secondElement['sizesAndQuantity'] as List;
            Map<String, int> sizesAndQuantity = {};
            responseSizesAndQuantity.forEach((thirdElement) {
              sizesAndQuantity.putIfAbsent(
                  thirdElement['size'], () => thirdElement['quantity']);
            });
            return sizesAndQuantity;
          });
        });
        final responseSpecs = element['specs'] as Map;
        Map<String, String> specs = {};
        responseSpecs.forEach((key, value) {
          specs.putIfAbsent(key, () => value);
        });
        final responseImages = element['images'] as List;
        List<String> images = [];
        responseImages.forEach((element) {
          images.add(element);
        });
        final product = Product(
          id: element['_id'],
          title: element['name'],
          price: double.parse(element['price'].toString()),
          colorsAndQuantityAndSizes: colorsAndQuantityAndSizes,
          warranty: Period(type: TimeType.months, period: 0),
          returning: Period(type: TimeType.months, period: 0),
          replacement: Period(type: TimeType.months, period: 0),
          category: element['category'],
          type: element['type'],
          description: element['discription'],
          discountPercentage: double.parse(element['discount'].toString()),
          specs: specs,
          imageUrls: images,
          ownerId: element['owner'],
        );
        addProductToList(product);
        typeProducts.add(product);
      });
    } else {
      throw HttpException(response.body);
    }
    // notifyListeners();
    return typeProducts;
  }

  Future<List<Product>> fetchByType(String type) async {
    final url = Uri.parse(
        "https://hamdi1234.herokuapp.com/getProductByType?type=$type");
    final response = await http.get(url, headers: {
      'usertype': 'vendor',
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': _token,
    });
    final responseData = json.decode(response.body) as List;
    List<Product> typeProducts = [];
    if (response.statusCode == 200) {
      responseData.forEach((element) {
        final responseColorsAndQuantityAndSizes =
            element['colorsAndQuantityAndSizes'] as List;
        Map<Color, Map<String, int>> colorsAndQuantityAndSizes = {};
        responseColorsAndQuantityAndSizes.forEach((secondElement) {
          colorsAndQuantityAndSizes.putIfAbsent(Color(secondElement['color']),
              () {
            final responseSizesAndQuantity =
                secondElement['sizesAndQuantity'] as List;
            Map<String, int> sizesAndQuantity = {};
            responseSizesAndQuantity.forEach((thirdElement) {
              sizesAndQuantity.putIfAbsent(
                  thirdElement['size'], () => thirdElement['quantity']);
            });
            return sizesAndQuantity;
          });
        });
        final responseSpecs = element['specs'] as Map;
        Map<String, String> specs = {};
        responseSpecs.forEach((key, value) {
          specs.putIfAbsent(key, () => value);
        });
        final responseImages = element['images'] as List;
        List<String> images = [];
        responseImages.forEach((element) {
          images.add(element);
        });
        final product = Product(
          id: element['_id'],
          title: element['name'],
          price: double.parse(element['price'].toString()),
          colorsAndQuantityAndSizes: colorsAndQuantityAndSizes,
          warranty: Period(type: TimeType.months, period: 0),
          returning: Period(type: TimeType.months, period: 0),
          replacement: Period(type: TimeType.months, period: 0),
          category: element['category'],
          type: element['type'],
          description: element['discription'],
          discountPercentage: double.parse(element['discount'].toString()),
          specs: specs,
          imageUrls: images,
          ownerId: element['owner'],
        );
        addProductToList(product);
        typeProducts.add(product);
      });
    } else {
      throw HttpException(response.body);
    }
    // notifyListeners();
    return typeProducts;
  }

  List<Product> getFavorites() {
    List<Product> favorites = [];
    for (int i = 0; i < products.length; i++) {
      if (products[i].isFavorite) {
        favorites.add(products[i]);
      }
    }
    return favorites;
  }

  List<Product> getOffers() {
    List<Product> offers = [];
    for (int i = 0; i < products.length; i++) {
      if (products[i].discountPercentage > 0) {
        offers.add(products[i]);
      }
    }
    return offers;
  }

  Future<List<Product>> fetchBy(String fetchMechanism) async {
    Uri url;
    if (fetchMechanism == 'Most Recent') {
      url = Uri.parse('');
      return [];
    } else if (fetchMechanism == 'Highest Rated') {
      url = Uri.parse('https://hamdi1234.herokuapp.com/productrate');
    } else if (fetchMechanism == 'Best Seller') {
      url = Uri.parse('https://hamdi1234.herokuapp.com/bestsalles');
    }
    final response = await http.get(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
    );
    final responseData = json.decode(response.body) as List;
    List<Product> typeProducts = [];
    if (response.statusCode == 200) {
      responseData.forEach((element) {
        final responseColorsAndQuantityAndSizes =
            element['colorsAndQuantityAndSizes'] as List;
        Map<Color, Map<String, int>> colorsAndQuantityAndSizes = {};
        responseColorsAndQuantityAndSizes.forEach((secondElement) {
          colorsAndQuantityAndSizes.putIfAbsent(Color(secondElement['color']),
              () {
            final responseSizesAndQuantity =
                secondElement['sizesAndQuantity'] as List;
            Map<String, int> sizesAndQuantity = {};
            responseSizesAndQuantity.forEach((thirdElement) {
              sizesAndQuantity.putIfAbsent(
                  thirdElement['size'], () => thirdElement['quantity']);
            });
            return sizesAndQuantity;
          });
        });
        final responseSpecs = element['specs'] as Map;
        Map<String, String> specs = {};
        responseSpecs.forEach((key, value) {
          specs.putIfAbsent(key, () => value);
        });
        final responseImages = element['images'] as List;
        List<String> images = [];
        responseImages.forEach((element) {
          images.add(element);
        });
        final product = Product(
          id: element['_id'],
          title: element['name'],
          price: double.parse(element['price'].toString()),
          colorsAndQuantityAndSizes: colorsAndQuantityAndSizes,
          warranty: Period(type: TimeType.months, period: 0),
          returning: Period(type: TimeType.months, period: 0),
          replacement: Period(type: TimeType.months, period: 0),
          category: element['category'],
          type: element['type'],
          description: element['discription'],
          discountPercentage: double.parse(element['discount'].toString()),
          specs: specs,
          imageUrls: images,
          ownerId: element['owner'],
        );
        addProductToList(product);
        typeProducts.add(product);
      });
    } else {
      throw HttpException(response.body);
    }
    // notifyListeners();
    return typeProducts;
  }

  List<Product> search(String query) {
    query = query.toLowerCase();
    return products
        .where((element) => element.title.toLowerCase().contains(query))
        .toList();
  }

  List<Product> fetchBySellerRecents() {
    return products;
  }

  void updateRating(String id, double rating) {
    int i = _products.indexWhere((element) => element.id == id);
    _products[i].rating = (_products[i].rating + rating) / 2;
    notifyListeners();
  }

  Seller findSeller() {
    // fetch sellers by ownerId
    return Seller(
      id: 's1',
      name: 'Samsung',
      email: 'apple@gmail.com',
      addresses: ['mazzeh'],
      imageUrl: '',
      items: ['p1'],
      numbers: [0958772317],
      typeOfItems: 'electronics',
    );
  }

  int getProductMaxAmount(
    String id,
    Color _selectedColor,
    String _selectedSize,
  ) {
    return _products
        .firstWhere((element) => element.id == id)
        .colorsAndQuantityAndSizes
        .entries
        .firstWhere((element) => element.key == _selectedColor)
        .value
        .entries
        .firstWhere((element) => element.key == _selectedSize)
        .value;
  }

  void removeFromList(
      {@required String id,
      @required Color color,
      @required int amount,
      String size = '0'}) {
    var productIndex = _products.indexWhere((element) => element.id == id);
    _products[productIndex]
        .colorsAndQuantityAndSizes
        .entries
        .firstWhere((element) => element.key == color)
        .value
        .update(size, (value) => value - amount);
    notifyListeners();
  }

  bool checkIfAvailable(
      {@required String id,
      @required Color color,
      @required int amount,
      String size = '0'}) {
    var productIndex = _products.indexWhere((element) => element.id == id);
    if (_products[productIndex]
            .colorsAndQuantityAndSizes
            .entries
            .firstWhere((element) => element.key == color)
            .value
            .entries
            .firstWhere((element) => element.key == size)
            .value >=
        amount) {
      return true;
    }
    return false;
  }

  void addToList(
      {@required String id,
      @required Color color,
      @required int amount,
      String size = '0'}) {
    var productIndex = _products.indexWhere((element) => element.id == id);
    _products[productIndex]
        .colorsAndQuantityAndSizes
        .entries
        .firstWhere((element) => element.key == color)
        .value
        .update(size, (value) => value + amount);
    notifyListeners();
  }

  int quantityCounter({Product product, int colorsNumber}) {
    int quantity = 0;
    for (int i = 0; i < colorsNumber; i++) {
      for (int j = 0;
          j <
              product.colorsAndQuantityAndSizes.entries
                  .elementAt(i)
                  .value
                  .values
                  .length;
          j++) {
        quantity += product.colorsAndQuantityAndSizes.entries
            .elementAt(i)
            .value
            .values
            .elementAt(j)
            .toInt();
      }
    }
    return quantity;
  }

  void updateProduct(Product product, List<String> img64s) {
    var index = _products.indexWhere((element) => element.id == product.id);
    _products[index] = Product(
      id: product.id,
      title: product.title,
      price: product.price,
      colorsAndQuantityAndSizes: product.colorsAndQuantityAndSizes,
      warranty: product.warranty,
      returning: product.returning,
      replacement: product.replacement,
      category: product.category,
      type: product.type,
      description: product.description,
      discountPercentage: product.discountPercentage,
      specs: product.specs,
      imageUrls: [
        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
        'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      ], //product.imageUrls,
      ownerId: product.ownerId,
      rating: product.rating,
    );

    notifyListeners();
    // log(
    //   json.encode(
    //     {
    //       'id' : product.id,
    //       'images': img64s,
    //       'title': product.title,
    //       'price': product.price,
    //       'colorsAndQuantityAndSizes': product.colorsAndQuantityAndSizes.entries
    //           .map(
    //             (e) => {
    //               'color': e.key.value,
    //               'sizesAndQuantity': e.value.entries
    //                   .map(
    //                     (e) => {
    //                       'size': e.key,
    //                       'quantity': e.value,
    //                     },
    //                   )
    //                   .toList(),
    //             },
    //           )
    //           .toList(),
    //       'warrantyPeriod': product.warranty.period,
    //       'warrantyType': product.warranty.type.toString().split('.').last,
    //       'returningPeriod': product.returning.period,
    //       'returningType': product.returning.type.toString().split('.').last,
    //       'replacementPeriod': product.replacement.period,
    //       'replacementType':
    //           product.replacement.type.toString().split('.').last,
    //       'category': product.category,
    //       'type': product.type,
    //       'description': product.description,
    //       'discountPercentage': product.discountPercentage,
    //       'specs': product.specs,
    //       'rating': product.rating,
    //       'ownerId': product.ownerId,
    //       'imageUrls': product.imageUrls
    //     },
    //   ),
    // );
  }

  // List<String> encodeImages(List<File> images) {
  //   List<String> img64s = [];
  //   for (var i = 0; i < images.length; i++) {
  //     List<int> bytes = images[i].readAsBytesSync().toList();
  //     img64s.add(base64Encode(bytes));
  //   }
  //   return img64s;
  // }

  Future<List<int>> _readFileByte(File image) async {
    List<int> bytes;
    await image.readAsBytes().then((value) {
      bytes = value;
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }

  Future<void> addProduct(Product product, List<File> images) async {
    final List<String> img64s = [];
    for (var i = 0; i < images.length; i++) {
      img64s.add(
        base64Encode(
          await _readFileByte(images[i]),
        ),
      );
    }
    if (product.id != null) {
      updateProduct(product, img64s);
      return;
    }

    // product = Product(
    //   id: '1',
    //   title: product.title,
    //   price: product.price,
    //   colorsAndQuantityAndSizes: product.colorsAndQuantityAndSizes,
    //   warranty: product.warranty,
    //   returning: product.returning,
    //   replacement: product.replacement,
    //   category: product.category,
    //   type: product.type,
    //   description: product.description,
    //   discountPercentage: product.discountPercentage,
    //   specs: product.specs,
    //   imageUrls: [
    //     'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //     'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //     'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ],
    //   ownerId: 'h1',
    // );
    // _products.add(product);
    // notifyListeners();
    final url = Uri.parse("https://hamdi1234.herokuapp.com/product");
    var response = await http.post(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': _token,
      },
      body: json.encode(
        {
          'images': img64s,
          'name': product.title,
          'price': product.price,
          'colorsAndQuantityAndSizes': product.colorsAndQuantityAndSizes.entries
              .map(
                (e) => {
                  'color': e.key.value,
                  'sizesAndQuantity': e.value.entries
                      .map(
                        (e) => {
                          'size': e.key,
                          'quantity': e.value,
                        },
                      )
                      .toList(),
                },
              )
              .toList(),
          'warranty_period': product.warranty.period,
          'warrantyType': product.warranty.type.toString().split('.').last,
          'returning_period': product.returning.period,
          'returningType': product.returning.type.toString().split('.').last,
          'replacing_period': product.replacement.period,
          'replacementType':
              product.replacement.type.toString().split('.').last,
          'category': product.category,
          'type': product.type,
          'discription': product.description,
          'discountPercentage': product.discountPercentage,
          'specs': product.specs,
          'rating': product.rating,
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = json.decode(response.body);
      //////
      ///
      ///
      notifyListeners();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      var responseData = json.decode(response.body);
      print(responseData);
      throw HttpException(responseData);
    }
  }

  Future<List<Product>> premiumAllProducts() async {
    final url =
        Uri.parse("https://hamdi1234.herokuapp.com/productowner/$_userId");
    final response = await http.get(url, headers: {
      'usertype': 'vendor',
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': _token,
    });
    final responseData = json.decode(response.body) as List;
    List<Product> typeProducts = [];
    if (response.statusCode == 200) {
      responseData.forEach((element) {
        final responseColorsAndQuantityAndSizes =
            element['colorsAndQuantityAndSizes'] as List;
        Map<Color, Map<String, int>> colorsAndQuantityAndSizes = {};
        responseColorsAndQuantityAndSizes.forEach((secondElement) {
          colorsAndQuantityAndSizes.putIfAbsent(Color(secondElement['color']),
              () {
            final responseSizesAndQuantity =
                secondElement['sizesAndQuantity'] as List;
            Map<String, int> sizesAndQuantity = {};
            responseSizesAndQuantity.forEach((thirdElement) {
              sizesAndQuantity.putIfAbsent(
                  thirdElement['size'], () => thirdElement['quantity']);
            });
            return sizesAndQuantity;
          });
        });
        final responseSpecs = element['specs'] as Map;
        Map<String, String> specs = {};
        responseSpecs.forEach((key, value) {
          specs.putIfAbsent(key, () => value);
        });
        final responseImages = element['images'] as List;
        List<String> images = [];
        responseImages.forEach((element) {
          images.add(element);
        });
        final product = Product(
          id: element['_id'],
          title: element['name'],
          price: double.parse(element['price'].toString()),
          colorsAndQuantityAndSizes: colorsAndQuantityAndSizes,
          warranty: Period(type: TimeType.months, period: 0),
          returning: Period(type: TimeType.months, period: 0),
          replacement: Period(type: TimeType.months, period: 0),
          category: element['category'],
          type: element['type'],
          description: element['discription'],
          discountPercentage: double.parse(element['discount'].toString()),
          specs: specs,
          imageUrls: images,
          ownerId: element['owner'],
        );
        typeProducts.add(product);
      });
    } else {
      throw HttpException(response.body);
    }
    // notifyListeners();
    return typeProducts;
  }
}
