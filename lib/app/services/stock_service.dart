import 'package:dio/dio.dart';

class StockService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final String apiKey = 'B0L6WYGZJDM3S9T5';

  Future<Map<String, dynamic>?> getStockData(String symbol) async {
    final url = 'https://www.alphavantage.co/query';
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'function': 'GLOBAL_QUOTE',
          'symbol': symbol,
          'apikey': apiKey,
        },
      );
      if (response.statusCode == 200 && response.data['Global Quote'] != null) {
        return Map<String, dynamic>.from(response.data['Global Quote']);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCompanyOverview(String symbol) async {
    final url = 'https://www.alphavantage.co/query';
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'function': 'OVERVIEW',
          'symbol': symbol,
          'apikey': apiKey,
        },
      );
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return Map<String, dynamic>.from(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      print('Overview Dio error: ${e.message}');
      return null;
    } catch (e) {
      print('Overview Unexpected error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getHistoricalData(String symbol) async {
    final url = 'https://www.alphavantage.co/query';
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'function': 'TIME_SERIES_DAILY',
          'symbol': symbol,
          'apikey': apiKey,
        },
      );
      if (response.statusCode == 200 &&
          response.data['Time Series (Daily)'] != null) {
        final timeSeries =
            response.data['Time Series (Daily)'] as Map<String, dynamic>;
        final List<Map<String, dynamic>> dataList = [];
        timeSeries.forEach((date, values) {
          dataList.add({
            'date': date,
            'close': double.tryParse(values['4. close'] ?? '0') ?? 0,
          });
        });
        dataList.sort((a, b) => a['date'].compareTo(b['date']));
        return dataList;
      } else {
        return null;
      }
    } on DioException catch (e) {
      print('Historical Dio error: ${e.message}');
      return null;
    } catch (e) {
      print('Historical Unexpected error: $e');
      return null;
    }
  }
}
