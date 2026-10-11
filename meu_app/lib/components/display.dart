import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  final String text;

  const Display(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: const Color.fromRGBO(48, 48, 48, 1),
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // Mantém sempre visível a parte final (últimos caracteres)
            child: Text(
              text,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 36, // Tamanho reduzido para caber mais conteúdo no visor
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}