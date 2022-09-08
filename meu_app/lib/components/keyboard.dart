import "package:flutter/material.dart";
import "button.dart";
import "button_row.dart";

class Keyboard extends StatelessWidget {
  final void Function(String inputText) func;

  Keyboard(this.func);
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Column(
        children: <Widget>[
          ButtonRow([
            Button(
              text: ("Before Calculate"),
              func: func,
              color: Button.DARK,
            )
          ]),
          ButtonRow([
            Button(
              text: ("√"),
              func: func,
              color: Button.DARK,
            ),
            Button(
              text: ("("),
              func: func,
              color: Button.DARK,
            ),
            Button(
              text: (")"),
              func: func,
              color: Button.DARK,
            ),
            Button(
              text: ("Example"),
              func: func,
              color: Button.DARK,
            ),
          ]),
          SizedBox(height: 1),
          ButtonRow([
            Button.delete(
              text: ("AC"),
              func: func,
            ),
            Button(
              text: ("^"),
              func: func,
              color: Button.DARK,
            ),
            Button.delete(
              text: ("Backspace"),
              func: func,
            ),
            Button.operation(
              text: ("÷"),
              func: func,
            ),
          ]),
          SizedBox(height: 1),
          ButtonRow([
            Button(
              text: ("7"),
              func: func,
            ),
            Button(
              text: ("8"),
              func: func,
            ),
            Button(
              text: ("9"),
              func: func,
            ),
            Button.operation(
              text: ("X"),
              func: func,
            ),
          ]),
          SizedBox(height: 1),
          ButtonRow([
            Button(
              text: ("4"),
              func: func,
            ),
            Button(
              text: ("5"),
              func: func,
            ),
            Button(
              text: ("6"),
              func: func,
            ),
            Button.operation(
              text: ("-"),
              func: func,
            ),
          ]),
          SizedBox(height: 1),
          ButtonRow([
            Button(
              text: ("1"),
              func: func,
            ),
            Button(
              text: ("2"),
              func: func,
            ),
            Button(
              text: ("3"),
              func: func,
            ),
            Button.operation(
              text: ("+"),
              func: func,
            ),
          ]),
          SizedBox(height: 1),
          ButtonRow([
            Button(
              text: ("0"),
              func: func,
            ),
            Button(
              text: ("x"),
              func: func,
            ),
            Button(
              text: ("."),
              func: func,
            ),
            Button.operation(
              text: ("="),
              func: func,
            ),
          ]),
          SizedBox(height: 1),
          ButtonRow([
            Button.big(
              text: ("Calculate"),
              func: func,
            ),
          ]),
          SizedBox(height: 1),
        ],
      ),
    );
  }
}
