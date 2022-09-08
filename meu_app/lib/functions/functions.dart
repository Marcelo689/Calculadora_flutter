// ignore_for_file: avoid_print

import 'dart:math';

import 'package:meu_app/models/separarLadosdoIgual.dart';

import 'calculo.dart';
import 'incalculavel.dart';
int baskaraFinish = -1;

List<String> incalculaveis = [];
List<String> operations = ["+", "-", "X", "÷", "^"];
String inputA = "";
String inputB = "";
String inputC = "";
isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

existNumeroComX(String input) {
  List<String> operacoes = ["-", "X", "+", "÷"];
  String numeroComX = "";
  int indiceX = encontrarX(input);
  if (indiceX != -1) {
    numeroComX = pegarParteComX(input, indiceX);

    if(input.indexOf(numeroComX) != -1){
      return numeroComX;
    }else{
      numeroComX = removeOneLetter(numeroComX, 0);
      return numeroComX;
    }

  } else {
    return false;
  }
}
IsBaskara(String input){
  if(input.contains("x^2")){
    input = input.replaceAll("x^2", "");
    if(input.contains("x")){
      return true;
    }
  }
  return false;

}
calcularBaskara(String inputA, String inputB, String inputC){
  String saidaA = inputA.replaceFirst("x^2", "");
  String saidaB = inputB.replaceFirst("x", "");
  double a = double.parse( isNumeric(saidaA) ? saidaA : "1");
  double b = double.parse( isNumeric(saidaB) ? saidaB : "1");
  double c = double.parse(inputC);
  double potencia = pow( b, 2) as double;
  double calculoTemp = 0.0;
  calculoTemp = 4 * a * c ;
  calculoTemp = potencia - calculoTemp;

  double delta = calculoTemp;
  double menosB = double.parse("-" + b.toString());
  if(delta <= 0 ){
   return [0.0,0.0];
  }
  delta = sqrt(delta);
  double parteDeCimaPositivo = menosB + delta;
  double parteDeCimaNegativo = menosB - delta;
  double parte2a = 2 * a;

  double resultadoPositivo = parteDeCimaPositivo / parte2a;
  double resultadoNegativo = parteDeCimaNegativo / parte2a;

  return [resultadoNegativo,resultadoPositivo];

}
calcularXizes(String input){
  if(input.contains("+x^2")){
    input = input.replaceAll("+x^2","1");
  }else if(input.contains("-x^2")){
    input = input.replaceAll("-x^2","-1");
  }
  if(input.contains("x^2")){
    input = input.replaceAll("x^2","");
  }
  input =  input.replaceAll("x", "");
  Lados lados = separarLados(input);

  String tempDireita = lados.direita;
  while(!isNumeric(tempDireita)){
    tempDireita = calcularParte(tempDireita);
  }

  double tempDouble = double.parse(tempDireita) * -1;

  String tempEsquerda = lados.esquerda;
  while(!isNumeric(tempEsquerda)){
    tempEsquerda = calcularParte(tempEsquerda);
  }

  String resultado = addSinal(tempEsquerda) + addSinal(tempDireita);
  resultado = calcularParte(resultado);

  return resultado;

}
resolverNumerosComX(String input){
  input = input.replaceAll("x", "");
  return calcularTudo(input);
}

replaceNumeroCalculado(String input, String aSubstituir)
{
  if(input.contains("+" + aSubstituir))
    input = input.replaceFirst("+" + aSubstituir, "");
  else
  if(input.contains(aSubstituir))
    input = input.replaceFirst(aSubstituir, "");

  else if(input.contains("-" + aSubstituir))
    input = input.replaceFirst("-" + aSubstituir, "");

  return input;
}

