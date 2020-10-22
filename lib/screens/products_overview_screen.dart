import 'package:flutter/material.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/app_drawer.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOption {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    /* final productsContainer =
        Provider.of<ProductsProvider>(context, listen: false); */
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption value) {
              setState(() {
                if (value == FilterOption.Favorites) {
                  /* productsContainer.showFavoritesOnly(); */
                  _showOnlyFavorites = true;
                } else {
                  /* productsContainer.showAll(); */
                  _showOnlyFavorites = false;
                }
              });
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
          ),
          Consumer<Cart>(
            builder: (context, value, child) {
              return Badge(
                value: value.itemCount.toString(),
                child: child,
              );
            },
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
