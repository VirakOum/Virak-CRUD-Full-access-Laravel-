import 'package:flutter/material.dart';
import 'package:virak/virak.dart';
import 'product_model.dart';

void main() {
  // Set your API base URL and optional token
  setBaseUrl("http://127.0.0.1:8000/api");
  setAuthToken(null); // or null if not needed

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Products',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductScreen(),
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<List<ProductModel>> fetchProducts() async {
    return await getData<List<ProductModel>>(
      endpoint: "items",
      fromJson: (json) =>
          (json as List).map((e) => ProductModel.fromJson(e)).toList(),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: FutureBuilder<List<ProductModel>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.laptop),
                  title: Text(product.name),
                  subtitle: Text(product.description),
                  trailing: Text('ID: ${product.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
