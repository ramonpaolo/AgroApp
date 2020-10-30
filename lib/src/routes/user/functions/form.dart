//---- Packages
import 'package:flutter/material.dart';

Widget campText(
    {TextEditingController controller,
    String subtitle,
    int minValue,
    int maxValue,
    int minLines,
    int maxLines}) {
  return ListTile(
    title: formulario(controller, minValue, maxValue, minLines, maxLines),
    subtitle: Text("$subtitle",
        style: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
  );
}

Widget formulario(TextEditingController _controller, int minValue, int maxValue,
    int minLines, int maxLines) {
  return TextFormField(
    validator: (value) {
      if (value.isEmpty) {
        return "Vazio";
      } else if (value.length < minValue) {
        return "Menor que $minValue letras";
      } else if (value.length > maxValue) {
        return "Maior que $maxValue";
      } else {
        return null;
      }
    },
    style: TextStyle(color: Colors.white),
    minLines: minLines,
    maxLines: maxLines,
    textCapitalization: TextCapitalization.sentences,
    cursorColor: Colors.white,
    decoration: InputDecoration(
      border: InputBorder.none,
    ),
    controller: _controller,
  );
}
