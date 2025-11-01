class StockModel {
  final String symbol;
  final double open;
  final double high;
  final double low;
  final double currentPrice;
  final double previousClose;
  final double change;
  final double changePercent;
  final String latestTradingDay;

  StockModel({
    required this.symbol,
    required this.open,
    required this.high,
    required this.low,
    required this.currentPrice,
    required this.previousClose,
    required this.change,
    required this.changePercent,
    required this.latestTradingDay,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['01. symbol'] ?? '',
      open: double.tryParse(json['02. open'] ?? '0') ?? 0,
      high: double.tryParse(json['03. high'] ?? '0') ?? 0,
      low: double.tryParse(json['04. low'] ?? '0') ?? 0,
      currentPrice: double.tryParse(json['05. price'] ?? '0') ?? 0,
      previousClose: double.tryParse(json['08. previous close'] ?? '0') ?? 0,
      change: double.tryParse(json['09. change'] ?? '0') ?? 0,
      changePercent: double.tryParse(
              (json['10. change percent'] ?? '0').replaceAll('%', '')) ??
          0,
      latestTradingDay: json['07. latest trading day'] ?? '',
    );
  }
}
