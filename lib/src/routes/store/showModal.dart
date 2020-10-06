import 'package:flutter/material.dart';

showModal(context) {
  return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      builder: (c) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
                width: 1000,
                height: 1000,
                padding: EdgeInsets.all(20),
                child: Text("Terminar aki")));
      });
}
