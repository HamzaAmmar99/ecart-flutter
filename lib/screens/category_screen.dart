import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../models/product.dart';
import '../models/category.dart';
import '../widgets/product_item.dart';
//import '../widgets/home_suggestion_item.dart';
import '../widgets/types_row.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/category';

  @override
  Widget build(BuildContext context) {
    final Category category =
        ModalRoute.of(context).settings.arguments as Category;
    final List<Product> products =
        Provider.of<ProductsProvider>(context).fetchByCategory(category.title);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (category.types.length == 0)
            IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: category.types.length == 0
          ? GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: products[i],
                child: ProductItem(
                  isGridView: true,
                ),
              ),
              itemCount: products.length,
            )
          : ListView(
              children: [
                TypesRow(category.types),
                SizedBox(
                  height: 10,
                ),
                ...category.types
                    .map((e) => Column(
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.of(context).pushNamed(,arguments: );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.title,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward_rounded),
                                      onPressed: () {
                                        // Navigator.of(context).pushNamed(,arguments: );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 190,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3,
                                  itemBuilder: (ctx, index) =>
                                      ChangeNotifierProvider.value(
                                          value: products[index],
                                          child: ProductItem())),
                            ),
                          ],
                        ))
                    .toList()
              ],
            ),
    );
  }
}
