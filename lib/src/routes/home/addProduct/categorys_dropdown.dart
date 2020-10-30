//---- Packages
import 'package:flutter/material.dart';

List<DropdownMenuItem<int>> listDrop = [];

Future loadCategorys() async {
  listDrop.add(DropdownMenuItem(
    child: Text(
      "Adubos",
    ),
    value: 1,
  ));
  listDrop.add(DropdownMenuItem(
    child: Text(
      "Cosméticos",
    ),
    value: 2,
  ));
  listDrop.add(DropdownMenuItem(
    child: Text(
      "Eletrônicos",
    ),
    value: 3,
  ));
  listDrop.add(DropdownMenuItem(
    child: Text(
      "Ferramentas",
    ),
    value: 4,
  ));
  listDrop.add(DropdownMenuItem(
    child: Text(
      "Ter na casa",
    ),
    value: 5,
  ));
}
