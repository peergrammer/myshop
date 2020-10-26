import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  /* var _showFavoritesOnly = false; */

  List<Product> get items {
    /*   if (_showFavoritesOnly) {
      return _items.where((element) => element.isFavorite).toList();
    } */
    return [..._items];
  }

  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  /* void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }
 */
  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProduct() async {
    final url =
        'https://myshop-77af8.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extracted = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extracted == null) {
        return;
      }

      final urlFavorites =
          'https://myshop-77af8.firebaseio.com/userfavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(urlFavorites);
      final favoriteData = json.decode(favoriteResponse.body);

      extracted.forEach((key, prod) {
        loadedProducts.add(Product(
          id: key,
          title: prod['title'],
          price: prod['price'],
          description: prod['description'],
          isFavorite: favoriteData == null ? false : favoriteData[key] ?? false,
          imageUrl: prod['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://myshop-77af8.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://myshop-77af8.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {}
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://myshop-77af8.firebaseio.com/products/$id.json?auth=$authToken';
    final response = await http.delete(url);
    _items.removeWhere((element) => element.id == id);
    print(response.body);
    notifyListeners();
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }
}
