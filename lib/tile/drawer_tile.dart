import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {Key? key,
      required this.icon,
      required this.text,
      required this.pageController,
      required this.page})
      : super(key: key);

  final PageController
      pageController; //para dar acesso ao controlador das paginas do page view, para poder mudar a pagina
  final int page; //para saber a qual pagina cada um corresponde
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(); //fecha o drawer
          pageController
              .jumpToPage(page); //vai para a pagina que este widget corresponde
        },
        child: Container(
          height: 60,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                //se a pagina do cortrolador for a mesma pagina do item e icone fica de outra cor
                color: pageController.page!.round() == page
                    //round arredonda para int
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade700,
              ),
              SizedBox(
                width: 32,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  //se a pagina do cortrolador for a mesma pagina do item e texto fica de outra cor
                  color: pageController.page!.round() == page
                      //round arredonda para int
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
