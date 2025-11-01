import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/stock_controller.dart';
import 'watchlist_screen.dart';
import 'search_result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StockController controller = Get.put(StockController());
  final TextEditingController searchController = TextEditingController();
  bool showSearchAnimation = false;

  @override
  void initState() {
    super.initState();
    controller.getMarketOverview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Quote',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => Get.to(() => WatchlistScreen()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getMarketOverview();
        },
        child: Obx(() {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search stock symbol',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onTap: () {
                    setState(() => showSearchAnimation = true);
                  },
                  onSubmitted: (query) {
                    if (query.isNotEmpty) {
                      setState(() => showSearchAnimation = false);
                      Get.to(() => SearchResultScreen(stockName: query))!.then(
                        (_) => setState(() => showSearchAnimation = false),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  'Market Overview',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),

                if (showSearchAnimation)
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/images/stock_animation.json',
                          width: 180,
                          repeat: true,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Search your stock to see details',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else if (controller.isLoading.value)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Lottie.asset(
                        'assets/images/loading.json',
                        width: 100,
                        repeat: true,
                      ),
                    ),
                  )
                else if (controller.marketOverview.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Center(
                          child: Lottie.asset(
                            'assets/images/stock_animation.json',
                            width: 180,
                            repeat: true,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No market data available right now',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.4,
                        ),
                    itemCount: controller.marketOverview.length,
                    itemBuilder: (context, index) {
                      final stock = controller.marketOverview[index];
                      final changePercentStr =
                          stock['changePercent']?.toString().replaceAll(
                            '%',
                            '',
                          ) ??
                          '0';
                      final changePercent =
                          double.tryParse(
                            changePercentStr.replaceAll('+', ''),
                          ) ??
                          0.0;
                      final isPositive = changePercent > 0;

                      return InkWell(
                        onTap: () {
                          Get.to(
                            () => SearchResultScreen(
                              stockName: stock['symbol'] ?? '',
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isPositive ? Colors.green : Colors.red,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                stock['symbol'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${stock['price']}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: isPositive ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