resolverBaskara(String input){
  inputA = "";
  inputB = "";
  inputC = "";

  if(input.contains("="))
  {
    String ladoDireito = input.split("=")[1];
    if( ladoDireito == "0")
      input = input.split("=")[0];
  }

 int indice = encontrarIndicePrioridade(input);
 Calculo partePrioritaria= new Calculo();
 if(input.contains("="))
   input = XParaEsquerda(input);
 if(IsBaskara(input) || baskaraFinish != 2) {
   baskaraFinish = 0;

   //Marcelo tentando varios calculos x^2.
    while(input.contains("x^2") && baskaraFinish == 0){
      bool adicionou1 = false;
      indice = encontrarX(input);
      partePrioritaria = pegarPartePrioritaria(input, indice);
      if(partePrioritaria.num1 == "x"){
        adicionou1 = true;
        input = replaceNumeroCalculado(input, partePrioritaria.StringCalculada);
        partePrioritaria.StringCalculada = "1" + partePrioritaria.StringCalculada;
      }

      inputA += addSinal(partePrioritaria.StringCalculada);
      if(!adicionou1)
        input = replaceNumeroCalculado(input, partePrioritaria.StringCalculada);
    }

    if( baskaraFinish == 0) {
      inputA = calcularXisAoQuadrado(inputA);
      baskaraFinish++;
    }

    while(input.contains("x") && !(input.contains("x^")) && baskaraFinish ==  1){
      indice = encontrarX(input);
      partePrioritaria = pegarPartePrioritaria(input, indice);
      inputB +=  addSinal(partePrioritaria.StringCalculada);
      input = input.replaceFirst(partePrioritaria.StringCalculada, "");
    }

    if(baskaraFinish == 1){
      baskaraFinish++;
      inputB = resolverNumerosComX(inputB);
    }
    input = input.replaceFirst("=", "");
    while( !isNumeric(input) && baskaraFinish == 2){
      input = calcularParte(input);
    }

    if(baskaraFinish == 2) {
      inputC = input;
    }

     List<double> listResultados = calcularBaskara(inputA, inputB, inputC);
     baskaraFinish = 2;
    return listResultados;
  }
}
calcularParte(String input){
  int indice = encontrarIndicePrioridade(input);
  if( !(indice <= 0) ){
    Calculo calculo = pegarPartePrioritaria(input, indice);
    if(calculo.num1 == "" || calculo.num2 == "")
      input = calcularParteT(input, calculo);
    else
      return calcularParteT(input, calculo);
  }
  return input;
}

calcularXisAoQuadrado(String input){
  input = input.replaceAll("x^2", "");
  return calcularParte(input);
}

separarLados(String input) {
  List<String> incalculavel1 = [];
  List<String> incalculavel2 = [];
  List<String> temp = [];
  int contador = 0;
  String esquerda = input.split("=")[0];
  String direita = input.split("=")[1];

  return Lados(esquerda, direita, incalculavel1, incalculavel2);
}

resolverRaizesQ(String stringCompleta) {
  while (stringCompleta.indexOf("√") != -1) {
    int indiceRaiz = stringCompleta.indexOf("√");
    String conteudoDaRaiz = "";
    for (int i = indiceRaiz + 1; i < stringCompleta.length - 1; i++) {
      if (isNumeric(stringCompleta[i])) {
        conteudoDaRaiz += stringCompleta[i];
      } else {
        break;
      }
    }
    double conteudo = double.parse(conteudoDaRaiz);
    double resultado = sqrt(conteudo);
    stringCompleta.replaceAll("√" + conteudoDaRaiz, resultado.toString());
  }
}

encontrarX(String input) {
  int indice1 = input.length;
  int indice2 = input.length;
  if(input.contains("x^2")){
    indice1 = input.indexOf("^");
  }else
  if(input.contains("x")){
    indice2 = input.indexOf("x");
  }
  if (indice1 != input.length || indice2 != input.length) {
    if (indice1 < indice2) {
      return indice1 ;
    } else {
      return indice2 ;
    }
  }

  return -1;
}

removeOneLetter(String input, int indice) {
  String saida = "";
  for (int i = 0; i < input.length; i++) {
    if (!(i == indice)) {
      saida += input[i];
    }
  }
  return saida;
}

