import 'package:meta/meta.dart';

class Merchant {
  final String name;
  final String logoUrl;
  final String imageUrl;
  final double rating;
  final List<String> tags;
  final String priceLevel;
  final String estimatedDelivery;

  // Hexadecimal (0xFF)
  final int backgroundColor;

  Merchant({
    @required this.name,
    @required this.logoUrl,
    @required this.imageUrl,
    @required this.rating,
    @required this.tags,
    @required this.priceLevel,
    @required this.backgroundColor,
    this.estimatedDelivery,
  });
}
