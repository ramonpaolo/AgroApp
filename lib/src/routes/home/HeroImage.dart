//---- Packages
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share/share.dart';

class PageHero extends StatelessWidget {
  PageHero(this.image, this.title);

  //---- Variables
  final image;
  final title;

  var _snack = GlobalKey<ScaffoldState>();

  //---- Functions

  void snackBar(String text) {
    _snack.currentState.showSnackBar(SnackBar(
        content: Text(
          "$text",
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
            label: "Abrir imagem",
            onPressed: () async {
              try {
                await ImageDownloader.open(
                    "/storage/emulated/0/Agro/$title.png");
              } catch (e) {
                print(e);
              }
            }),
        backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _snack,
        backgroundColor: Colors.white,
        body: Hero(
            tag: image,
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(right: size.width * 0.8, top: 30),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.green,
                      size: 36,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      image,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                      semanticLabel: "Imagem",
                      loadingBuilder: (context, child, loadingProgress) {
                        return loadingProgress == null
                            ? child
                            : LinearProgressIndicator();
                      },
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.save_alt),
                    onPressed: () async {
                      await ImageDownloader.downloadImage(
                        await image,
                        destination:
                            AndroidDestinationType.custom(directory: "Agro")
                              ..subDirectory("$title.png"),
                      );
                      snackBar("Download feito na pasta 'Agro'");
                    },
                    color: Colors.green,
                    iconSize: 36,
                    tooltip: "Salvar no dispositivo",
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      await Share.share(image, subject: "Hi, see this image");
                    },
                    color: Colors.green,
                    iconSize: 36,
                    tooltip: "Compartilhar",
                  ),
                ],
              )
            ])));
  }
}
