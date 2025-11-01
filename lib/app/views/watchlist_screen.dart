import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_quote/widgets/stock_detail.dart';
import '../controllers/stock_controller.dart';

class WatchlistScreen extends StatelessWidget {
  final controller = Get.find<StockController>();

  WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Watchlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.watchlist.isEmpty) {
          return const Center(
            child: Text(
              'No stocks added yet!',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.watchlist.length,
          itemBuilder: (context, index) {
            final stock = controller.watchlist[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: StockDetailCard(stock: stock),
            );
          },
        );
      }),
    );
  }
}
