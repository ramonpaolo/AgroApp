//---- Packages
import 'dart:async';
import 'package:flutter/material.dart';

//---- Functions
import 'package:agricultura/src/routes/store/functions/buy_products.dart';

BuyProducts _buyProducts = BuyProducts();

List<double> prices = [];
List<int> ceps = [];

double priceTotal = 0.0;
double priceTotalProduts = 0.0;
double priceShipping = 0.0;

void setPrices(List item) async {
  prices.clear();
  for (int i = 0; i < item.length; i++) {
    prices.add(item[i]["price"]);
  }
}

void setCeps(List item) async {
  ceps.clear();
  for (int i = 0; i < item.length; i++) {
    ceps.add(item[i]["cep_origem"]);
  }
}

showModal({BuildContext context, List products}) {
  setPrices(products);
  setCeps(products);

  _buyProducts.priceTotal = 0.0;
  _buyProducts.shippingTotal = 0.0;
  _buyProducts.valorFrete = 0.0;
  _buyProducts.priceTotalProduts = 0.0;

  _buyProducts.calcPriceProduts(prices: prices);
  _buyProducts.calcShipping(ceps: ceps, products: products);
  return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      builder: (context) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BottomSheet(
              onClosing: () {
                print("Fechando");
              },
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    Timer.periodic(Duration(seconds: 1), (timer) async {
                      if (priceTotal == 0.0) {
                        setState(() {
                          priceTotal = _buyProducts.priceTotal;
                          priceTotalProduts = _buyProducts.priceTotalProduts;
                          priceShipping = _buyProducts.shippingTotal;
                        });
                      } else {
                        timer.cancel();
                      }

                      print("Preço: $priceTotal");
                    });
                    return Container(
                        width: 1000,
                        height: 1000,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text("Comprar os produtos: "),
                            Divider(color: Colors.white),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${products[index]["title"]}",
                                                  style: TextStyle(
                                                      color: Colors.green)),
                                              Text(
                                                "R\$${products[index]["price"]}",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    })),
                            Divider(
                              color: Colors.green,
                              thickness: 1.0,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Frete Total: ",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  Text("\$${priceShipping.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Produtos Total: ",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      "\$${priceTotalProduts.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Preço Total: ",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  Text("\$${priceTotal.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ],
                        ));
                  },
                );
              },
            ));
      });
}
