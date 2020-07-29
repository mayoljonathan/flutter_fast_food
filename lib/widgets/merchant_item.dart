import 'package:animations/animations.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fast_food/screens/merchant_detail_screen.dart';
import 'package:fast_food/widgets/merchant_info.dart';
import 'package:flutter/material.dart';

import '../models/merchant.dart';

class MerchantItem extends StatelessWidget {
  const MerchantItem({Key key, @required this.merchant, this.onTap});

  final Merchant merchant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Image.asset(
            merchant.logoUrl,
            height: 80,
            width: 200,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                Hero(
                  tag: 'merchant-card-${merchant.hashCode}',
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildMerchantImage(),
                      SizedBox(height: 18.0),
                      MerchantInfo(
                        tag: 'merchant-info-${merchant.hashCode}',
                        merchant: merchant,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMerchantImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Color(merchant.backgroundColor),
      ),
      height: 200,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: 'merchant-hero-${merchant.hashCode}',
            child: Image.asset(
              merchant.imageUrl,
              fit: BoxFit.contain,
              height: 150,
              width: 150,
            ),
          )
        ],
      ),
    );
  }
}
