import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:upsets/Screens/editcategory.dart';
import 'package:upsets/Screens/productsPage.dart';
import 'package:upsets/db/functions/dbFunctions.dart';
import 'package:upsets/db/functions/hiveModel/model.dart';

class MyCategories extends StatefulWidget {
  const MyCategories({Key? key}) : super(key: key);

  @override
  State<MyCategories> createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  TextEditingController searchController = TextEditingController();
  ValueNotifier<List<Categorymodel>> categoryListNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    loadCategories(); // Load categories into the ValueNotifier
  }

  Future<void> loadCategories() async {
    final categories = await getAllCategories();
    categoryListNotifier.value = categories;
  }

  Future<List<Categorymodel>> getAllCategories() async {
    final categoriesBox = await Hive.openBox<Categorymodel>('categories');
    final categories = categoriesBox.values.toList();
    return categories;
  }

  List<Categorymodel> filteredCategories(
      List<Categorymodel> categoryList, String query) {
    return categoryList
        .where((category) =>
            category.categoryname.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 370,
              height: 50,
              child: TextFormField(
                controller: searchController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'No result found';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {}); // This will trigger a rebuild
                },
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: categoryListNotifier,
              builder: (BuildContext context, List<Categorymodel> categoryList,
                  Widget? child) {
                List<Categorymodel> displayedCategories =
                    filteredCategories(categoryList, searchController.text);
                if (displayedCategories.isEmpty) {
                  return const Center(
                    child: Text('No results found'),
                  );
                }
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(8),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final category = displayedCategories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Myproduct(
                                          productListNotifier:
                                              productListNotifier,
                                          data: category,
                                        )));
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Image.file(
                                        File(category.imagepath),
                                        width: 180,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 0,
                                        child: PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Myeditctgry(
                                                    category: category,
                                                  ),
                                                ),
                                              );
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Delete Category"),
                                                    content: const Text(
                                                        "Are you sure you want to delete?"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          if (category.id !=
                                                              null) {
                                                            await deletectgrs(
                                                                category.id!);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            loadCategories(); // Reload categories after deletion
                                                          } else {
                                                            print(
                                                                'Category ID is null');
                                                          }
                                                        },
                                                        child: const Text(
                                                            "Delete"),
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return {'edit', 'delete'}
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    category.categoryname,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: displayedCategories.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
