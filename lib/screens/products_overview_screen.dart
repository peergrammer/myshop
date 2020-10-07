import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';

enum FilterOption {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsContainer =
        Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption value) {
              if (value == FilterOption.Favorites) {
                productsContainer.showFavoritesOnly();
              } else {
                productsContainer.showAll();
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text(
                    'Only Favorites',
                  ),
                  value: FilterOption.Favorites,
                ),
                PopupMenuItem(
                  child: Text(
                    'Show All',
                  ),
                  value: FilterOption.All,
                ),
              ];
            },
            icon: Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
      body: ProductsGrid(),
    );
  }
}
