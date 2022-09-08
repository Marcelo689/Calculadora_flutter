class Lados {
  String esquerda = "";
  String direita = "";
  List<String> incalculavelE = [];
  List<String> incalculavelD = [];

  Lados(esquerda, direita, incalculavelE, incalculavelD) {
    this.esquerda = esquerda;
    this.direita = direita;
    this.incalculavelE = incalculavelE;
    this.incalculavelD = incalculavelD;
  }
  String get esquerdaGet => this.esquerda;
  String get direitaGet => this.direita;
  List<String> get incalculavelEGet => this.incalculavelE;
  List<String> get incalculavelDGet => this.incalculavelD;
}
