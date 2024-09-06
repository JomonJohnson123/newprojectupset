import 'dart:io';
import 'package:flutter/material.dart';
import 'package:upsets/Screens/addcategory.dart';
import 'package:upsets/Screens/productsPage.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoryModel> categories = [];
  List<CategoryModel> filteredCategories = [];
  final CategoryService _categoryService = CategoryService();
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeCategories();
    _searchController.addListener(_filterCategories);
  }

  Future<void> _initializeCategories() async {
    await _categoryService.initHive();
    setState(() {
      categories = _categoryService.getCategories();
      filteredCategories = categories; // Initialize filteredCategories
    });
  }

  void _filterCategories() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();
      filteredCategories = categories
          .where((category) =>
              category.categoryname.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  void _addCategory(String name, File image) async {
    await _categoryService.addCategory(name, image);
    setState(() {
      categories = _categoryService.getCategories();
      _filterCategories(); // Update the filtered list
    });
  }

  void _deleteCategory(int index) async {
    await _categoryService.deleteCategory(index);
    setState(() {
      categories = _categoryService.getCategories();
      _filterCategories(); // Update the filtered list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Category',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search ...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductsPage(),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: category.ctgimage.isNotEmpty
                                  ? Image.file(
                                      File(category.ctgimage),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/default_image.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category.categoryname,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
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
                              _deleteCategory(index);
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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Addcategory(),
            ),
          );

          if (result != null) {
            final Map<String, dynamic> newCategory = result;
            _addCategory(
              newCategory['name'],
              newCategory['image'],
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
