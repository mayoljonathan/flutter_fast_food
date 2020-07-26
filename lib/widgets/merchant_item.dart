import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../models/merchant.dart';

class MerchantItem extends StatelessWidget {
  const MerchantItem({Key key, @required this.merchant});

  final Merchant merchant;

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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildMerchantImage(),
                  SizedBox(height: 18.0),
                  _buildMerchantInfo(context),
                ],
              ),
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
          Image.asset(
            merchant.imageUrl,
            fit: BoxFit.contain,
            height: 150,
            width: 150,
          )
        ],
      ),
    );
  }

  Widget _buildMerchantInfo(BuildContext context) {
    return Column(
      children: [
        Text(
          merchant.name,
          style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 12.0,
            bottom: 18.0,
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24.0,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    EvaIcons.star,
                    color: Colors.yellow,
                    size: 20,
                  ),
                  SizedBox(width: 3.0),
                  Text(merchant.rating.toString()),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: _getTags(),
              ),
              Text(merchant.priceLevel),
            ],
          ),
        ),
        if (merchant.estimatedDelivery != null)
          Text(
            merchant.estimatedDelivery,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
      ],
    );
  }

  List<Widget> _getTags() {
    if (merchant.tags.length == 0) return null;

    List<Widget> children = [];

    merchant.tags.asMap().forEach((int index, String tag) {
      if (index == merchant.tags.length - 1) {
        children.add(Text(tag));
        return;
      }
      children.add(Text(tag + ', '));
    });

    return children;
  }
}
