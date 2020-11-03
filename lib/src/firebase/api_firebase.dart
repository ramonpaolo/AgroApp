//---- Packages
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

//---- Variables

AddProduct addProduct = AddProduct();

DatasUser dataUser = DatasUser();

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

List myProduts = [];
List linkPhotos = [];
List<double> views = [];

OrderDataProductsSortViews orderDataProductsSortViews =
    OrderDataProductsSortViews();
OrderProductSortPrice orderDataProductsSortPrice = OrderProductSortPrice();
OrderDataProductsSortName orderDataProductsSortName =
    OrderDataProductsSortName();

Object order;

QuerySnapshot productsOrderView;
QuerySnapshot productsOrderName;
QuerySnapshot productsOrderMinPrice;

ShowAllProducts showAllProducts = ShowAllProducts();

var user;

//---- Class LocalUser

class LocalUser {
  Future<File> getData() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future readData() async {
    final file = await getData();
    user = await jsonDecode(file.readAsStringSync());
    return user;
  }

  Future deleteData() async {
    final directory = await getData();
    await directory.delete();
  }
}

//---- Class DatasUser

class DatasUser {
  Future getDataUser() async {
    print("getDataUser id: ${FirebaseAuth.instance.currentUser.uid}");
    return user = await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
  }

  Future setCarShop(int idProduct) async {
    print("setCarShop");
    List quantidadeProdutosNoCarrinho = user["car_shop"];

    quantidadeProdutosNoCarrinho.add(idProduct);

    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"car_shop": quantidadeProdutosNoCarrinho});
    await getDataUser();
  }

  Future setFavorites(int idProduct) async {
    print("setFavorites");
    List quantidadeProdutosEmFavorites = user["favorites"];

    quantidadeProdutosEmFavorites.add(idProduct);

    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"favorites": quantidadeProdutosEmFavorites});
    await getDataUser();
  }

  Future removeFavorites(int idProduct) async {
    print("removefavorites");
    List quantidadeProdutosEmFavorites = user["favorites"];

    quantidadeProdutosEmFavorites
        .removeWhere((element) => element["id"] == idProduct);

    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"favorites": quantidadeProdutosEmFavorites});
    await getDataUser();
  }

  Future removeCarShop(int idProduct) async {
    print("removeCarShop");
    List quantidadeProdutosEmCarrinho = user["car_shop"];

    quantidadeProdutosEmCarrinho.removeWhere((element) => element == idProduct);

    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"car_shop": quantidadeProdutosEmCarrinho});
    await getDataUser();
  }

  Future setViews(var product) async {
    try {
      await product.update("views", (value) => product["views"] + 1);
      for (var x = 0; x < productsOrderName.size; x++) {
        if (product["id"] == productsOrderName.docs[x]["id"]) {
          await firebaseFirestore
              .collection("products")
              .doc(productsOrderName.docs[x].id)
              .update({"views": await product["views"] + 1});
        }
      }
    } catch (e) {
      try {
        var dataProduct = product.data();
        await product.reference
            .update({'views': (await dataProduct['views'] + 1)});
      } catch (e) {
        print("Error update views: $e");
      }
    }
  }

  Future updateProduct(String idProduct, Map dataProduct) async {
    try {
      return await firebaseFirestore
          .collection("products")
          .doc("$idProduct")
          .update(dataProduct);
    } catch (e) {
      print(e);
    }
  }

  Future showMyProduts(Map data) async {
    myProduts.clear();
    for (var x = 0; x < productsOrderName.docs.length; x++) {
      if (productsOrderName.docs[x]["id_author"] ==
          FirebaseAuth.instance.currentUser.uid) {
        myProduts.add(productsOrderName.docs[x]);
      }
    }
  }

  Future addUser(dataUser) async {
    print("AddUser: $dataUser");
    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(dataUser);
  }

  Future setDataUser() async {
    DocumentSnapshot dataUser = await getDataUser();
    print(dataUser.exists);
    user = dataUser.data();
    print("setDataUser: ${dataUser.data()}");
    return user;
  }
}

