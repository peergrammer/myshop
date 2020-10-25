import 'package:flutter/material.dart';
import 'package:myshop/screens/auth_screen.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/order_screen.dart';
import './screens/user_products_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Auth();
          },
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: null,
          update: (context, auth, previousProducts) => ProductsProvider(
              auth.token,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Cart();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Orders();
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, value, child) {
          return MaterialApp(
            title: 'MyShop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.purple,
              accentColor: Colors.deepOrange,
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: value.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen()
            },
          );
        },
      ),
    );
  }
}