//encontra qual o primeiro a ser resolvido
encontrarIndicePrioridade(String input) {

  if(input.isEmpty)
    return -1;
  int indice1 = input.length;
  int indice2 = input.length;

  if (input.contains("^")) {
    indice1 = input.indexOf("^");
  }
  if (input.contains("√")) {
    indice2 = input.indexOf("√");
  }
  if (indice1 != input.length || indice2 != input.length) {
    if (indice1 < indice2) {
      return indice1 ;
    } else {
      return indice2 ;
    }
  }
  if (input.contains("X")) {
    indice1 = input.indexOf("X");
  }
  if (input.contains("÷")) {
    indice2 = input.indexOf("÷");
  }
  if (indice1 != input.length || indice2 != input.length) {
    if (indice1 < indice2) {
      return indice1 ;
    } else {
      return indice2 ;
    }
  }
  if (input.contains("+")) {
    indice1 = input.indexOf("+", 1);
  }
  if (input.contains("-", 1)) {
    indice2 = input.indexOf("-", 1);
  }
  if ((indice1 != input.length && indice1 != -1) || (indice2 != input.length && indice2 != -1)) {
    if (indice1 < indice2 && indice1 != -1) {
      return indice1 ;
    } else {
      return indice2 ;
    }
  }

  return -1;
}

XParaEsquerda(String input){
  int indice = 0 ;
  String saida= "";
  String temp = "";
  if(input.contains("=")){
    List<String> partes = input.split("=");
    String ladoEsquerdo = partes[0];
    String ladoDireito = partes[1];
    String xis = "";
    while(ladoDireito.contains("x")){
      indice = encontrarX(ladoDireito);
      temp += PegarEsquerdaSinal(ladoDireito, indice);
      temp += PegarDireitoSinal(ladoDireito, indice);// permitir simbolo da potencia

      ladoDireito = ladoDireito.replaceFirst(temp, "");
      ladoDireito = removeSinalDuplo(ladoDireito);
      if(!temp.contains("x^2"))
      {
        xis = "x";
        temp = temp.replaceFirst("x", "");
      }
      else
      {
        xis = "x^2";
        temp = temp.replaceFirst("x^2", "");
      }

      if(temp.isNotEmpty)
      {
        temp = addSinal(temp);

        if(temp.length == 1)
          temp = temp + "1";

        saida += alterarSinal(temp);
      }

      if(ladoDireito.length > 0)
      if(ladoDireito.contains(temp))
      {
        ladoDireito = ladoDireito.replaceFirst(temp, "");
      }
      else
      if(ladoDireito.contains("+" + temp ) != -1)
      {
        ladoDireito = ladoDireito.replaceFirst( "+" + temp, "");
      }
      else
      if(ladoDireito.contains("-" + temp ) != -1)
      {
        ladoDireito = ladoDireito.replaceFirst( "-" + temp, "");
      }

      temp = "";
    }
    while(!isNumeric(saida)){
      saida = calcularParte(saida);
    }
    if(xis == "x"){
      saida += "x";
    }else
      saida += "x^2";
    String TodosXProLadoEsquerdo= input;
    if(saida != "")
      TodosXProLadoEsquerdo = ladoEsquerdo + addSinal(saida) + "=" + ladoDireito;
    return TodosXProLadoEsquerdo;
  }
}
numeroDeX(String entrada){
  int contador = 0 ;
  for(int i=0; i < entrada.length; i++){
    if(entrada[i] == "x")
      contador++;
  }
  return contador;
}

