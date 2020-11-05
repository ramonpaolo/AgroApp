import 'package:sigepweb/sigepweb.dart';

class BuyProducts {
  double priceTotal = 0.0;
  double priceTotalProduts = 0.0;
  double shippingTotal = 0.0;
  double valorFrete = 0.0;

  Future calcPriceProduts({List prices}) async {
    try {
      for (int x = 0; x < prices.length; x++) {
        priceTotalProduts += await prices[x];
      }
    } catch (e) {
      print("Erro em calcPriceTotalProduts");
    }
  }

  Future calcShipping({List ceps, List products}) async {
    try {
      for (int x = 0; x < ceps.length; x++) {
        await calcularFrete("18403040", await products[x]);
      }
    } catch (e) {
      print("Erro em calcShipping");
    }
    await calcTotal();
  }

  Future calcTotal() async {
    priceTotal = priceTotalProduts + shippingTotal;
    print("Preço total dos Produtos: $priceTotalProduts");
    print("Preço total frete: $shippingTotal");
    print("Preço total: $priceTotal");
  }

  Future calcularFrete(String cepDestino, Map item) async {
    var sigep = Sigepweb(contrato: SigepContrato.semContrato());
    var calcPrecoPrazo = await sigep.calcPrecoPrazo(
        cepOrigem: "${item["cep_origem"]}",
        cepDestino: cepDestino,
        valorPeso: item["weight"]);

    for (CalcPrecoPrazoItemModel item in calcPrecoPrazo) {
      shippingTotal += item.valor;
      print(shippingTotal);
      return shippingTotal;
    }
    return shippingTotal;
  }
}
