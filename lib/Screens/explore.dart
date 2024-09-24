import 'package:flutter/material.dart';
import 'package:upsets/Screens/notification.dart';
import 'package:upsets/Screens/overview.dart';
import 'package:upsets/Screens/sell_details.dart';
import 'package:upsets/Utilities/widgets/appbars.dart';
import 'package:upsets/Utilities/widgets/const.dart';
import 'package:upsets/db/functions/dbFunctions.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key, this.totalAmount});

  final double? totalAmount;
  void initState() {
    getTotalProductCount();
    calculateTotalPrice();
    getTotalProductCount();
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
                      child: Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

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
                              SizedBox(height: 10),
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
                            const SizedBox(height: 10),
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
            const SizedBox(height: 20),

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
                  Text(
                    'Today\'s profit:   ${calculateTotalPrice()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
