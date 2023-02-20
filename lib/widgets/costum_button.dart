import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cviewdiscount/Utils/ColorHelper.dart';

class CostumButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient = LinearGradient(
    colors: <Color>[ColorHelper.button_background_gradient1, ColorHelper.button_background_gradient2],
  );
  final double width;
  final double height;
  final VoidCallback onPressed;

  CostumButton({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = 50.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(gradient: gradient,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed!,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}