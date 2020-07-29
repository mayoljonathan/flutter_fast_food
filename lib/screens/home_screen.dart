import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fast_food/screens/merchant_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:page_transition/page_transition.dart';

import '../constants/images.dart';
import '../models/merchant.dart';
import '../widgets/merchant_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _viewportFraction = 0.8;
  int _currentIndex = 0;

  final List<Merchant> _merchants = [
    Merchant(
      name: 'McDonald\'s',
      logoUrl: Images.MCDO,
      imageUrl: Images.MCDO_HERO,
      rating: 4.8,
      tags: ['Burgers', 'American'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFFFF5A3A,
      estimatedDelivery: '10 - 15 min',
    ),
    Merchant(
      name: 'Subway',
      logoUrl: Images.SUBWAY,
      imageUrl: Images.SUBWAY_HERO,
      rating: 4.8,
      tags: ['Sandwich', 'Healthy'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF0BA218,
    ),
    Merchant(
      name: 'KFC',
      logoUrl: Images.KFC,
      imageUrl: Images.KFC_HERO,
      rating: 4.5,
      tags: ['Chicken', 'American'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFFFF5A3A,
      estimatedDelivery: '5 - 10 min',
    ),
    Merchant(
      name: 'Starbucks',
      logoUrl: Images.STARBUCKS,
      imageUrl: Images.STARBUCKS_HERO,
      rating: 4.5,
      tags: ['Coffee', 'Beverages'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF008780,
      estimatedDelivery: '10 - 15 min',
    ),
    Merchant(
      name: 'Domino\'s Pizza',
      logoUrl: Images.DOMINOS_PIZZA,
      imageUrl: Images.DOMINOS_PIZZA_HERO,
      rating: 4.5,
      tags: ['Pizza', 'Italian'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF0082E8,
    ),
    Merchant(
      name: 'Shake Shack',
      logoUrl: Images.SHAKE_SHACK,
      imageUrl: Images.SHAKE_SHACK_HERO,
      rating: 4.5,
      tags: ['Burger', 'American'],
      priceLevel: '\$\$\$',
      backgroundColor: 0xFF0A090F,
      estimatedDelivery: '10 - 20 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                offset: Offset(0, size.height * 0.1),
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
                    onTap: () => _orderToMerchant(_merchants[index]),
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
            onPressed: () => _orderToMerchant(_merchants[_currentIndex]),
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

  void _orderToMerchant(Merchant merchant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MerchantDetailScreen(
          merchant: merchant,
        ),
      ),
    );
  }
}
