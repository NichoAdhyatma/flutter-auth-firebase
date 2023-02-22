import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class EditProductPage extends StatelessWidget {
  static const route = "/edit-product";

  const EditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    String prodId = ModalRoute.of(context)!.settings.arguments as String;

    var prov = Provider.of<Products>(context, listen: false);

    var selectedProduct = prov.selectById(prodId);

    final TextEditingController titleController =
        TextEditingController(text: selectedProduct.title);
    final TextEditingController priceController =
        TextEditingController(text: selectedProduct.price);

    void edit(String title, String price) {
      prov.editProduct(prodId, title, price);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => edit(titleController.text, priceController.text),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextField(
                  autocorrect: false,
                  autofocus: true,
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  autocorrect: false,
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: () =>
                    edit(titleController.text, priceController.text),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