pegarParteComX(String input, int indice) {
  List<String> operations = ["+", "-", "X", "÷", "^"];
  String ladoEsquerdo = "";
  String sinal = "";

  for (int i = indice - 1; i >= 0; i--) {
    if (isNumeric(input[i]) || input[i] == "-" || input[i] == "+" || input[i] == "." ) {

      ladoEsquerdo += input[i];
      if(operations.contains(input[i])){
        break;
      }
    } else {
      break;
    }
  }
  String sinalI = input[indice];
  ladoEsquerdo = ladoEsquerdo.split('').reversed.join();
  String ladoDireito = "";
  for (int i = indice + 1; i <= input.length - 1; i++) {
    if (isNumeric(input[i]) || input[i] == "^" || input[i] == "-" || input[i] == "+" || input[i] == "." || input[i] == "X") {
      ladoDireito += input[i];
    } else {
      break;
    }
  }
  if(ladoEsquerdo.length == 0){
    ladoEsquerdo = "1";
  }
  ladoEsquerdo = addSinal(ladoEsquerdo);

  if(ladoDireito.length == 0){
    ladoDireito = "1";
  }

  String saida = ladoEsquerdo + sinalI;

  return saida;
}
PegarEsquerdaSinal(String input, int indice) {
  String ladoEsquerdo = "";
  List<String> operacoesValidas = ["-","+","÷","X",];
  if(input[indice] != "x")
  {
    indice = indice -1;
  }

  for (int i = indice ; i >= 0; i--) {
    if (isNumeric(input[i]) ||
        input[i] == "-" ||
        input[i] == "x" ||
        input[i] == ".") {

      ladoEsquerdo += input[i];
      if(operacoesValidas.contains(input[i]))
        break;
      if(i < indice)
        if(isNumeric(input[i+1]) && operations.contains(input[i]))
          if(i > 0)
            if(isNumeric(input[i-1]))
              break;
    } else {
      break;
    }
  }
    ladoEsquerdo = ladoEsquerdo
        .split('')
        .reversed
        .join();

    return ladoEsquerdo;

}
  PegarDireitoSinal(String input, int indice) {
    String ladoDireito = "";
    if(input[indice] != "^")
      indice += 1;
    for (int i = indice; i <= input.length - 1; i++) {
      if (isNumeric(input[i]) ||
          input[i] == "x" ||
          input[i] == "^" ||
          input[i] == ".") {
        ladoDireito += input[i];
      } else {
        break;
      }
    }
      return ladoDireito;

  }

//pra potencia
pegarPartePrioritaria(String input, int indice) {
  String ladoEsquerdo = "";
  String ladoDireito = "";
  String sinal = input[indice];
  String StringCalculada="";
  Calculo list= new Calculo();
  list.sinal = sinal;

  if(sinal == "x"){
    list.StringCalculada = addSinal(PegarEsquerdaSinal(input, indice)); // + "x";
    return list;
  }
  if(sinal == "√"){
    ladoEsquerdo = input.substring(indice+1,input.length);
    StringCalculada = sinal + ladoEsquerdo;
  }else if(sinal == "^")
  {
    if(input[indice-1] == "x" && input[indice+1] == "2"){

      ladoEsquerdo = PegarEsquerdaSinal(input, indice);
      ladoDireito = PegarDireitoSinal(input, indice);
      list.num1 = ladoEsquerdo;
      list.num2 = ladoDireito;
      list.sinal = sinal;
      list.StringCalculada = (ladoEsquerdo + sinal + ladoDireito);
      list.StringCalculada = list.StringCalculada.replaceAll("^^", "^");
      return list;
    }
  }

    ladoEsquerdo = PegarEsquerdaSinal(input, indice);
    ladoDireito = PegarDireitoSinal(input, indice);

    StringCalculada= ladoEsquerdo + sinal + ladoDireito;

  list.num1  = ladoEsquerdo;
  list.num2 = ladoDireito;
  list.StringCalculada = StringCalculada;
  return list;
}
addSinal(String input){
  if(input[0] == "+" || input[0] == "-"){
    return input;
  }
  String saida = "+"+input;
  return saida;
}
removeSinal(String input){
  String saida = "";
  if(input[0] == "+" || input[0] == "-"){
    saida =removeOneLetter(input, 0);
    return saida;
  }else{
    return input;
  }

}
alterarSinal(String entrada){
  String sinal = "";
  entrada = addSinal(entrada);
  sinal = entrada[0];
  if(sinal == "+")
  {
    sinal = "-";
  }else{
    sinal = "+";
  }

  return sinal + removeOneLetter(entrada, 0);

}
removeSinalDuplo(String input){
  bool sinal = false;
  String saida = "";
  for(int i =0; i< input.length; i++){
    saida += input[i];
    if(i != input.length -1){
      if(operations.contains(input[i]) && operations.contains(input[i +1]))
      {
        saida = removeOneLetter(saida, i);
      }
    }

    sinal = false;
  }

  return saida;
}
adicionaPalavraString(String input,String palavra,int indice){
  String saida = "";
  for(int i=0 ;i < input.length; i++){
    if(indice == i)
      saida += palavra;
    saida += input[i];
  }
  return saida;
}

