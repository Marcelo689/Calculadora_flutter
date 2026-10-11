import 'package:flutter/material.dart';
import 'button.dart';
import 'button_row.dart';

class Keyboard extends StatelessWidget {
  final void Function(String) cb;

  const Keyboard(this.cb, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          ButtonRow([
            Button.operation(text: '√', cb: cb),
            Button.operation(text: '(', cb: cb),
            Button.operation(text: ')', cb: cb),
            Button.operation(text: 'Ex', cb: cb, textCommand: 'Example'),
          ]),
          ButtonRow([
            Button.operation(text: 'AC', color: Button.DARK, cb: cb, textColor: Colors.red),
            Button.operation(text: '^', cb: cb),
            Button.icon(
              icon: Icons.backspace_outlined,
              color: Button.DARK,
              cb: cb,
              textCommand: 'Backspace',
              textColor: Colors.red,
            ),
            Button.operation(text: '÷', color: Button.OPERATION, cb: cb),
          ]),
          ButtonRow([
            Button(text: '7', cb: cb),
            Button(text: '8', cb: cb),
            Button(text: '9', cb: cb),
            Button.operation(text: 'X', color: Button.OPERATION, cb: cb),
          ]),
          ButtonRow([
            Button(text: '4', cb: cb),
            Button(text: '5', cb: cb),
            Button(text: '6', cb: cb),
            Button.operation(text: '-', color: Button.OPERATION, cb: cb),
          ]),
          ButtonRow([
            Button(text: '1', cb: cb),
            Button(text: '2', cb: cb),
            Button(text: '3', cb: cb),
            Button.operation(text: '+', color: Button.OPERATION, cb: cb),
          ]),
          ButtonRow([
            Button(text: '0', cb: cb),
            Button(text: 'x', cb: cb),
            Button(text: '.', cb: cb),
            Button.operation(text: '=', color: Button.OPERATION, cb: cb),
          ]),
        ],
      ),
    );
  }
}