//---- Class AddProduct

class AddProduct {
  Future addPhoto(List file, String idProduct) async {
    try {
      for (var x = 0; x <= file.length; x++) {
        await firebase_storage.FirebaseStorage.instance
            .ref("photoProduts/" +
                FirebaseAuth.instance.currentUser.uid +
                "/" +
                idProduct +
                "/$x")
            .putFile(File(file[x]));
      }
    } catch (e) {
      print(e);
    }
  }

  Future getPhoto({String path, int fileName}) async {
    linkPhotos.clear();
    for (var x = 0; x < fileName; x++) {
      linkPhotos.add(await firebase_storage.FirebaseStorage.instance
          .ref(path)
          .child("$x")
          .getDownloadURL());
    }
    return linkPhotos;
  }

  Future addProduct(var product) async {
    await firebaseFirestore.collection("products").add(product);
  }
}

//---- Class GetProductsCategory

class GetProductsCategory {
  QuerySnapshot produtos;
  List<Map> produtosCategoriaEscolhida = [];

  Future getProducts(String category, Object order) async {
    produtos = await firebaseFirestore.collection("products").limit(10).get();
    if (order.toString() == "nome") {
      await orderByName(category: category);
    } else if (order.toString() == "preco") {
      await orderByPrice(category: category);
    } else {
      for (var x = 0; x < produtos.size; x++) {
        if (category == produtos.docs[x]["category"]) {
          produtosCategoriaEscolhida.add(produtos.docs[x].data());
        }
      }
    }

    return produtosCategoriaEscolhida;
  }

  Future orderByName({String category}) async {
    produtos = await firebaseFirestore
        .collection("products")
        .orderBy("title", descending: false)
        .limit(10)
        .get();

    for (var x = 0; x < produtos.size; x++) {
      if (category == produtos.docs[x]["category"]) {
        produtosCategoriaEscolhida.add(produtos.docs[x].data());
      }
    }
    return produtosCategoriaEscolhida;
  }

  Future orderByPrice({String category}) async {
    produtos = await firebaseFirestore
        .collection("products")
        .orderBy("price", descending: false)
        .limit(15)
        .get();
    for (var x = 0; x < produtos.size; x++) {
      if (category == produtos.docs[x]["category"]) {
        produtosCategoriaEscolhida.add(produtos.docs[x].data());
      }
    }
    return produtosCategoriaEscolhida;
  }
}

//---- Class OrderDataProductsSortViews

class OrderDataProductsSortViews {
  Future getOrderDataProductsSortViews() async {
    return await firebaseFirestore
        .collection("products")
        .orderBy("views", descending: true)
        .get();
  }

  Future setOrderDataProductsSortViews() async {
    productsOrderView = await this.getOrderDataProductsSortViews();
  }
}

//---- Class OrderDataProductsSortName

class OrderDataProductsSortName {
  Future getOrderDataProductsSortName() async {
    return await firebaseFirestore
        .collection("products")
        .orderBy("title", descending: false)
        .get();
  }

  Future setOrderDataProductsSortName() async {
    productsOrderName = await this.getOrderDataProductsSortName();
  }
}

//---- Class OrderProductSortPrice

class OrderProductSortPrice {
  Future getProductsOrderPrice() async {
    return await firebaseFirestore
        .collection("products")
        .orderBy("price", descending: false)
        .get();
  }

  Future setOrderDataProductsSortPrice() async {
    productsOrderMinPrice = await this.getProductsOrderPrice();
  }
}

//---- Class ShowAllProducts

class ShowAllProducts {
  Future showAllProducts() async {
    await orderDataProductsSortViews.setOrderDataProductsSortViews();
    await orderDataProductsSortPrice.setOrderDataProductsSortPrice();
    await orderDataProductsSortName.setOrderDataProductsSortName();

    return {
      productsOrderView,
      productsOrderMinPrice,
      productsOrderName,
    };
  }
}
