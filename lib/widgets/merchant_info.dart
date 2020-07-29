import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../models/merchant.dart';

class MerchantInfo extends StatelessWidget {
  const MerchantInfo({
    Key key,
    this.tag,
    @required this.merchant,
    this.isDeliveryTimeChipped = false,
  });

  final String tag;
  final Merchant merchant;
  final bool isDeliveryTimeChipped;

  @override
  Widget build(BuildContext context) {
    final child = Column(
      children: [
        Text(
          merchant.name,
          style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
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
        Opacity(
          opacity: merchant.estimatedDelivery == null ? 0 : 1,
          child: Container(
            margin: const EdgeInsets.only(top: 18.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Text(
              merchant.estimatedDelivery ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );

    if (tag == null) return child;

    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: FittedBox(child: child),
      ),
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