adicionaSinal(String input)
{
  if(!operations.contains(input[0])){
    input = adicionaPalavraString(input, "+", 0);
  }
  return input;
}

calcularTudo(String input) {

  if(input.toLowerCase().contains("(+)"))
    return;
  input = removeSinalDuplo(input);
  String inputCompleto = input;
  String temParenteses = parenteses(input);
  String tempNum = "";
  double tempDouble = 0;
  if (temParenteses != "-1") {
    input = temParenteses;
  }
  if(IsBaskara(input)){
    List<double> listaBaskara = resolverBaskara(input);
    return "(-) " + listaBaskara[0].toStringAsFixed(3) +"    " + "(+) " + listaBaskara[1].toStringAsFixed(3);
  }
  if (input.indexOf("=") != -1) {

    Lados retorno = separarLados(input);
    String esquerda = adicionaSinal( retorno.esquerdaGet );
    String direita = adicionaSinal( retorno.direitaGet );
    String tempCalculo="";
    String apenasNumerosCalculados="";
    int indicePrioridade = -1;
    String numeroComX = "";
    Calculo CalculoPrioritario= new Calculo();
    //futuramente while
    while(existNumeroComX(direita) != false){
      numeroComX = existNumeroComX(direita);
      incalculaveis.add(alterarSinal(numeroComX));
      numeroComX = addSinal(numeroComX);
      if(direita.indexOf(numeroComX) != -1 ){
        direita = direita.replaceAll(numeroComX, "");
      }else{
        numeroComX = removeOneLetter(numeroComX, 0);
        if(direita.indexOf(numeroComX , 0) != -1)
        {
          direita = direita.replaceFirst(numeroComX, "");
        } else
          if(numeroComX.length == 2){
            numeroComX = removeOneLetter(numeroComX, 0);

          if(direita.contains("-" + numeroComX))
            direita = direita.replaceFirst("-" + numeroComX, "");

          if(direita.contains("+" + numeroComX))
            direita = direita.replaceFirst("+" + numeroComX, "");
        }
      }
      if(esquerda.isEmpty){
        break;
      }
    }
    while(existNumeroComX(esquerda) != false){
      numeroComX = existNumeroComX(esquerda);
      if(numeroComX.isEmpty)
        numeroComX = "x";
      numeroComX = adicionaSinal(numeroComX);
      if(esquerda.indexOf(numeroComX) != -1 ){
        esquerda = esquerda.replaceFirst(numeroComX, "");
        incalculaveis.add(numeroComX);
      }else{
        numeroComX = removeOneLetter(numeroComX, 0);

        if(esquerda.indexOf(numeroComX , 0) != -1)
        {
          esquerda = esquerda.replaceFirst(numeroComX, "");
        } else
        if(numeroComX.length == 2){
          numeroComX = removeOneLetter(numeroComX, 0);

          if(esquerda.contains("-" + numeroComX)) {
            esquerda = esquerda.replaceFirst("-" + numeroComX, "");
            incalculaveis.add("-" + numeroComX);
          }
          if(esquerda.contains("+" + numeroComX)) {
            esquerda = esquerda.replaceFirst("+" + numeroComX, "");
            incalculaveis.add("+" + numeroComX);
          }

        }
      }
      if(esquerda.isEmpty){
        break;
      }
    }
    if(esquerda.isNotEmpty) {
      indicePrioridade = encontrarIndicePrioridade(esquerda);

      if (indicePrioridade != -1) {
        CalculoPrioritario = pegarPartePrioritaria(
            esquerda, indicePrioridade);
        if(CalculoPrioritario.sinal == "X" && CalculoPrioritario.num1 == ""){

          esquerda ="";

          if(isNumeric(direita))
          while (incalculaveis.isNotEmpty) {
            esquerda += incalculaveis.first;
            incalculaveis.removeAt(0);
          }
          esquerda += CalculoPrioritario.sinal + CalculoPrioritario.num2;
        }

        CalculoPrioritario = pegarPartePrioritaria(
            esquerda, indicePrioridade);
        tempCalculo = calcularParteT(esquerda, CalculoPrioritario);
        esquerda = "";
        tempCalculo = addSinal(tempCalculo);

        if(isNumeric(direita))
        while (incalculaveis.isNotEmpty) {
          esquerda += incalculaveis.first;
          incalculaveis.removeAt(0);
        }
        esquerda += tempCalculo;
      } else {
        String sinal = esquerda[0];
        if(sinal == "+"){
          sinal = "-";
        }else{
          sinal  = "+";
        }
        String esquerdaPassada = sinal + removeSinal(esquerda);
        if(esquerdaPassada.length != 1)
          direita +=  esquerdaPassada.toString();
        esquerda = esquerda.replaceFirst(esquerda, "");

        if(isNumeric(direita))
        while (incalculaveis.isNotEmpty) {
            esquerda += addSinal(incalculaveis.first);
          incalculaveis.removeAt(0);
        }
      }
    }
    if(isNumeric(direita))
    while(incalculaveis.isNotEmpty){
      esquerda += addSinal(incalculaveis.first);
      incalculaveis.removeAt(0);
    }

    indicePrioridade = encontrarIndicePrioridade(esquerda);
    if(indicePrioridade != -1) {
      CalculoPrioritario = pegarPartePrioritaria(esquerda, indicePrioridade);
      esquerda = calcularParteT(esquerda, CalculoPrioritario);
    }
    int indicePrioridade2 = encontrarIndicePrioridade(direita);
    if (indicePrioridade2 != -1) {
      Calculo CalculoPrioritario2 =
          pegarPartePrioritaria(direita, indicePrioridade2);
      direita = calcularParteT(direita, CalculoPrioritario2);
    }

    if (esquerda == retorno.esquerdaGet) {
      if (existNumeroComX(esquerda) != false) {
        tempNum = (esquerda.replaceFirst(existNumeroComX(esquerda), ""));
        if (tempNum.length != 0 && tempNum[0] == "+") {
          tempNum = removeOneLetter(tempNum, 0);
        }
        if (!(tempNum == "")) {
          esquerda = esquerda.replaceAll(tempNum, "");
          String tempSinal = "";
          switch (tempNum[0]) {
            case "X":
              tempNum = tempNum.substring(1, tempNum.length);
              tempSinal = "÷";
              break;
          }
          if(isNumeric(tempNum))
            tempDouble = double.parse(tempNum) * -1;

              if(tempDouble != 0.0){
                direita  += tempSinal + tempDouble.toString();
              }

        }
      }
    }

    if (esquerda.contains("x") &&
        isNumeric(esquerda.substring(0, esquerda.length - 1))) {
      if (direita.contains("x")) {

      } else {
        if (!esquerda.contains("x^2")) {

          while(!isNumeric(direita)) {
            if (!isNumeric(direita)) {
              //calcular direita caso nao for numero
              int indicePrioridade2 = encontrarIndicePrioridade(direita);
              if (indicePrioridade2 != -1) {
                Calculo CalculoPrioritario2 =
                pegarPartePrioritaria(direita, indicePrioridade2);
                direita = calcularParteT(direita, CalculoPrioritario2);
              }
            }
          }
          direita = (double.parse(direita) /
              (double.parse(esquerda.substring(0, esquerda.length - 1))))
              .toString();
          esquerda = "x";
          input = esquerda + "=" + direita;
          while(incalculaveis.isNotEmpty){
            esquerda += addSinal(incalculaveis.first);
            incalculaveis.removeAt(0);
          }
          return input;
        }
      }
    }
    while(incalculaveis.isNotEmpty){
      esquerda += addSinal(incalculaveis.first);
      incalculaveis.removeAt(0);
    }
    // x + 3 = +6 + 25
    if(esquerda == "" || esquerda == "+" && isNumeric(direita)){
      esquerda = "x";
    }
    input = esquerda + "=" + direita;
    return input;
  }

    while (!isNumeric(input)) {
      int indicePrioridade1 = encontrarIndicePrioridade(input);
      Calculo CalculoPrioritario1 =
          pegarPartePrioritaria(input, indicePrioridade1);

      input = calcularParteT(input, CalculoPrioritario1);
    }
  if (temParenteses != "-1") {
    input = inputCompleto.replaceAll("(" + temParenteses + ")", input);
  }

  if(temParenteses != "-1"){
    Lados saidaResultadoFinal = separarLados(input);

    if(saidaResultadoFinal.esquerda == "" && isNumeric(saidaResultadoFinal.direita)){
      return "x" + input;
    }
  }

  return input;
}

