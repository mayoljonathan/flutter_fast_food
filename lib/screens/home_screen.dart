import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import '../constants/logo.dart';
import '../models/merchant.dart';
import '../widgets/merchant_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  final double _viewportFraction = 0.8;

  int _currentIndex = 0;

  final List<Merchant> _merchants = [
    Merchant(
      name: 'McDonald\'s',
      logoUrl: Logo.MCDO,
      imageUrl: Logo.MCDO,
      rating: 4.8,
      tags: ['Burgers', 'American'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFFFF5A3A,
      estimatedDelivery: '10 - 15 min',
    ),
    Merchant(
      name: 'Subway',
      logoUrl: Logo.SUBWAY,
      imageUrl: Logo.SUBWAY,
      rating: 4.8,
      tags: ['Sandwich', 'Healthy'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF0BA218,
    ),
    Merchant(
      name: 'KFC',
      logoUrl: Logo.KFC,
      imageUrl: Logo.KFC,
      rating: 4.5,
      tags: ['Chicken', 'American'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFFFF5A3A,
      estimatedDelivery: '5 - 10 min',
    ),
    Merchant(
      name: 'Starbucks',
      logoUrl: Logo.STARBUCKS,
      imageUrl: Logo.STARBUCKS,
      rating: 4.5,
      tags: ['Coffee', 'Beverages'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF008780,
      estimatedDelivery: '10 - 15 min',
    ),
    Merchant(
      name: 'Domino\'s Pizza',
      logoUrl: Logo.DOMINOS_PIZZA,
      imageUrl: Logo.DOMINOS_PIZZA,
      rating: 4.5,
      tags: ['Pizza', 'Italian'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF0082E8,
    ),
    Merchant(
      name: 'Shake Shack',
      logoUrl: Logo.SHAKE_SHACK,
      imageUrl: Logo.SHAKE_SHACK,
      rating: 4.5,
      tags: ['Burger', 'American'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF0A090F,
      estimatedDelivery: '10 - 20 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: Color(_merchants[_currentIndex].backgroundColor),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: _buildDeliveryLocationChip(),
              ),
              Transform.translate(
                offset: Offset(0, 100),
                child: Swiper(
                  loop: true,
                  transformer: ScaleAndFadeTransformer(),
                  viewportFraction: _viewportFraction,
                  onIndexChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _merchants.length,
                  itemBuilder: (_, int index) => MerchantItem(
                    merchant: _merchants[index],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FractionallySizedBox(
        widthFactor: _viewportFraction,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: RawMaterialButton(
            shape: StadiumBorder(),
            onPressed: () {},
            fillColor: Colors.black,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            child: Text(
              'Order from here',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDeliveryLocationChip() {
    final textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 12.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: Colors.white38,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ASAP',
            style: textStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Icon(
              EvaIcons.arrowForwardOutline,
              size: 20,
              color: Colors.white,
            ),
          ),
          Text(
            'Work',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
