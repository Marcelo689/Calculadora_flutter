import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meu_app/functions/functions.dart';

// remover botao baskara 16/08/2022
class Memory {
  String _value = "0";
  String _antesDoCalculo = "0";
  List<String> operacoes = ["-", "X", "+", "÷"];
  int contador = 0;
  String get antes {
    return _antesDoCalculo;
  }

  String get value {
    return _value;
  }

  void applyCommand(String command) {

    if (command == "0") {
      _value += "0";
      return;
    } else if (command == ".") {
      _value += command;
      return;
    }
    if (command == "Before Calculate") {
      _value = _antesDoCalculo;
      return;
    }
    if (command == "Example") {
      contador += 1;
        switch(contador){
          case 1:
            _value = "2x^2+2x+x+2x+2+1=-3x+3x+6-6+x^2-x^2";
            break;
          case 2:
            _value = "2^3+3÷3+5X5";
            break;
          case 3:
            _value = "3x=15";
            break;
          case 4:
            _value = "3xX2=6";
            contador = 0;
            break;
        }

      return;
    }
    if (command == "Calculate") {
      try {
        if (!(_value == calcularTudo(_value))) {
          _antesDoCalculo = _value;
        }
        _value = calcularTudo(_value);
        if(_value == "NaN")
          _value = "infinity";
      } catch (erro) {
        print(erro);
        Fluttertoast.showToast(
          msg: "Invalid Calculation",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        //throw ErrorDescription(erro.toString());
      } finally {
        return;
      }
    }
    if (command == "Backspace") {
      print("value=" + _value);
      if (_value.length > 0) {
        if (_value.length == 1) {
          _value = "0";
          return;
        }
        _value = _value.substring(0, _value.length - 1);
      } else {
        _value = "0";
      }
      return;
    }
    if (command == "AC") {
      _value = "0";
      return;
    }
    if (_value == "0") {
      _value = command;
      return;
    } else if (_value.indexOf("=") != -1) {
      if (command == "=") {
        return;
      }
    } else if ((!isNumeric(_value[_value.length - 1]) || command == "x") &&
        !isNumeric(command)) {
      if (operacoes.contains(_value[_value.length - 1]) && command == "(") {
        _value += command;
        return;
      }
      if ((_value[_value.length - 1] == ")") && operacoes.contains(command)) {
        _value += command;
        return;
      }
      if (command == "x" && isNumeric(_value[_value.length - 1])) {
        _value += command;
        return;
      }
      if (command == "=" && _value[_value.length - 1] == "x") {
        _value += command;
        return;
      }
    }
    _value += command;
  }
}
