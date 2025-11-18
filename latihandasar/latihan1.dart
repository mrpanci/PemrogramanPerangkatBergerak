class Hewan {
  String nama;
  double berat;

  Hewan(this.nama, this.berat);

  void makan(double porsi) {
    berat += porsi;
  }
}

class Kucing extends Hewan {
  String warnaBulu;

  Kucing(String nama, double berat, this.warnaBulu) : super(nama, berat);

  @override
  void makan(double porsi) {
    print("Kucing $nama sedang makan sebanyak $porsi gram.");
    berat += porsi / 1000;
  }
}

void main() {
  var kucing1 = Kucing("Miko", 3.5, "Putih");
  var kucing2 = Kucing("Oyen", 4.0, "Oranye");

  kucing1.makan(200);
  kucing2.makan(150);

  print("Berat ${kucing1.nama} sekarang: ${kucing1.berat.toStringAsFixed(2)} kg");
  print("Berat ${kucing2.nama} sekarang: ${kucing2.berat.toStringAsFixed(2)} kg");
}