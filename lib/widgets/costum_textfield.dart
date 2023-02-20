import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cviewdiscount/Utils/ColorHelper.dart';

class CostumNumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final String prefixString;
  final TextAlign textAlign;
  final int maxLength;
  final bool enabled;

  const CostumNumberTextField({super.key, required this.controller, this.prefixString = "", this.textAlign = TextAlign.left, this.maxLength = 8, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width / 3),
        margin:
        const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          enabled: enabled,
          maxLength: maxLength,
          maxLines: 1,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              isDense: true,
              prefixIcon: prefixString.isEmpty ? null : Padding(padding: const EdgeInsets.all(10), child: Text(prefixString,
                  style: TextStyle(
                      color: ColorHelper.formfield_text_color, fontSize: 24))),

              filled: true,
              contentPadding: const EdgeInsets.all(10),
              disabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: ColorHelper.textform_border_color, width: 2)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: ColorHelper.textform_border_color, width: 2)
              ),
              border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: ColorHelper.textform_border_color, width: 2)
              )
          ),
          style: TextStyle(
              color: ColorHelper.formfield_text_color,
              fontWeight: FontWeight.bold,
              fontSize: 24),
          controller: controller,
          textAlign: textAlign,
        ));
  }

}