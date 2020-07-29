import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../data/data.dart';
import '../models/merchant.dart';
import '../widgets/merchant_item.dart';
import 'merchant_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _viewportFraction = 0.8;
  int _currentIndex = 0;

  final List<Merchant> _merchants = Data.merchants;

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
