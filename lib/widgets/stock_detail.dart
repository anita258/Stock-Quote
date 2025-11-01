import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_quote/app/controllers/stock_controller.dart';

class StockDetailCard extends StatelessWidget {
  final Map<String, dynamic> stock;
  final controller = Get.find<StockController>();

  StockDetailCard({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final symbol = stock['01. symbol'] ?? '';
    final overview = controller.companyOverview;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() {
                  final isInWatchlist = controller.watchlist.any(
                    (item) => item['01. symbol'] == symbol,
                  );
                  return IconButton(
                    icon: Icon(
                      isInWatchlist
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: isInWatchlist ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => controller.toggleWatchlist(stock),
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              overview['Name'] ?? 'Company',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Price: \$${stock['05. price'] ?? ''}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              'Change: ${stock['09. change'] ?? ''} (${stock['10. change percent'] ?? ''})',
            ),
            const SizedBox(height: 4),
            Text('Volume: ${stock['06. volume'] ?? ''}'),
            const SizedBox(height: 4),
            Text('Market Cap: ${overview['MarketCapitalization'] ?? ''}'),
            const SizedBox(height: 4),
            Text(
              'Last Trading Day: ${stock['07. latest trading day'] ?? ''}',
            ),
          ],
        ),
      ),
    );
  }
}
