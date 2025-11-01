import 'package:flutter/material.dart';
import 'package:stock_quote/app/controllers/stock_controller.dart';

class StockSearchBar extends StatelessWidget {
  final TextEditingController controllerText;
  final StockController stockController;

  const StockSearchBar({
    super.key,
    required this.controllerText,
    required this.stockController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controllerText,
      decoration: InputDecoration(
        labelText: 'Search stock symbol',
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search, color: Colors.green),
          onPressed: () {
            stockController.getStock(controllerText.text.trim());
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
