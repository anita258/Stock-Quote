import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_quote/app/controllers/stock_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockChart extends StatelessWidget {
  final StockController controller = Get.find<StockController>();

  StockChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.historicalData.isEmpty) {
        return const Text(
          'No historical data available',
          style: TextStyle(color: Colors.grey),
        );
      }

      return SizedBox(
        height: 250,
        child: SfCartesianChart(
          title: ChartTitle(text: 'Stock Price History'),
          primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Date')),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Price (\$)')),
          series: <CartesianSeries<Map<String, dynamic>, String>>[
            LineSeries<Map<String, dynamic>, String>(
              dataSource: controller.historicalData,
              xValueMapper: (data, _) => data['date'],
              yValueMapper: (data, _) => data['close'],
              color: Colors.green,
              width: 2,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        ),
      );
    });
  }
}
