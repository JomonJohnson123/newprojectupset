import 'dart:io';
import 'package:flutter/material.dart';
import 'package:upsets/Screens/addnewproducts.dart';
import 'package:upsets/Screens/productview.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductspageState();
}

class _ProductspageState extends State<ProductsPage> {
  final ProductService _productService = ProductService();
  final ProductSearchService _searchService = ProductSearchService();
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    var products = await _productService.getAllProducts();
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  void _onSearchChanged() {
    String searchText = _searchController.text;
    setState(() {
      _filteredProducts = _searchService.searchProducts(searchText, _products);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        backgroundColor: Colors.white,
        title: 'Products',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search products',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text('No products available'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductView(),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 9,
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: product.productimage.isNotEmpty
                                        ? Image.file(
                                            File(product.productimage),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/default_image.png',
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          product.productname,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: -2,
                                right: 5,
                                child: IconButton(
                                  icon: const Icon(Icons.delete_forever,
                                      color: Color.fromARGB(255, 16, 14, 13)),
                                  onPressed: () {
                                    _productService.deleteProduct(index);
                                    _loadProducts();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 134, 153, 160),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewProductsPage(),
            ),
          ).then((_) => _loadProducts());
        },
        child: const Icon(Icons.add, color: Color.fromARGB(255, 7, 6, 6)),
      ),
    );
  }
}
