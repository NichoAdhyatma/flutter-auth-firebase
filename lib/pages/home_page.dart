import 'package:flutter/material.dart';
import 'package:flutter_auth/providers/auth.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../pages/add_product_page.dart';
import '../widgets/product_item.dart';

class HomePage extends StatefulWidget {
  static const route = "/home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      isLoading = true;
      Provider.of<Products>(context, listen: false).inisialData().then((_) {
        setState(() {
          isLoading = false;
        });
      }).catchError(
        (err) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error Occured"),
                content: Text("Error is $err"),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Okay"),
                  ),
                ],
              );
            },
          );
        },
      );

      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: (isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (prov.allProduct.isEmpty)
              ? const Center(
                  child: Text(
                    "No Data",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: prov.allProduct.length,
                  itemBuilder: (context, i) => ProductItem(
                    prov.allProduct[i].id,
                    prov.allProduct[i].title,
                    prov.allProduct[i].price,
                    prov.allProduct[i].updatedAt,
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddProductPage.route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