parenteses(String input) {
  int parentesesE = 0;
  int parentesesD = input.length - 1;
  if (input.contains("(") && input.contains(")")) {
    parentesesE = input.indexOf("(");
    for (int i = 0; i < input.length - 1; i++) {
      if (input[i] == ")") {
        parentesesD = i;
        break;
      }
    }
    input = input.substring(parentesesE + 1, parentesesD);

    int indicePrioridade = encontrarIndicePrioridade(input);
    Calculo listInputs = pegarPartePrioritaria(input, indicePrioridade);
    String num1 = listInputs.num1;
    String num2 = listInputs.num2;
    String sinal = listInputs.sinal;

    String resultado = calcularParteT(input, listInputs);
    return input;
  } else {
    return "-1";
  }
}

dividirPartes(String input) {
  String num1 = "";
  String num2 = "";
  String num3 = "";
  String sinal = "";
  for (int i = 0; i < input.length; i++) {
    if ((isNumeric(input[i]) || input[i] == "-") && num1 == "") {
      num3 += input[i];
    } else if (num1 != "" && (isNumeric(input[i]) || input[i] == "-")) {

      num3 += input[i];
      if (i == input.length - 1) {
        num2 = num3;
      }
    } else {
      if (input[i] == "^" && num1 == "") {
        num3 += "^";
      } else if (input[i] == "^" && num1 != "") {
        num3 += "^";
      } else if (input[i - 1] == "^" && num1 == "") {
        num1 = num3 + input[i];
      } else if (input[i - 1] == "^" && num1 != "") {
        num2 = num3 + input[i];
      } else if (input[i] == "x" && num1 == "") {
        num1 = num3 + "x";
      } else if (input[i] == "x" && num1 != "") {
        num2 = num3 + "x";
      } else {
        if (sinal == "") {
          sinal = input[i];
        }
        if (num1 == "") {
          num1 = num3;
        } else {
          num2 = num3;
          break;
        }
        num3 = "";
      }
    }
  }
  Calculo list = new Calculo();
  list.num1 = num1;
  list.num2 = num2;
  list.sinal = sinal;

  return list;
}

