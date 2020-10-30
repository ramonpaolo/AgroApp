//---- Packages
import 'package:flutter/material.dart';

Widget formulario(
    String hintText,
    int maxLines,
    TextEditingController controller,
    TextInputType textInputType,
    bool prefix,
    TextCapitalization textCapitalization,
    double size) {
  return Padding(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            height: size,
            color: Colors.green[200],
            child: TextField(
              controller: controller,
              keyboardType: textInputType,
              textAlign: TextAlign.start,
              textCapitalization: textCapitalization,
              maxLines: maxLines,
              cursorColor: Colors.green[900],
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: 20, top: size * 0.1, bottom: size * 0.1),
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.white),
                  prefixText: prefix ? "R\$" : null,
                  fillColor: Colors.white),
            ),
          )));
}
