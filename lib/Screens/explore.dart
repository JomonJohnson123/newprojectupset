import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:upsets/db/functions/db_explore.dart';
// Import the new database file
import 'package:upsets/Screens/notification.dart';
import 'package:upsets/Screens/overview.dart';
import 'package:upsets/Screens/sell_details.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';
import 'package:upsets/Utilities/widgets/const.dart';
import 'package:upsets/db/functions/dbFunctions.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key, this.totalAmount});

  final double? totalAmount;

  @override
  // ignore: library_private_types_in_public_api
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // Declare the ValueNotifier at the class level
  final ValueNotifier<double> totalPriceNotifier = ValueNotifier<double>(0.0);

  // Hive box to store the total sale amount
  late Box<double> totalSaleBox;

  @override
  void initState() {
    super.initState();
    // Initialize Hive box for total sale
    initializeTotalSaleData();
  }

  // Method to initialize Hive box and load stored total sale amount
  Future<void> initializeTotalSaleData() async {
    totalSaleBox = await openTotalSaleBox();
    double? storedTotal = await getTotalSaleAmount(totalSaleBox);
    if (storedTotal != null) {
      totalPriceNotifier.value = storedTotal;
    }

    // Add listener to update total sale price
    sellListNotifier.addListener(calculateTotalPrice);
  }

  @override
  void dispose() {
    // Clean up listeners and notifiers when the widget is removed from the tree
    sellListNotifier.removeListener(calculateTotalPrice);
    totalPriceNotifier.dispose();
    super.dispose();
  }

  // Method to calculate the total price of sold products

  void calculateTotalPrice() {
    double total = 0.0;

    // Iterate through the sellListNotifier to calculate the total price
    for (var sellProduct in sellListNotifier.value) {
      double? sellPrice = double.tryParse(sellProduct.sellPrice);

      if (sellPrice != null) {
        total += sellPrice;
      } else {
        // ignore: avoid_print
        print("Error parsing sellPrice: ${sellProduct.sellPrice}");
      }
    }

    // Update the notifier's value
    totalPriceNotifier.value = total;

    // Store the total in Hive using the separated function
    storeTotalSaleAmount(totalSaleBox, total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12927D),
      appBar: CustomAppBarHome(
          title: 'Explore',
          backgroundColor: const Color(0xFF12927D),
          onNotificationPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationPage(),
              ),
            );
          }),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // Overview Card
            SizedBox(
              width: double.infinity,
              height: 150,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OverviewPage(),
                    ),
                  );
                },
                child: const Card(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Overview',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.troubleshoot_outlined, size: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            kheight10,

            // Sell Details & Total Products Row
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SellDetails(
                              selectedProducts: [],
                            ),
                          ),
                        );
                      },
                      child: const Card(
                        elevation: 5,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 40,
                                color: Color(0xFF12927D),
                              ),
                              kheight10,
                              Text(
                                'Sell Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Displaying Total Products Count with FutureBuilder
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.sell_outlined,
                              size: 40,
                              color: Color(0xFF12927D),
                            ),
                            kheight10,
                            FutureBuilder<int>(
                              future: getTotalProductCount(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text(
                                    'Error',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      'Products ${snapshot.data}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            kheight20,

            // Profit Container
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Profit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    kheight10,
                    ValueListenableBuilder(
                      valueListenable: totalPriceNotifier,
                      builder: (context, double totalPrice, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total Sale Price: $totalPrice',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        );
                      },
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
