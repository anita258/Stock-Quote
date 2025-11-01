import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import '../services/stock_service.dart';

class StockController extends GetxController {
  final StockService _stockService = StockService();
  final GetStorage storage;

  StockController({GetStorage? storage}) : storage = storage ?? GetStorage();
  final Dio _dio = Dio();

  var isLoading = false.obs;
  var stockData = <String, dynamic>{}.obs;
  var companyOverview = <String, dynamic>{}.obs;
  var errorMessage = ''.obs;
  var watchlist = <Map<String, dynamic>>[].obs;
  var historicalData = <Map<String, dynamic>>[].obs;
  var marketOverview = <Map<String, dynamic>>[].obs;
  var isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    getWatchlist();
    loadLastViewedStock();
    getMarketOverview();
  }

  void getWatchlist() {
    final savedList = storage.read<List>('watchlist') ?? [];
    watchlist.value = savedList
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  void saveWatchlist() => storage.write('watchlist', watchlist);

  void loadLastViewedStock() {
    final savedStock = storage.read<Map>('lastViewedStock');
    final savedOverview = storage.read<Map>('lastCompanyOverview');
    final savedHistory = storage.read<List>('lastHistoricalData');

    if (savedStock != null)
      stockData.value = Map<String, dynamic>.from(savedStock);
    if (savedOverview != null)
      companyOverview.value = Map<String, dynamic>.from(savedOverview);
    if (savedHistory != null) {
      historicalData.value = savedHistory
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
  }

  void saveLastViewedStock(
    Map<String, dynamic> stock,
    Map<String, dynamic> overview,
    List<Map<String, dynamic>> history,
  ) {
    storage.write('lastViewedStock', stock);
    storage.write('lastCompanyOverview', overview);
    storage.write('lastHistoricalData', history);
  }

  Future<void> getStock(String symbol) async {
    if (symbol.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _stockService.getStockData(symbol);
      final overview = await _stockService.getCompanyOverview(symbol);

      if (data != null) {
        stockData.value = data;
        companyOverview.value = overview ?? {};
        await getHistoricalStockData(symbol);

        saveLastViewedStock(data, companyOverview, historicalData.toList());
      } else {
        errorMessage.value = 'Stock not found';
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch data';
      print('Error fetching stock data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getHistoricalStockData(String symbol) async {
    final data = await _stockService.getHistoricalData(symbol);
    if (data != null) {
      historicalData.value = data;
    } else {
      historicalData.clear();
    }
  }

  void toggleWatchlist(Map<String, dynamic> stock) {
    final symbol = stock['01. symbol'];
    final existing = watchlist.firstWhereOrNull(
      (item) => item['01. symbol'] == symbol,
    );

    if (existing != null) {
      watchlist.remove(existing);
      Get.snackbar('Removed', '$symbol removed from watchlist');
    } else {
      watchlist.add(stock);
      Get.snackbar('Added', '$symbol added to watchlist');
    }

    saveWatchlist();
  }

  Future<void> getMarketOverview() async {
    isRefreshing.value = true;
    isLoading.value = true;

    final symbols = ['AAPL', 'TSLA', 'MSFT', 'GOOGL'];
    List<Map<String, dynamic>> tempList = [];

    for (var symbol in symbols) {
      try {
        final response = await _dio.get(
          'https://www.alphavantage.co/query',
          queryParameters: {
            'function': 'GLOBAL_QUOTE',
            'symbol': symbol,
            'apikey': 'B0L6WYGZJDM3S9T5',
          },
        );
        final quote = response.data['Global Quote'];
        if (quote != null && quote.isNotEmpty) {
          tempList.add({
            'symbol': quote['01. symbol'],
            'price': quote['05. price'],
            'changePercent': quote['10. change percent'],
          });
        }
      } catch (e) {
        print('Error fetching $symbol data: $e');
      }

      await Future.delayed(const Duration(seconds: 15));
    }

    marketOverview.value = tempList;
    isRefreshing.value = false;
    isLoading.value = false;
  }
}
