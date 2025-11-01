import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_quote/widgets/stock_chart.dart';
import 'package:stock_quote/widgets/stock_detail.dart';
import '../controllers/stock_controller.dart';

class SearchResultScreen extends StatefulWidget {
  final String stockName;
  const SearchResultScreen({super.key, required this.stockName});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final StockController controller = Get.find<StockController>();
  Timer? autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    controller.getStock(widget.stockName);
    autoRefreshTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      controller.getStock(widget.stockName);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getStock(widget.stockName);
    });
  }

  @override
  void dispose() {
    autoRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 26),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.stockName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (controller.stockData.isEmpty) {
                  return const Center(
                    child: Text('No data available. Try another stock.'),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      StockDetailCard(stock: controller.stockData),
                      const SizedBox(height: 16),
                      StockChart(),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