calcularParteT(String input, Calculo listInputs) {
  String stringCompleta = input;
  String stringResultado = "";
  String stringCalculada= "";
  int numOfX = 0;
  

  listInputs.num2 = listInputs.num2.replaceAll("^", "");
  String input1 = listInputs.num1.toString();
  String input2 = listInputs.num2.toString();
  String sinal = listInputs.sinal;
  double num2 = 0;
  double num1 = 0;
  String incalculavel = "";
  if(sinal == "√"){
    stringCalculada = sinal + input2;
  }else
  if (input1 == "" || input2 == "") {
    stringResultado = stringCompleta.replaceAll(stringCompleta, input);
    return stringResultado;
  }

  if (isNumeric(input1)) {
    num1 = double.parse(listInputs.num1);
  }

  if (isNumeric(input2)) {
    num2 = double.parse(listInputs.num2);
  }
  String resultadoX = "";
  if(!(sinal == "√")) {
    if (input1[input1.length - 1] == "x" && input2[input2.length - 1] == "x") {
      numOfX = 3;

      num1 = double.parse(input1.substring(0, input1.length - 1));
      num2 = double.parse(input2.substring(0, input2.length - 1));

    } else if (input1[input1.length - 1] == "x") {
      num1 = double.parse(input1.substring(0, input1.length - 1));
      numOfX = 1;
    } else if (input2[input2.length - 1] == "x") {
      num2 = double.parse(input2.substring(0, input2.length - 1));
      numOfX = 2;
    } else {
      numOfX = 0;
    }
  }
  List<double> resultados = [];
  double? resultado = 0;
  List<String> numerosPower = [];

  /// potencia

  numerosPower = [];
  switch (sinal) {
    case "^":
      resultado = pow(num1, num2) as double;
      switch (numOfX) {
        case 0:
          break;
        case 1:
          resultadoX = resultado.toString() + "x^"+num2.toString();
          break;
        case 2:
          resultadoX = resultado.toString() + "x^"+num2.toString();
          break;
        case 3:
          resultadoX = resultado.toString() + "x^2";
          break;
      }
      break;
    case "X":
      resultado = num1 * num2;
      switch (numOfX) {
        case 0:
          break;
        case 1:
          resultadoX = resultado.toString() + "x";
          break;
        case 2:
          resultadoX = resultado.toString() + "x";
          break;
        case 3:
          resultadoX = resultado.toString() + "x^2";
          break;
      }
      break;

    case "÷":
      resultado = num1 / num2;
      switch (numOfX) {
        case 0:
          break;
        case 1:
          resultadoX = resultado.toString() + "x";
          break;
        case 2:
          resultadoX = resultado.toString() + "x";
          break;
        case 3:
          resultadoX = resultado.toString() + "x^2";
          break;
      }
      break;
    case "-":
      switch (numOfX) {
        case 0:
          num2 = double.parse(removeSinal(num2.toString()));
          resultado = num1 -num2;
          break;
        case 1:
          return input;
          break;
        case 2:
          return input;
          //incalculavel
          resultadoX = resultado.toString() + "x^2";
          break;
        case 3:
          resultado = num1 -num2;
          resultadoX = resultado.toString() + "x";
          break;
      }
      break;
    case "+":
      switch (numOfX) {
        case 0:
          resultado = num1 + num2;
          break;
        case 1:
          return input;
          // incalculavel
        case 2:
          return input;
          // incalculavel

        case 3:
          resultado = num1 + num2;
          resultadoX = resultado.toString() + "x";
          break;
      }
      break;
    case "√":
      resultado = sqrt(num2);
      break;
  }
  if(!(sinal == "√")){
    stringCalculada = input1 + sinal + input2;
  }

  if (resultadoX != "") {
    stringResultado = stringCompleta.replaceAll(stringCalculada, resultadoX);
  } else {
    stringResultado =
        stringCompleta.replaceAll(stringCalculada, resultado.toString());
  }
  stringResultado = removeSinalDuplo(stringResultado);
  return stringResultado;
}
